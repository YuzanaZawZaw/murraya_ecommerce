package com.ecommerce.admin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 *
 * @author Yuzana Zaw Zaw
 */
@Controller
@RequestMapping("/admin")
public class AdminProductController {

    @GetMapping("/productManagement")
    public String productManagementForm() {
        return "admin/productManagement";
    }

}
