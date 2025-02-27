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

    @Autowired
    private CustomUserDetailsService customUserDetailsService;

    @PostMapping("/login")
    public String login(@RequestParam String userName, @RequestParam String passwordHash, HttpSession session,
            RedirectAttributes redirectAttributes, Model model) {
        try {
            User existUser = userService.findUserByUserName(userName);
            if (existUser == null) {
                redirectAttributes.addFlashAttribute("error", "Incorrect Username");
                return "redirect:/userLogin";
            } else {
                String module = "USER_MODULE";
                String role = "USER";
                authenticationManager.authenticate(
                        new UsernamePasswordAuthenticationToken(userName, passwordHash));
                final UserDetails userDetails = customUserDetailsService.loadUserByUsername(userName);
                String token = null;

                if (userDetails != null) {
                    token = jwtUtil.generateToken(userDetails, module, role);
                    session.setAttribute("token", token);
                    return "customer/userHomeModule";
                } else {
                    redirectAttributes.addFlashAttribute("error", "Incorrect Username or password");
                    return "redirect:/userLogin";
                }

            }

        } catch (AuthenticationException e) {
            redirectAttributes.addFlashAttribute("error", "Incorrect Username or password");
            return "redirect:/userLogin";
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
                redirectAttributes.addFlashAttribute("success", "Your password is successfully updated");
                return "redirect:/userLogin";
            } else {
                redirectAttributes.addFlashAttribute("error", "Email not found");
                return "redirect:/resetPasswordForm";
            }
        } catch (AuthenticationException e) {
            redirectAttributes.addFlashAttribute("error", "Email not found");
            return "redirect:/userLogin";
        }
    }
}