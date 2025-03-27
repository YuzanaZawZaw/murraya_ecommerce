package com.ecommerce.controller;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.ecommerce.config.CustomUserDetailsService;
import com.ecommerce.config.JWTUtils;
import com.ecommerce.dto.UserDTO;
import com.ecommerce.model.User;
import com.ecommerce.service.UserService;

import jakarta.servlet.http.HttpSession;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;


/**
 *
 * @author Yuzana Zaw Zaw
 */
@Controller
@RequestMapping("/userAuth")
public class UserAuthController {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private JWTUtils jwtUtil;

    @Autowired
    private UserService userService;

    @Autowired
    private CustomUserDetailsService customUserDetailsService;

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestParam String userName, @RequestParam String passwordHash,
            HttpSession session,
            RedirectAttributes redirectAttributes, Model model) {
        System.out.println("user login");
        try {
            User existUser = userService.findUserByUserName(userName);
            if (existUser == null) {
                redirectAttributes.addFlashAttribute("error", "Incorrect Username");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Incorrect Username");
            }
            User existUserByStatus = userService.findUserByUsernameAndStatusId(userName, 1);
            if (existUserByStatus == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Your account is currently suspended");
            }
            authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(userName, passwordHash));
            final UserDetails userDetails = customUserDetailsService.loadUserByUsername(userName);
            if (userDetails == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Incorrect Username or password");
            }
            String token = null;
            String module = "USER_MODULE";
            String role = "USER";
            token = jwtUtil.generateToken(userDetails, module, role,existUser.getUserId());
            return ResponseEntity.ok(Map.of("userToken", token));
        } catch (AuthenticationException e) {
            redirectAttributes.addFlashAttribute("error", "Incorrect Username or password");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Incorrect Username or password");
        }
    }

    @PostMapping("/forgetPassword")
    public ResponseEntity<?> forgetPassword(@RequestParam("email") String email) {
        try {
            User user = userService.findUserByEmail(email);
            if (user != null) {
                return ResponseEntity.ok("Email found");    
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Email not found");
            }
        } catch (AuthenticationException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Email not found");
        }
    }

    @PostMapping("/resetPassword")
    public ResponseEntity<?> resetPassword(@RequestParam("email") String email, @RequestParam("newPassword") String newPassword) {
        try {
            User user = userService.findUserByEmail(email);
            if (user != null) {
                userService.updateUserByEmail(newPassword, user);
                return ResponseEntity.ok("Your password is successfully updated");
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Email not found");
            }
        } catch (AuthenticationException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Email not found");
        }
    }

    @PostMapping("/register")
    public ResponseEntity<?> createUser(@RequestBody UserDTO user) {
        try {
            User userByEmail = userService.findUserByEmail(user.getEmail());
            User userByUsername = userService.findUserByUserName(user.getUserName());
            if (userByEmail != null) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Your email is already used");
            }
            if (userByUsername != null) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Username is already used");
            }
            userService.createUser(user);
            return ResponseEntity.ok("User successfully created!");
        } catch (AuthenticationException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Authentication error");
        }
    }

    @GetMapping("getUserProfile")
    public ResponseEntity<?> getUserProfile(@RequestHeader("Authorization") String authorizationHeader) {
        try {
            String token = authorizationHeader.replace("Bearer ", "");
            Long userId = jwtUtil.extractUserId(token);
            if (userId == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid or expired token");
            }
            User user = userService.getUserById(userId.intValue());
            if (user == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");
            }

            // Return user details as a map
            return ResponseEntity.ok(Map.of(
                "userName", user.getUserName(),
                "email", user.getEmail(),
                "firstName", user.getFirstName(),
                "lastName", user.getLastName()
            ));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error fetching user profile: " + e.getMessage());
        }
    }
    
}