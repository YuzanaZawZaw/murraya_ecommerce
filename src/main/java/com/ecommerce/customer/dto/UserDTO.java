package com.ecommerce.customer.dto;

import com.ecommerce.admin.model.Status;
import com.ecommerce.customer.model.Role;
/**
 *
 * @author Yuzana Zaw Zaw
 */
public class UserDTO {
    private Long userId;
    private String email;
    private String firstName;
    private String lastName;
    private String passwordHash;
    private String phoneNumber;
    private String userName;
    private Role role;
    public Role getRole() {
        return role;
    }
    public void setRole(Role role) {
        this.role = role;
    }
    public Status getStatus() {
        return status;
    }
    public void setStatus(Status status) {
        this.status = status;
    }
    private Status status;
    public Long getUserId() {
        return userId;
    }
    public void setUserId(Long userId) {
        this.userId = userId;
    }
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }
    public String getFirstName() {
        return firstName;
    }
    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }
    public String getLastName() {
        return lastName;
    }
    public void setLastName(String lastName) {
        this.lastName = lastName;
    }
    public String getPasswordHash() {
        return passwordHash;
    }
    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }
    public String getPhoneNumber() {
        return phoneNumber;
    }
    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }
    public String getUserName() {
        return userName;
    }
    public void setUserName(String userName) {
        this.userName = userName;
    }

    public UserDTO() {
    }
    public UserDTO(Long userId, String email, String firstName, String lastName, String passwordHash, String phoneNumber, String userName, Role role, Status status, String createdAt, String updatedAt) {
        this.userId = userId;
        this.email = email;
        this.firstName = firstName;
        this.lastName = lastName;
        this.passwordHash = passwordHash;
        this.phoneNumber = phoneNumber;
        this.userName = userName;
        this.role = role;
        this.status = status;
    }
    
}
