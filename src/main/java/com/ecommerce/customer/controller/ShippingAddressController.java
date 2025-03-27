package com.ecommerce.customer.controller;

import com.ecommerce.customer.dto.ShippingAddressDTO;
import com.ecommerce.customer.service.ShippingAddressService;
import com.ecommerce.config.JWTUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/users/shippingAddress")
public class ShippingAddressController {

    @Autowired
    private ShippingAddressService shippingAddressService;

    @Autowired
    private JWTUtils jwtUtils;

    @GetMapping("/getShippingAddress")
    public ResponseEntity<?> getShippingAddress(@RequestHeader("Authorization") String authorizationHeader) {
        try {
            String token = authorizationHeader.replace("Bearer ", "");
            Long userId = jwtUtils.extractUserId(token);
            if (userId == null) {
                return ResponseEntity.status(401).body("Invalid or expired token");
            }

            ShippingAddressDTO shippingAddress = shippingAddressService.getShippingAddressByUserId(userId);
            return ResponseEntity.ok(shippingAddress);
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Error fetching shipping address: " + e.getMessage());
        }
    }
}
