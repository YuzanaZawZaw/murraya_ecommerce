package com.ecommerce.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.ecommerce.config.JWTUtils;
import com.ecommerce.dto.ProductImagesDetailsDTO;
import com.ecommerce.model.Cart;
import com.ecommerce.model.Product;
import com.ecommerce.model.User;
import com.ecommerce.service.CartService;
import com.ecommerce.service.ProductService;

/**
 *
 * @author Yuzana Zaw Zaw
 */
@RestController
@RequestMapping("/users/carts")
public class CartController {

    @Autowired
    private CartService cartService;

    @Autowired
    private ProductService productService;

    @Autowired
    private JWTUtils jwtUtil;

    @PostMapping("/addToCart")
    public ResponseEntity<?> addToCart(@RequestHeader("Authorization") String authorizationHeader,
            @RequestBody Cart cart) {
        try {

            // Extract the token from the Authorization header
            String token = authorizationHeader.replace("Bearer ", "");

            // Validate the token and extract the userId
            Long userId = jwtUtil.extractUserId(token);

            if (userId == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid or expired token");
            }
            cart.setProduct(new Product(cart.getProductId()));
            cart.setUser(new User(userId));

            System.out.println("cart: " + cart);
            cartService.addToCart(userId, cart.getProduct().getProductId(), cart.getQuantity());
            return ResponseEntity.ok("Product added to cart");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid or expired token");
        }
    }

    @GetMapping("/shoppingItems")
    public ResponseEntity<?> cartProductDetailsInfo(@RequestHeader("Authorization") String authorizationHeader) {
        try {
            String token = authorizationHeader.replace("Bearer ", "");
            Long userId = jwtUtil.extractUserId(token);

            if (userId == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid or expired token");
            }
            List<Cart> cart = cartService.cartDetailsInfoByUserId(userId);
            List<ProductImagesDetailsDTO> products = productService.cartProductDetailsInfo(cart);
            return ResponseEntity.ok(products);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error fetching product details" + e.getMessage());
        }
    }

    @DeleteMapping("/removeFromCart")
    public ResponseEntity<?> removeFromCart(@RequestHeader("Authorization") String authorizationHeader,
            @RequestParam Long productId) {
        try {
            // Extract the token from the Authorization header
            String token = authorizationHeader.replace("Bearer ", "");

            // Validate the token and extract the userId
            Long userId = jwtUtil.extractUserId(token);

            if (userId == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid or expired token");
            }

            // Call the service to remove the product from the cart
            cartService.removeProductFromCart(userId, productId);

            return ResponseEntity.ok("Product removed from cart");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Failed to remove product from cart");
        }
    }

    @DeleteMapping("/removeAllFromCart")
    public ResponseEntity<?> removeAllFromCart(@RequestHeader("Authorization") String authorizationHeader) {
        try {
            // Extract the token from the Authorization header
            String token = authorizationHeader.replace("Bearer ", "");

            // Validate the token and extract the userId
            Long userId = jwtUtil.extractUserId(token);

            if (userId == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid or expired token");
            }

            // Call the service to remove the product from the cart
            cartService.removeAllProductFromCart(userId);

            return ResponseEntity.ok("Product removed from cart");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Failed to remove product from cart");
        }
    }
}
