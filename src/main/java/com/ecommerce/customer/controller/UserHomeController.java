package com.ecommerce.customer.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.ecommerce.admin.model.Category;
import com.ecommerce.admin.service.CategoryService;

import jakarta.servlet.http.HttpSession;

/**
*
* @author Yuzana Zaw Zaw
*/
@Controller
@RequestMapping("/users")
public class UserHomeController {

    @Autowired
    private CategoryService categoryService;

    @GetMapping("/userHome")
    public String home(Model model,HttpSession session) {
        Map<Category, List<Category>> categoryHierarchy = categoryService.getCategoryHierarchy();
        session.setAttribute("categories", categoryHierarchy);
        return "customer/userHome";
    }

    @PostMapping("/subscribe")
    public String subscribe(@RequestParam("email") String email, RedirectAttributes redirectAttributes) {
        System.out.println("Received email: " + email);  
        redirectAttributes.addFlashAttribute("email", email);
        return "redirect:/users/userSignUpForm";  
    }

    @GetMapping("/userSignUpForm")
    public String userSignUp() {
        return "customer/userSignUp";  
    }

    @GetMapping("/userLoginForm")
    public String userLogin() {
        return "customer/userLogin";  
    }

    @GetMapping("/forgetPasswordForm")
    public String forgetPassword() {
        return "customer/forgetPassword";
    }

    @GetMapping("/resetPasswordForm")
    public String resetPassword() {
        return "customer/resetPassword";
    }

    @GetMapping("/userHomeModuleForm")
    public String userHomeModule() {
        return "customer/userHomeModule";
    }

    @GetMapping("/discountItems")
    public String discountItems() {
        return "customer/discountItems";
    }

    @GetMapping("/productsInCategoryForm")
    public String productDetailsByCategoryId(@RequestParam String categoryId,Model model) {
        model.addAttribute("categoryId", categoryId);
        return "customer/productsInCategory";
    }

    @GetMapping("/wishlist")
    public String productDetailsWishList() {
        return "customer/favoriteItems";
    }

    @GetMapping("/deliveryFreeItems")
    public String deliveryFreeItems() {
        return "customer/deliveryFreeItems";
    }

    @GetMapping("/categories")
    public String getCategories(Model model) {
        Map<Category, List<Category>> categoryHierarchy = categoryService.getCategoryHierarchy();
        model.addAttribute("categories", categoryHierarchy);
        return "/userHome";
    }


    @GetMapping("/parentCategories")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> parentCategories(Model model) {
        List<Category> parentCategoryList = categoryService.getTopLevelCategories();
        Map<String, Object> response = new HashMap<>();
        response.put("parentCategoryList", parentCategoryList);
        System.out.println("parentCategoryList"+parentCategoryList);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/childCategories")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> childCategories() {
        List<Category> childCategoryList = categoryService.getChildCategory();
        Map<String, Object> response = new HashMap<>();
        response.put("childCategoryList", childCategoryList);
        System.out.println("childCategoryList"+childCategoryList);
        return ResponseEntity.ok(response);
    }
}
