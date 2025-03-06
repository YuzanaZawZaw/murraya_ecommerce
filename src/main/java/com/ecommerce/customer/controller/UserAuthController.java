package com.ecommerce.customer.controller;

import org.springframework.web.bind.annotation.PostMapping;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.ecommerce.config.CustomUserDetailsService;
import com.ecommerce.config.JWTUtils;
import com.ecommerce.customer.model.User;
import com.ecommerce.customer.service.UserService;

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
    public ResponseEntity<?> login(@RequestParam String userName, @RequestParam String passwordHash, HttpSession session,
            RedirectAttributes redirectAttributes, Model model) {
        try {
            User existUser = userService.findUserByUserName(userName);
            if (existUser == null) {
                redirectAttributes.addFlashAttribute("error", "Incorrect Username");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Incorrect Username");
            } else {
                String module = "USER_MODULE";
                String role = "USER";
                authenticationManager.authenticate(
                        new UsernamePasswordAuthenticationToken(userName, passwordHash));
                final UserDetails userDetails = customUserDetailsService.loadUserByUsername(userName);
                String token = null;

                if (userDetails != null) {
                    token = jwtUtil.generateToken(userDetails,module,role);
                    session.setAttribute("token", token);
                    return ResponseEntity.ok(Map.of("token", token));
                } else {
                    redirectAttributes.addFlashAttribute("error", "Incorrect Username or password");
                    return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Incorrect Username or password");
                }
            }
        } catch (AuthenticationException e) {
            redirectAttributes.addFlashAttribute("error", "Incorrect Username or password");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Incorrect Username or password");
        }
    }

    @PostMapping("/forgetPassword")
    public String forgetPassword(@RequestParam("email") String email, RedirectAttributes redirectAttributes,
            Model model) {
        try {
            User user = userService.findUserByEmail(email);
            if (user != null) {
                redirectAttributes.addFlashAttribute("email", user.getEmail());
                return "redirect:/users/resetPasswordForm";
            } else {
                redirectAttributes.addFlashAttribute("error", "Email not found");
                return "redirect:/users/forgetPasswordForm";
            }
        } catch (AuthenticationException e) {
            redirectAttributes.addFlashAttribute("error", "Email not found");
            return "redirect:/users/forgetPasswordForm";
        }
    }

    @PostMapping("/resetPassword")
    public String resetPassword(@RequestParam("email") String email, @RequestParam("passwordHash") String passwordHash,
            RedirectAttributes redirectAttributes, Model model) {
        try {
            User user = userService.findUserByEmail(email);
            if (user != null) {
                userService.updateUserByEmail(passwordHash, user);
                redirectAttributes.addFlashAttribute("success", "Your password is successfully updated");
                return "redirect:/users/userLoginForm";
            } else {
                redirectAttributes.addFlashAttribute("error", "Email not found");
                return "redirect:/users/resetPasswordForm";
            }
        } catch (AuthenticationException e) {
            redirectAttributes.addFlashAttribute("error", "Email not found");
            return "redirect:/users/userLoginForm";
        }
    }

    @PostMapping("/register")
    public String createUser(User user, RedirectAttributes redirectAttributes) {
        try {
            User userByEmail=userService.findUserByEmail(user.getEmail());
            User userByUsername=userService.findUserByUserName(user.getUserName());
            if(userByEmail!=null){
                redirectAttributes.addFlashAttribute("error", "Your email is already used");
                return "redirect:/users/userSignUpForm";
            }
            if(userByUsername!=null){
                redirectAttributes.addFlashAttribute("error", "Username is already used");
                return "redirect:/users/userSignUpForm";
            }
            userService.createUser(user);
            redirectAttributes.addFlashAttribute("success", "User successfully created!");
            return "redirect:/users/userLoginForm";  
            
        } catch (AuthenticationException e) {
            redirectAttributes.addFlashAttribute("error", "Authentication error");
            return "redirect:/users/userSignUpForm";
        }
    }
}