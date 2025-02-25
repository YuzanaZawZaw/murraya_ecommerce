package com.ecommerce.customer.controller;

import org.springframework.web.bind.annotation.PostMapping;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.ecommerce.config.JWTUtils;
import com.ecommerce.customer.model.User;
import com.ecommerce.customer.service.UserService;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
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
    public String login(@RequestParam String userName, @RequestParam String passwordHash, HttpSession session) {
        try {
            authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(userName, passwordHash));
            final UserDetails user = userService.loadUserByUsername(userName);
            final String token = jwtUtil.generateToken(user);

            session.setAttribute("token", token);
            return "customer/userHomeModule";
        } catch (AuthenticationException e) {
            session.setAttribute("error", "Session expired. Please log in again.");
            return "customer/userLogin";
        }
    }

    @PostMapping("/forgetPassword")
    public String forgetPassword(@RequestParam("email") String email, RedirectAttributes redirectAttributes,
            Model model) {
        try {
            User user = userService.findUserByEmail(email);
            if (user != null) {
                redirectAttributes.addFlashAttribute("email", user.getEmail());
                return "redirect:/resetPasswordForm";
            } else {
                redirectAttributes.addFlashAttribute("error", "Email not found");
                return "redirect:/forgetPasswordForm";
            }
        } catch (AuthenticationException e) {
            redirectAttributes.addFlashAttribute("error", "Email not found");
            return "redirect:/forgetPasswordForm";
        }
    }

    @PostMapping("/resetPassword")
    public String resetPassword(@RequestParam("email") String email, @RequestParam("passwordHash") String passwordHash,
            RedirectAttributes redirectAttributes, Model model) {
        try {
            User user = userService.findUserByEmail(email);
            if (user != null) {
                userService.updateUserByEmail(passwordHash, user);
                model.addAttribute("success", "Your password is successfully updated");
                return "customer/userLogin";
            } else {
                redirectAttributes.addFlashAttribute("error", "Email not found");
                return "redirect:/resetPasswordForm";
            }
        } catch (AuthenticationException e) {
            redirectAttributes.addFlashAttribute("error", "Email not found");
            return "/customer/userLogin";
        }
    }
}