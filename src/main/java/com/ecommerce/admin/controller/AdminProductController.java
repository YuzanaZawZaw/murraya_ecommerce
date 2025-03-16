package com.ecommerce.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.ecommerce.admin.dto.ProductDTO;
import com.ecommerce.admin.dto.ProductDiscountDto;
import com.ecommerce.admin.dto.ProductViewDetailsDto;
import com.ecommerce.admin.model.Category;
import com.ecommerce.admin.model.ErrorResponse;
import com.ecommerce.admin.service.CategoryService;
import com.ecommerce.customer.dto.ImageDTO;
import com.ecommerce.customer.model.Discount;
import com.ecommerce.customer.model.Product;
import com.ecommerce.customer.model.User;
import com.ecommerce.customer.service.DiscountService;
import com.ecommerce.customer.service.ImageService;
import com.ecommerce.customer.service.ProductService;
import com.ecommerce.customer.service.UserService;

/**
 *
 * @author Yuzana Zaw Zaw
 */
@Controller
@RequestMapping("/admin")
public class AdminProductController {

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private ProductService productService;

    @Autowired
    private UserService userService;

    @Autowired
    private ImageService productImageService;

    @Autowired
    private DiscountService discountService;

    @GetMapping("/customerManagement")
    public String customerManagement(Model model) {
        List<User> userList = userService.getAllUsers();
        model.addAttribute("userList", userList);
        return "admin/customerManagement";
    }

    @GetMapping("/productManagement")
    public String productManagementForm(Model model) {
        List<Product> productList = productService.getProductList();
        model.addAttribute("productList", productList);
        return "admin/productManagement";
    }

    @GetMapping("/categoryManagement")
    public String categoryManagement(Model model) {
        List<Category> categoryList = categoryService.getCategoryList();
        model.addAttribute("categoryList", categoryList);
        return "admin/categoryManagement";
    }

    @GetMapping("/productReviewsManagement")
    public String productReviewManagement(Model model) {
        return "admin/productReviewsManagement";
    }

    @GetMapping("/discountManagement")
    public String discountManagement(Model model) {
        List<Discount> discountList = discountService.getDiscountList();
        model.addAttribute("discountList", discountList);
        return "admin/discountManagement";
    }

