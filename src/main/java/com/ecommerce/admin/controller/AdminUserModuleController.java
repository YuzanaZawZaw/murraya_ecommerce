package com.ecommerce.admin.controller;

import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import com.ecommerce.customer.service.UserService;

/**
 *
 * @author Yuzana Zaw Zaw
 */
@Controller
@RequestMapping("/userManagement")
public class AdminUserModuleController {

    private UserService userService;

    public AdminUserModuleController(UserService userService) {
        this.userService = userService;
    }

    // @DeleteMapping("/deactivateUser/{userId}")
    // public ResponseEntity<?> deactivateUser(@PathVariable int userId) {
    // System.out.println("Hello from delete controller: " + userId);
    // try {
    // userService.deActivateUser(userId); // Only pass the userId
    // return ResponseEntity.ok(Map.of("message", "User deactivated
    // successfully."));
    // } catch (Exception e) {
    // return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
    // .body(Map.of("message", "Failed to deactivate user."));
    // }
    // }

    @PutMapping("/updateUserStatus/{userId}/{statusId}")
    public ResponseEntity<?> updateUserStatus(@PathVariable int userId, @PathVariable int statusId) {
        System.out.println("Updating user status for user ID: " + userId + " to status ID: " + statusId);
        try {
            userService.updateUserStatus(userId, statusId);
            String message = (statusId == 1) ? "User activated successfully." : "User deactivated successfully.";
            return ResponseEntity.ok(Map.of("message", message));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("message", "Failed to update user status."));
        }
    }
}
