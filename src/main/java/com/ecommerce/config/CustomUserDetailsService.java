package com.ecommerce.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.ecommerce.service.AdminService;
import com.ecommerce.service.UserService;
/**
 *
 * @author Yuzana Zaw Zaw
 */
@Service
public class CustomUserDetailsService implements UserDetailsService{

    @Autowired
    @Lazy
    private UserService userService;

    @Autowired
    @Lazy
    private AdminService adminService;

    private static final Logger logger = LoggerFactory.getLogger(CustomUserDetailsService.class);

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        
        String userType = determineUserType(username);
        logger.info("USER TYPE::::::::::::::::::::::::::::",userType);
        UserDetails userDetails=null;

        if ("USER".equals(userType)) {
            userDetails=userService.loadUserByUsername(username);
        } else if ("ADMIN".equals(userType)) {
            userDetails=adminService.loadUserByUsername(username);
        }
        return userDetails;
    }

    private String determineUserType(String username) {
        boolean adminFlag=adminService.existsByUsername(username);
        boolean userFlag=userService.existsByUsername(username);
        if (adminFlag) {
            return "ADMIN";
        } else if (userFlag) {
            return "USER";
        } else {
            throw new UsernameNotFoundException("User not found");
        }
    }

}
