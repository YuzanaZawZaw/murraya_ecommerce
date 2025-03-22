package com.ecommerce.admin.controller;

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
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.ecommerce.admin.model.Admin;
import com.ecommerce.admin.service.AdminService;
import com.ecommerce.config.CustomUserDetailsService;
import com.ecommerce.config.JWTUtils;
import com.ecommerce.customer.service.UserService;


/**
 *
 * @author Yuzana Zaw Zaw
 */
@Controller
@RequestMapping("/adminAuth")
public class AdminController {

    private final AuthenticationManager authenticationManager;
    private final JWTUtils jwtUtil;
    private final AdminService adminService;
    private final UserService userService;

    @Autowired
    private CustomUserDetailsService customUserDetailsService;

    public AdminController(AuthenticationManager authenticationManager, JWTUtils jwtUtil, AdminService adminService,
            UserService userService) {
        this.authenticationManager = authenticationManager;
        this.jwtUtil = jwtUtil;
        this.adminService = adminService;
        this.userService = userService;
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

    @GetMapping("/adminDashboard")
    public String adminDashboard(Model model) {
        // double totalSales = dashboardService.getTotalSales();
        // int totalOrders = dashboardService.getTotalOrders();
        // model.addAttribute("totalSales", totalSales);
        // model.addAttribute("totalOrders", totalOrders);
        // @Query("SELECT SUM(o.totalAmount) FROM Order o")
        // Double calculateTotalSales();
        // @Query("SELECT COUNT(o) FROM Order o")
        // int countTotalOrders();
        int totalCustomers = userService.getTotalUsers();
        model.addAttribute("totalCustomers", totalCustomers);

        return "admin/adminDashboard";
    }

    // @PostMapping("/adminLogin")
    // public String adminLogin(@RequestParam String userName, @RequestParam String
    // passwordHash, HttpSession session,
    // RedirectAttributes redirectAttributes) {
    // try {
    // Admin admin = adminService.findAdminByUsername(userName);
    // if (admin == null) {
    // redirectAttributes.addFlashAttribute("error", "Incorrect Username");
    // return "redirect:/adminAuth/adminLoginForm";
    // } else {
    // String module = "ADMIN_MODULE";
    // String role = "ADMIN";
    // authenticationManager.authenticate(
    // new UsernamePasswordAuthenticationToken(userName, passwordHash));

    // final UserDetails user =
    // customUserDetailsService.loadUserByUsername(admin.getUserName());

    // String token = null;

    // if (user != null) {
    // token = jwtUtil.generateToken(user, module, role);
    // } else {
    // redirectAttributes.addFlashAttribute("error", "Incorrect Username or
    // password");
    // return "redirect:/adminAuth/adminLoginForm";
    // }

    // session.setAttribute("token", token);
    // System.out.println("successfully login");
    // return "redirect:/adminAuth/adminDashboard";
    // }

    // } catch (AuthenticationException e) {
    // redirectAttributes.addFlashAttribute("error", "Incorrect Username or
    // password");
    // return "redirect:/adminAuth/adminLoginForm";
    // }
    // }

    @PostMapping("/forgetPassword")
    public String forgetPassword(@RequestParam("email") String email,
            RedirectAttributes redirectAttributes) {
        try {
            Admin user = adminService.findAdminByEmail(email);
            if (user != null) {
                redirectAttributes.addFlashAttribute("email", user.getEmail());
                return "redirect:/adminAuth/adminResetPasswordForm";
            } else {
                redirectAttributes.addFlashAttribute("error", "Email not found");
                return "redirect:/adminAuth/adminForgetPasswordForm";
            }
        } catch (AuthenticationException e) {
            redirectAttributes.addFlashAttribute("error", "Email not found");
            return "redirect:/adminAuth/adminForgetPasswordForm";
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
                return "redirect:/adminAuth/adminLoginForm";
            } else {
                redirectAttributes.addFlashAttribute("error", "Email not found");
                return "redirect:/adminAuth/adminResetPasswordForm";
            }
        } catch (AuthenticationException e) {
            redirectAttributes.addFlashAttribute("error", "Email not found");
            return "redirect:/adminAuth/adminLoginForm";
        }
    }

    @PostMapping("/adminLogin")
    public ResponseEntity<?> adminLogin(@RequestParam String userName, @RequestParam String passwordHash) {
        System.out.println("Admin authentication::::");
        try {
            Admin admin = adminService.findAdminByUsername(userName);
            if (admin == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Incorrect Username");
            }

            authenticationManager.authenticate(
            new UsernamePasswordAuthenticationToken(userName, passwordHash));

            // Load user details
            final UserDetails user = customUserDetailsService.loadUserByUsername(admin.getUserName());

            if (user == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Incorrect Username or password");
            }

            // Generate JWT token
            String module = "ADMIN_MODULE";
            String role = "ADMIN";
            String token = jwtUtil.generateToken(user,module,role,admin.getAdminId());

            // Return the token in the response
            return ResponseEntity.ok(Map.of("token", token));
        } catch (AuthenticationException e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Incorrect Username or password");
        }
    }

}
