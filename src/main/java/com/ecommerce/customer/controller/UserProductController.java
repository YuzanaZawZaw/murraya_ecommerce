package com.ecommerce.customer.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.ecommerce.customer.dto.ProductDetailsDTO;
import com.ecommerce.customer.dto.ProductImagesDetailsDTO;
import com.ecommerce.customer.service.ProductMetricsService;
import com.ecommerce.customer.service.ProductService;
/**
 *
 * @author Yuzana Zaw Zaw
 */
@RestController
@RequestMapping("/users/products")
public class UserProductController {
    @Autowired
    private ProductService productService;

    @Autowired
    private ProductMetricsService productMetricsService;

    @GetMapping("/trending/{categoryId}")
    public ResponseEntity<?> getTrendingProducts(@PathVariable String categoryId) {
        try {
            List<ProductDetailsDTO> dto = productService.getTrendingProducts(categoryId);
            return ResponseEntity.ok(dto);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("No trending product found");
        }
    }

    @GetMapping("/newArrivals")
    public ResponseEntity<?> showNewArrivals() {
        try {
            List<ProductDetailsDTO> newArrivals = productService.getNewArrivals();
            return ResponseEntity.ok(newArrivals);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error fetching new arrivals: " + e.getMessage());
        }
    }

    @PostMapping("/{productId}/view")
    public void incrementView(@PathVariable Integer productId) {
        productMetricsService.incrementViews(productId);
    }

    @PostMapping("/{productId}/purchase")
    public void incrementPurchase(@PathVariable Integer productId) {
        productMetricsService.incrementPurchases(productId);
    }

    @PostMapping("/decrement/{productId}/purchase")
    public void deCrementPurchase(@PathVariable Integer productId) {
        productMetricsService.deCrementPurchases(productId);
    }

    @PostMapping("/{productId}/like")
    public void incrementLike(@PathVariable Integer productId) {
        productMetricsService.incrementLikes(productId);
    }

    @GetMapping("/search")
    public ResponseEntity<?> userSearchProducts(@RequestParam String query) {
        List<ProductDetailsDTO> products = productService.userSearchProducts(query);
        return ResponseEntity.ok(products);
    }

    @GetMapping("/favorites/{productId}")
    public ResponseEntity<?> favoritesProductDetailsByProductId(@PathVariable int productId) {
        try {
            ProductDetailsDTO products = productService.favoritesProductDetailsByProductId(productId);
            return ResponseEntity.ok(products);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error fetching favorite products by productId: " + productId + e.getMessage());
        }
    }

    @GetMapping("/discountProducts")
    public ResponseEntity<?> discountItemsList() {
        try {
            List<ProductDetailsDTO> discountedProducts = productService.getDiscountedProductList();
            return ResponseEntity.ok(discountedProducts);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error fetching discount products : " + e.getMessage());
        }
    }

    @GetMapping("/deliveryFreeProducts")
    public ResponseEntity<?> deliveryFreeItemsList() {
        try {
            List<ProductDetailsDTO> freeDeliveryProducts = productService.getFreeDeliveryProductList();
            return ResponseEntity.ok(freeDeliveryProducts);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error fetching delivery free products : " + e.getMessage());
        }
    }

    @GetMapping("/productsByCategory")
    public ResponseEntity<?> productByCategoryId(@RequestParam String categoryId) {
        try {
            List<ProductDetailsDTO> products = productService.productsByCategoryId(categoryId);
            return ResponseEntity.ok(products);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error fetching delivery free products : " + e.getMessage());
        }

    }

    @GetMapping("/productDetailsInfo")
    public ResponseEntity<?> productDetailsInfo(@RequestParam int productId) {
        try {
            ProductImagesDetailsDTO products = productService.productDetailsInfoByProductId(productId);
            return ResponseEntity.ok(products);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error fetching product details for productId : "+ productId+ e.getMessage());
        }

    }

    @PostMapping("/decrement/{productId}/like")
    public void deCrementLike(@PathVariable Integer productId) {
        productMetricsService.incrementLikes(productId);
    }
}
