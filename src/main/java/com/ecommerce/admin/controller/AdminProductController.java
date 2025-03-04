package com.ecommerce.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ecommerce.admin.model.Category;
import com.ecommerce.admin.model.ErrorResponse;
import com.ecommerce.admin.service.CategoryService;

/**
 *
 * @author Yuzana Zaw Zaw
 */
@Controller
@RequestMapping("/admin")
public class AdminProductController {

    @Autowired
    private CategoryService categoryService;

    @GetMapping("/productManagement")
    public String productManagementForm() {
        return "admin/productManagement";
    }

    @GetMapping("/categoryManagement")
    public String categoryManagement(Model model) {
        List<Category> categoryList = categoryService.getCategoryList();
        model.addAttribute("categoryList", categoryList);
        return "admin/categoryManagement";
    }

    @GetMapping("/categories")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> categories(Model model) {
        List<Category> categoryList = categoryService.getCategoryList();
        Map<String, Object> response = new HashMap<>();
        response.put("categoryList", categoryList);
        model.addAttribute("categoryList", categoryList);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/addCategory")
    public ResponseEntity<?> addCategory(@RequestBody Category category) {
        Category existingCategory = categoryService.getCategoryById(category.getCategoryId());
        if(existingCategory!=null){
            ErrorResponse errorResponse = new ErrorResponse("Category Id is duplicated. Try another one");
            return ResponseEntity.status(400).body(errorResponse);
        }
        Category newCategory = categoryService.addCategory(category);
        return ResponseEntity.ok(newCategory);
    }

    @DeleteMapping("/deleteCategories/{categoryId}")
    public ResponseEntity<?> deleteCategory(@PathVariable String categoryId) {
        System.out.println("Hello from delete controller: " + categoryId);
        try {
            List<Category> categories = categoryService.getTopLevelCategories();
            for (Category category : categories) {
                if (category.getCategoryId().equals(categoryId)) {
                    return ResponseEntity.status(400).body("Parent category can't be deleted.");
                }
            }
            categoryService.deleteCategory(categoryId);
            return ResponseEntity.ok("Category deleted successfully");
        } catch (Exception e) {
            ErrorResponse errorResponse = new ErrorResponse("Parent category can't be deleted: " + e.getMessage());
            return ResponseEntity.status(500).body(errorResponse);
        }
    }

    // Update category
    @PutMapping("/updateCategories/{categoryId}")
    public ResponseEntity<?> updateCategory(@PathVariable String categoryId, @RequestBody Category updatedCategory) {
        System.out.println("id from update category::::" + categoryId);

        Category existingCategory = categoryService.getCategoryById(categoryId);
        try{
            if (existingCategory != null) {
                existingCategory.setName(updatedCategory.getName());
                existingCategory.setDescription(updatedCategory.getDescription());
                existingCategory.setParentCategory(updatedCategory.getParentCategory());
    
                Category savedCategory = categoryService.savedCategory(existingCategory);
                return ResponseEntity.ok(savedCategory);
            }else{
                return ResponseEntity.status(400).body("Category doesn't exist");
            }
        }catch(Exception e){
            ErrorResponse errorResponse = new ErrorResponse("Can't update category "+e.getMessage());
            return ResponseEntity.status(500).body(errorResponse);
        }
            
    }
}
