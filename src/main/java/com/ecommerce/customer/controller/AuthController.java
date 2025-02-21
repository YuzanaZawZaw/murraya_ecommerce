package com.ecommerce.customer.controller;

import org.springframework.web.bind.annotation.PostMapping;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.ecommerce.config.JWTUtils;
import com.ecommerce.customer.service.UserService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

@Controller
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private JWTUtils jwtUtil;

    @Autowired
    private UserService userService;

    // @PostMapping("/login")
    // public Map<String, String> login(@RequestBody Map<String, String>
    // credentials) {
    // authenticationManager.authenticate(
    // new UsernamePasswordAuthenticationToken(credentials.get("userName"),
    // credentials.get("passwordHash"))
    // );
    // final UserDetails user =
    // userService.loadUserByUsername(credentials.get("userName"));
    // System.out.println("user"+user.getUsername());
    // final String token = jwtUtil.generateToken(user);

    // return Map.of("token", token);

    // }
    
    @PostMapping("/login")
    public String login(@RequestParam String userName, @RequestParam String passwordHash, Model model) {
        try {
            authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(userName, passwordHash));
            final UserDetails user = userService.loadUserByUsername(userName);
            final String token = jwtUtil.generateToken(user);

            model.addAttribute("token", token);
            System.out.println("User authentication::::");
            return "customer/userHomeModule";
        } catch (AuthenticationException e) {
            model.addAttribute("error", "Invalid username or password");
            return "customer/userLogin";
        }
    }
}