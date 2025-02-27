package com.ecommerce.admin.service;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.ecommerce.admin.model.Admin;
import com.ecommerce.admin.repository.AdminRepository;
/**
 *
 * @author Yuzana Zaw Zaw
 */
@Service
public class AdminService {

    private final AdminRepository adminRepository;

    private final PasswordEncoder passwordEncoder;

    public AdminService(PasswordEncoder passwordEncoder,AdminRepository adminRepository) {
        this.passwordEncoder = passwordEncoder;
        this.adminRepository = adminRepository;
    }

    public Admin findAdminByEmail(String email) {
        Admin admin = adminRepository.findByEmail(email);
        return admin;
    }

    public Admin findAdminByUsername(String username) {
        Admin admin = adminRepository.findByUserName(username);
        return admin;
    }

    public Admin updateAdminByEmail(String passwordHash, Admin admin) {
        System.out.println("existing password hash"+admin.getPasswordHash());
        String newPasswordHash=passwordEncoder.encode(passwordHash);
        System.out.println("new Pasword hash"+newPasswordHash);
        admin.setPasswordHash(newPasswordHash);
        return adminRepository.save(admin);
    }

}
