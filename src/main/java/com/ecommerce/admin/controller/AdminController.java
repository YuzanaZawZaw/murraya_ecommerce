package com.ecommerce.admin.controller;

import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.ecommerce.admin.model.Admin;
import com.ecommerce.admin.service.AdminService;
import com.ecommerce.config.JWTUtils;
import com.ecommerce.customer.service.UserService;

import jakarta.servlet.http.HttpSession;

/**
 *
 * @author Yuzana Zaw Zaw
 */
@Controller
@RequestMapping("/admin")
public class AdminController {

    private final AuthenticationManager authenticationManager;
    private final JWTUtils jwtUtil;
    private final UserService userService;
    private final AdminService adminService;

    public AdminController(AuthenticationManager authenticationManager, JWTUtils jwtUtil, UserService userService,AdminService adminService) {
        this.authenticationManager = authenticationManager;
        this.jwtUtil = jwtUtil;
        this.userService = userService;
        this.adminService=adminService;
    }

    @GetMapping("/adminLoginForm")
    public String adminLoginForm() {
        return "admin/adminLogin";
    }

    @GetMapping("/adminForgetPasswordForm")
    public String adminForgetPasswordForm() {
        return "admin/forgetPassword";
    }

    @GetMapping("/adminResetPasswordForm")
    public String adminResetPasswordForm() {
        return "admin/resetPassword";
    }

    @GetMapping("/adminHomeModuleForm")
    public String adminHomeModuleForm() {
        return "admin/adminHomeModule";
    }

    @PostMapping("/adminLogin")
    public String adminLogin(@RequestParam String userName, @RequestParam String passwordHash, HttpSession session,
            RedirectAttributes redirectAttributes) {
        try {
            System.out.println("USER AUTHENTICATION FROM ADMIN MODULE");
            String module = "ADMIN_MODULE";
            authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(userName, passwordHash));
            final UserDetails user = userService.loadUserByUsername(userName);
            String token=null;

            if(user!=null){
                token = jwtUtil.generateToken(user, module);
            }else{
                redirectAttributes.addFlashAttribute("error", "Incorrect Username or email1111");
                return "redirect:/admin/adminLoginForm";
            }

            session.setAttribute("token", token);
            System.out.println("successfully login");
            return "admin/adminHomeModule";

        } catch (AuthenticationException e) {
            redirectAttributes.addFlashAttribute("error", "Incorrect Username or email");
            return "redirect:/admin/adminLoginForm";
        }
    }

    @PostMapping("/forgetPassword")
    public String forgetPassword(@RequestParam("email") String email,
            RedirectAttributes redirectAttributes) {
        try {
            Admin user = adminService.findAdminByEmail(email);
            if (user != null) {
                redirectAttributes.addFlashAttribute("email", user.getEmail());
                return "redirect:/admin/adminResetPasswordForm";
            } else {
                redirectAttributes.addFlashAttribute("error", "Email not found");
                return "redirect:/admin/adminForgetPasswordForm";
            }
        } catch (AuthenticationException e) {
            redirectAttributes.addFlashAttribute("error", "Email not found");
            return "redirect:/admin/adminForgetPasswordForm";
        }
    }

    @PostMapping("/resetPassword")
    public String resetPassword(@RequestParam("email") String email,
            @RequestParam("passwordHash") String passwordHash,
            RedirectAttributes redirectAttributes, Model model) {
        try {
            Admin admin = adminService.findAdminByEmail(email);
            if (admin != null) {
                adminService.updateAdminByEmail(passwordHash, admin);
                redirectAttributes.addFlashAttribute("success", "Your password is successfully updated");
                return "redirect:/admin/adminLoginForm";
            } else {
                redirectAttributes.addFlashAttribute("error", "Email not found");
                return "redirect:/admin/adminResetPasswordForm";
            }
        } catch (AuthenticationException e) {
            redirectAttributes.addFlashAttribute("error", "Email not found");
            return "redirect:/admin/adminLoginForm";
        }
    }

}
