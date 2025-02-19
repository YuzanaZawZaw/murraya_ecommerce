package com.example.controller;

import org.springframework.web.bind.annotation.PostMapping;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.config.JWTUtils;
import com.example.service.UserService;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;

@RestController
@RequestMapping("/auth")
public class AuthController {

     @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private JWTUtils jwtUtil;

    @Autowired
    private UserService userService;

    @PostMapping("/login")
    public Map<String, String> login(@RequestBody Map<String, String> credentials) {
        authenticationManager.authenticate(
            new UsernamePasswordAuthenticationToken(credentials.get("userName"), credentials.get("password"))
        );
        final UserDetails user = userService.loadUserByUsername(credentials.get("userName"));
        System.out.println("user"+user.getUsername());
        final String token = jwtUtil.generateToken(user);

        return Map.of("token", token);
        
    }
}