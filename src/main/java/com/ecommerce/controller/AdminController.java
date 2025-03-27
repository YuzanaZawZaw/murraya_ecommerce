package com.ecommerce.controller;

import java.time.LocalDate;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
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
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.ecommerce.config.JWTUtils;
import com.ecommerce.dto.ImageDTO;
import com.ecommerce.dto.OrderDTO;
import com.ecommerce.dto.ProductDTO;
import com.ecommerce.dto.ProductDiscountDto;
import com.ecommerce.dto.ProductViewDetailsDto;
import com.ecommerce.model.Category;
import com.ecommerce.model.Discount;
import com.ecommerce.model.ErrorResponse;
import com.ecommerce.model.Product;
import com.ecommerce.model.User;
import com.ecommerce.service.CategoryService;
import com.ecommerce.service.DiscountService;
import com.ecommerce.service.ImageService;
import com.ecommerce.service.OrderService;
import com.ecommerce.service.ProductService;
import com.ecommerce.service.UserService;
/**
 *
 * @author Yuzana Zaw Zaw
 */
@Controller
@RequestMapping("/admin")
public class AdminController {

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

    @Autowired
    private OrderService orderService;

    @Autowired
    private JWTUtils jwtUtil;

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

    @GetMapping("/orderManagement")
    public String orderManagement(Model model) {
        List<OrderDTO> pendingOrders = orderService.getOrdersByStatus("Pending");
        List<OrderDTO> confirmedOrders = orderService.getOrdersByStatus("Confirmed");
        List<OrderDTO> processingOrders = orderService.getOrdersByStatus("Processing");
        List<OrderDTO> cancelledOrders = orderService.getOrdersByStatus("Cancelled");
        List<OrderDTO> shippedOrders = orderService.getOrdersByStatus("Shipped");
        List<OrderDTO> deliveredOrders = orderService.getOrdersByStatus("Delivered");

        model.addAttribute("pendingOrders", pendingOrders);
        model.addAttribute("confirmedOrders", confirmedOrders);
        model.addAttribute("processingOrders", processingOrders);
        model.addAttribute("cancelledOrders", cancelledOrders);
        model.addAttribute("shippedOrders", shippedOrders);
        model.addAttribute("deliveredOrders", deliveredOrders);

        return "admin/orderManagement";
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
    public String viewDiscountDetails(@PathVariable int discountId, Model model) {
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

    @GetMapping("/orders")
    public ResponseEntity<?> getAllOrders() {
        try {
            List<OrderDTO> orders = orderService.getAllOrders();
            return ResponseEntity.ok(orders);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Collections.emptyList());
        }
    }

    @PutMapping("/orders/{orderId}/confirm")
    public ResponseEntity<?> confirmOrder(@PathVariable int orderId) {
        try {
            orderService.confirmOrder(orderId, "Confirmed");
            return ResponseEntity.ok(Map.of("message", "Order confirmed successfully"));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Failed to confirm order: " + e.getMessage()));
        }
    }

    @PutMapping("/orders/{orderId}/processing")
    public ResponseEntity<?> processingOrder(@PathVariable int orderId) {
        try {
            orderService.confirmOrder(orderId, "Processing");
            return ResponseEntity.ok(Map.of("message", "Order Processing successfully"));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Failed to Processing order: " + e.getMessage()));
        }
    }

    @PutMapping("/orders/{orderId}/cancelled")
    public ResponseEntity<?> cancelledOrder(@PathVariable int orderId) {
        try {
            orderService.confirmOrder(orderId, "Cancelled");
            return ResponseEntity.ok(Map.of("message", "Order Cancelled successfully"));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Failed to Cancelled order: " + e.getMessage()));
        }
    }

    @PutMapping("/orders/{orderId}/pending")
    public ResponseEntity<?> pandingOrder(@PathVariable int orderId) {
        try {
            orderService.confirmOrder(orderId, "Pending");
            return ResponseEntity.ok(Map.of("message", "Order pending successfully"));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Failed to pending order: " + e.getMessage()));
        }
    }

    @PutMapping("/orders/{orderId}/shipped")
    public ResponseEntity<?> shippedOrder(@PathVariable int orderId) {
        try {
            orderService.confirmOrder(orderId, "Shipped");
            return ResponseEntity.ok(Map.of("message", "Order Shipped successfully"));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Failed to Shipped order: " + e.getMessage()));
        }
    }

    @PutMapping("/orders/{orderId}/delivered")
    public ResponseEntity<?> deliveredOrder(@PathVariable int orderId) {
        try {
            orderService.confirmOrder(orderId, "Delivered");
            return ResponseEntity.ok(Map.of("message", "Order Delivered successfully"));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Failed to Delivered order: " + e.getMessage()));
        }
    }

    @GetMapping("/orders/{orderId}")
    public ResponseEntity<?> getOrderDetails(@PathVariable int orderId) {
        try {
            OrderDTO orderDetails = orderService.getOrderDetailsById(orderId);
            return ResponseEntity.ok(orderDetails);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Failed to fetch order details: " + e.getMessage()));
        }
    }

    @GetMapping("/orders/orderHistoryByDate")
    public ResponseEntity<?> getOrderHistoryByDate(
            @RequestHeader("Authorization") String authorizationHeader,
            @RequestParam("fromDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fromDate,
            @RequestParam("toDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate toDate) {
        try {
            String token = authorizationHeader.replace("Bearer ", "");
            Long adminId = jwtUtil.extractUserId(token);

            if (adminId == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid or expired token");
            }

            List<OrderDTO> orders = orderService.getOrdersByDateRange(fromDate, toDate);
            return ResponseEntity.ok(orders);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Failed to fetch order history: " + e.getMessage()));
        }
    }
}
