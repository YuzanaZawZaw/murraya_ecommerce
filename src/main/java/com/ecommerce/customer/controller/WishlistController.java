package com.ecommerce.customer.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ecommerce.config.JWTUtils;
import com.ecommerce.customer.dto.ProductDetailsDTO;
import com.ecommerce.customer.model.Wishlist;
import com.ecommerce.customer.service.ProductService;
import com.ecommerce.customer.service.WishlistService;

/**
 *
 * @author Yuzana Zaw Zaw
 */
@RestController
@RequestMapping("/users/wishlists")
public class WishlistController {

    @Autowired
    private WishlistService wishlistService;

    @Autowired
    private JWTUtils jwtUtil;

    @Autowired
    private ProductService productService;

    @PostMapping("/add/{productId}")
public ResponseEntity<?> addToWishlist(@RequestHeader("Authorization") String authorizationHeader,
                                       @PathVariable int productId) {
    try {
        String token = authorizationHeader.replace("Bearer ", "");
        Long userId = jwtUtil.extractUserId(token);

        if (userId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid or expired token");
        }

        // Check if the product is already in the wishlist
        boolean isProductInWishlist = wishlistService.isProductInWishlist(userId, productId);
        if (isProductInWishlist) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body("Product is already in the wishlist");
        }

        wishlistService.addToWishlist(userId, productId);
        return ResponseEntity.ok("Product added to wishlist");
    } catch (Exception e) {
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Failed to add product to wishlist");
    }
}
    @DeleteMapping("/remove/{productId}")
    public ResponseEntity<?> removeFromWishlist(@RequestHeader("Authorization") String authorizationHeader,
            @PathVariable int productId) {
        try {
            String token = authorizationHeader.replace("Bearer ", "");
            Long userId = jwtUtil.extractUserId(token);

            if (userId == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid or expired token");
            }

            wishlistService.removeFromWishlist(userId, productId);
            return ResponseEntity.ok("Product removed from wishlist");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to remove product from wishlist");
        }
    }

    @GetMapping("/items")
    public ResponseEntity<?> getWishlistItems(@RequestHeader("Authorization") String authorizationHeader) {
        try {
            // Extract the token from the Authorization header
            String token = authorizationHeader.replace("Bearer ", "");

            // Validate the token and extract the userId
            Long userId = jwtUtil.extractUserId(token);

            if (userId == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid or expired token");
            }

            // Fetch the wishlist items for the user
            List<Wishlist> wishlistItems = wishlistService.getWishlistItemsByUserId(userId);
            List<ProductDetailsDTO> products = productService.wishlistProductDetailsInfo(wishlistItems);
            return ResponseEntity.ok(products);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error fetching wishlist items: " + e.getMessage());
        }
    }
}
