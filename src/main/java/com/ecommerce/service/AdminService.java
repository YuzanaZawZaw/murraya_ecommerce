package com.ecommerce.service;

import java.util.List;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.ecommerce.model.Admin;
import com.ecommerce.model.Role;
import com.ecommerce.repository.AdminRepository;
/**
 *
 * @author Yuzana Zaw Zaw
 */
@Service
public class AdminService{

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

    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        System.out.println("USER AUTHENTICATION FROM ADMIN MODULE");
        Admin admin = adminRepository.findByUserName(username);
        UserDetails userDetails=null;
        if (admin != null && "ADMIN".equals(admin.getRole().getRoleName())) {
            userDetails=org.springframework.security.core.userdetails.User.builder()
            .username(admin.getUserName())
            .password(admin.getPasswordHash())
            .authorities(getAuthorities(admin.getRole()))
            .build();
            
        }
        return userDetails;
    }

    private List<GrantedAuthority> getAuthorities(Role role) {
        if (role == null || role.getRoleName() == null || role.getRoleName().trim().isEmpty()) {
            return List.of();
        }
        return List.of(new SimpleGrantedAuthority("ROLE_" + role.getRoleName().toUpperCase()));
    }

    public boolean existsByUsername(String username) {
        Admin admin = adminRepository.findByUserName(username);
        if(admin!=null){
            return true;
        }else{
            return false;
        }
    }

}
