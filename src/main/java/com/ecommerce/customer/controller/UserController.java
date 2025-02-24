package com.ecommerce.customer.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.AuthenticationException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.ecommerce.customer.model.User;
import com.ecommerce.customer.service.UserService;
/**
*
* @author Yuzana Zaw Zaw
*/
@Controller
@RequestMapping("/users")
public class UserController {
    @Autowired
    private UserService userService;
    
    @PostMapping("/register")
    public String createUser(User user, RedirectAttributes redirectAttributes) {
        try {
            User userByEmail=userService.findUserByEmail(user.getEmail());
            User userByUsername=userService.findUserByUserName(user.getUserName());
            if(userByEmail!=null){
                redirectAttributes.addFlashAttribute("error", "Your email is already used");
                return "redirect:/users/userSignUp";
            }
            if(userByUsername!=null){
                redirectAttributes.addFlashAttribute("error", "Username is already used");
                return "redirect:/users/userSignUp";
            }
            userService.createUser(user);
            redirectAttributes.addFlashAttribute("success", "User successfully created!");
            return "redirect:/userLogin";  
            
        } catch (AuthenticationException e) {
            redirectAttributes.addFlashAttribute("error", "Authentication error");
            return "redirect:/users/userSignUp";
        }
    }

    @GetMapping("/userSignUp")
    public String userSignUp() {
        return "customer/userSignUp";  
    }

    @GetMapping
    public List<User> getAllUsers() {
        return userService.getAllUsers();
    }

    @GetMapping("/{id}")
    public User getUserById(@PathVariable String id) {
        int userId=Integer.parseInt(id);
        return userService.getUserById(userId);
    }

    @PutMapping("/{id}")
    public User updateUser(@PathVariable int id, @RequestBody User user) {
        return userService.updateUser(id, user);
    }

    @DeleteMapping("/{id}")
    public String deleteUser(@PathVariable int id) {
        userService.deleteUser(id);
        return "User deleted successfully!";
    }

    @GetMapping("/with-roles")
    public List<User> getUsersWithRoles() {
        return userService.getAllUsersWithRoles();
    }
}