    @GetMapping("/viewProduct/{productId}")
    @ResponseBody
    public ResponseEntity<?> viewProductDetails(@PathVariable int productId) {
        ProductViewDetailsDto existingProduct = productService.getProductById(productId);
        Map<String, Object> response = new HashMap<>();
        response.put("product", existingProduct);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/viewProductDetails/{productId}")
    public String productDetails(@PathVariable int productId) {
        return "admin/productDetails";
    }

    @GetMapping("/viewDiscountDetails/{discountId}")
    public String viewDiscountDetails(@PathVariable int discountId,Model model) {
        List<ProductDiscountDto> productList = productService.getProductListByDiscountId(discountId);
        model.addAttribute("productList", productList);
        return "admin/discountDetails";
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
        if (existingCategory != null) {
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
        try {
            if (existingCategory != null) {
                existingCategory.setName(updatedCategory.getName());
                existingCategory.setDescription(updatedCategory.getDescription());
                existingCategory.setParentCategory(updatedCategory.getParentCategory());

                Category savedCategory = categoryService.savedCategory(existingCategory);
                return ResponseEntity.ok(savedCategory);
            } else {
                return ResponseEntity.status(400).body("Category doesn't exist");
            }
        } catch (Exception e) {
            ErrorResponse errorResponse = new ErrorResponse("Can't update category " + e.getMessage());
            return ResponseEntity.status(500).body(errorResponse);
        }

    }

    @PostMapping("/addProduct")
    public ResponseEntity<?> addProduct(@RequestBody Product product) {
        System.out.println("add product");
        Product newProduct = productService.addProduct(product);
        return ResponseEntity.ok(newProduct);
    }

    @DeleteMapping("/deleteProduct/{productId}")
    public ResponseEntity<?> deleteProduct(@PathVariable int productId) {
        System.out.println("Hello from delete controller: " + productId);
        try {
            ProductViewDetailsDto existingProduct = productService.getProductById(productId);

            if (existingProduct == null) {
                return ResponseEntity.status(400).body("Product id : " + productId + " not found");
            }

            productService.deleteProduct(productId);
            return ResponseEntity.ok("Product deleted successfully");
        } catch (Exception e) {
            ErrorResponse errorResponse = new ErrorResponse(
                    "Product id : " + productId + " not found" + e.getMessage());
            return ResponseEntity.status(500).body(errorResponse);
        }
    }

    // Update category
    @PutMapping("/updateProduct/{productId}")
    public ResponseEntity<?> updateProduct(@PathVariable int productId, @RequestBody Product product) {
        System.out.println("id from updateProduct::::" + productId);

        Product existingProduct = productService.getProductByProductId(productId);
        try {
            if (existingProduct != null) {
                existingProduct.setName(product.getName());
                existingProduct.setDescription(product.getDescription());
                existingProduct.setPrice(product.getPrice());
                existingProduct.setStockQuantity(product.getStockQuantity());
                existingProduct.setCategory(product.getCategory());
                existingProduct.setStatus(product.getStatus());

                productService.saveProduct(existingProduct);
                return ResponseEntity.ok(existingProduct);
            } else {
                return ResponseEntity.status(400).body("Product doesn't exist");
            }
        } catch (Exception e) {
            ErrorResponse errorResponse = new ErrorResponse("Can't update product " + e.getMessage());
            return ResponseEntity.status(500).body(errorResponse);
        }

    }

    @PostMapping("/uploadProductImages/{productId}")
    public ResponseEntity<String> uploadImage(
            @PathVariable int productId,
            @RequestParam("images") MultipartFile[] images) {
        try {
            if (images == null || images.length == 0) {
                return ResponseEntity.badRequest().body("No files uploaded");
            }
            productImageService.saveImage(productId, images);
            return ResponseEntity.ok("Image uploaded successfully");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Image upload failed");
        }
    }

    @GetMapping("/productImage/{imageId}")
    public ResponseEntity<byte[]> getImage(@PathVariable int imageId) {
        byte[] imageData = productImageService.getImageById(imageId);
        String imageContentType = productImageService.getImageContentTypeById(imageId);
        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(imageContentType))
                .body(imageData);
    }

    @GetMapping("/productImages/{productId}")
    public ResponseEntity<List<ImageDTO>> getProductImages(@PathVariable int productId) {
        List<ImageDTO> images = productImageService.getImagesByProductId(productId);
        return ResponseEntity.ok(images);
    }

    @DeleteMapping("/deleteProductImage/{imageId}")
    public ResponseEntity<?> deleteProductImage(@PathVariable int imageId) {
        System.out.println("Hello from delete controller: " + imageId);
        try {
            byte[] imageData = productImageService.getImageById(imageId);

            if (imageData == null) {
                return ResponseEntity.status(400).body("Image id : " + imageId + " not found");
            }

            productImageService.deleteImageById(imageId);
            return ResponseEntity.ok("Image deleted successfully");
        } catch (Exception e) {
            ErrorResponse errorResponse = new ErrorResponse("Image id : " + imageId + " not found" + e.getMessage());
            return ResponseEntity.status(500).body(errorResponse);
        }
    }

    @GetMapping("/products")
    public ResponseEntity<List<ProductDTO>> getAllProducts() {
        List<ProductDTO> products = productService.getAllProducts();
        return ResponseEntity.ok(products);
    }

    @GetMapping("/products/search")
    public ResponseEntity<?> searchProducts(@RequestParam String query, Pageable pageable) {
        Page<ProductDiscountDto> products = productService.searchProducts(query, pageable);
        return ResponseEntity.ok(products);
    }

    @GetMapping("products/productNames")
    public ResponseEntity<?> getProductNames(@RequestParam String query) {
        List<ProductDTO> products = productService.getAllProducts(query);
        return ResponseEntity.ok(products);
    }

    @PostMapping("/{productId}/assign-discount")
    public ResponseEntity<String> assignDiscount(@PathVariable int productId, @RequestParam int discountId) {
        try {
            productService.assignDiscountToProduct(productId, discountId);
            return ResponseEntity.ok("Discount assigned successfully");
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}
