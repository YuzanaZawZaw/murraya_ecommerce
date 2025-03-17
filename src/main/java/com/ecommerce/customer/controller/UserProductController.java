package com.ecommerce.customer.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ecommerce.customer.dto.ProductDetailsDTO;
import com.ecommerce.customer.service.ProductMetricsService;
import com.ecommerce.customer.service.ProductService;

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
        System.out.println("Hello from showNewArrivals");
        try {
            List<ProductDetailsDTO> newArrivals = productService.getNewArrivals();
            System.out.println("New arrival products::::" + newArrivals);
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

    @PostMapping("/{productId}/like")
    public void incrementLike(@PathVariable Integer productId) {
        productMetricsService.incrementLikes(productId);
    }
}
