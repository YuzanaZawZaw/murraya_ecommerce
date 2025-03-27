package com.ecommerce.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.GetMapping;

import com.ecommerce.config.JWTUtils;
import com.ecommerce.dto.OrderHistoryDTO;
import com.ecommerce.dto.OrderRequestDTO;
import com.ecommerce.service.OrderService;

import java.util.List;

/**
 *
 * @author Yuzana Zaw Zaw
 */
@RestController
@RequestMapping("/users/orders")
public class OrderController {

    @Autowired
    private OrderService orderService;

    @Autowired
    private JWTUtils jwtUtil;

    @PostMapping("/placeOrder")
    public ResponseEntity<?> placeOrder(@RequestHeader("Authorization") String authorizationHeader,@RequestBody OrderRequestDTO orderRequest) {
        try {
            String token = authorizationHeader.replace("Bearer ", "");
            Long userId = jwtUtil.extractUserId(token);
            if (userId == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid or expired token");
            }
            orderService.placeOrder(userId,orderRequest);
            return ResponseEntity.ok("Order placed successfully!");
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Error placing order: " + e.getMessage());
        }
    }

    @GetMapping("/orderHistory")
    public ResponseEntity<?> orderHistoryByUserId(@RequestHeader("Authorization") String authorizationHeader) {
        try {
            String token = authorizationHeader.replace("Bearer ", "");
            Long userId = jwtUtil.extractUserId(token);
            if (userId == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid or expired token");
            }
            List<OrderHistoryDTO> orderHistory = orderService.getOrderHistoryByUserId(userId);
            return ResponseEntity.ok(orderHistory);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error fetching order history: " + e.getMessage());
        }
    }
}
