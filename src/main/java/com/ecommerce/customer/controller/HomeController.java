package com.ecommerce.customer.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
/**
*
* @author Yuzana Zaw Zaw
*/
@Controller
public class HomeController {

    @GetMapping("/userHome")
    public String home() {
        return "customer/userHome";
    }

    @PostMapping("/subscribe")
    public String subscribe(@RequestParam("email") String email, RedirectAttributes redirectAttributes) {
        System.out.println("Received email: " + email);  
        redirectAttributes.addFlashAttribute("email", email);
        return "redirect:/users/userSignUp";  
    }

    @GetMapping("/userLogin")
    public String userLogin(RedirectAttributes redirectAttributes) {
        return "customer/userLogin";  
    }

}
