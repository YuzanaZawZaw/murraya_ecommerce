package com.ecommerce.service;

import java.util.List;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.ecommerce.dto.UserDTO;
import com.ecommerce.model.Role;
import com.ecommerce.model.Status;
import com.ecommerce.model.User;
import com.ecommerce.repository.RoleRepository;
import com.ecommerce.repository.StatusRepository;
import com.ecommerce.repository.UserRepository;

/**
 *
 * @author Yuzana Zaw Zaw
 */
@Service
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final RoleRepository roleRepository;
    private final StatusRepository statusRepository;

    public UserService(UserRepository userRepository, PasswordEncoder passwordEncoder,
            RoleRepository roleRepository, StatusRepository statusRepository) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.roleRepository = roleRepository;
        this.statusRepository = statusRepository;
    }

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public User getUserById(int id) {
        return userRepository.findById(id).orElse(null);
    }

    public void createUser(UserDTO user) {
        User newUser = new User();
        if (user.getUserName() == null || user.getUserName().trim().isEmpty()) {
            throw new IllegalArgumentException("Username cannot be null or empty.");
        }
        if (user.getPasswordHash() == null || user.getPasswordHash().trim().isEmpty()) {
            throw new IllegalArgumentException("Password cannot be null or empty.");
        }
        
        Role role = roleRepository.findByRoleId((long) 3);// DEFAULT USER
        Status status = statusRepository.findByStatusId(1);// DEFAULT ACTIVE
        if (status == null || role == null || role.getRoleName() == null || role.getRoleName().trim().isEmpty()) {
            throw new IllegalArgumentException("Invalid role specified for the user");
        }
        
        newUser.setPasswordHash(passwordEncoder.encode(user.getPasswordHash()));
        newUser.setUserName(user.getUserName());
        newUser.setEmail(user.getEmail());  
        newUser.setFirstName(user.getFirstName());
        newUser.setLastName(user.getLastName());
        newUser.setPhoneNumber(user.getPhoneNumber());
        newUser.setRole(role);
        newUser.setStatus(status);  
        newUser.setCreatedAt(java.time.LocalDateTime.now().atZone(java.time.ZoneId.systemDefault()).toInstant());

        userRepository.save(newUser);
    }

    public User updateUser(int id, User updatedUser) {
        return userRepository.findById(id).map(existingUser -> {
            existingUser.setUserName(updatedUser.getUserName());
            existingUser.setEmail(updatedUser.getEmail());
            existingUser.setFirstName(updatedUser.getFirstName());
            existingUser.setLastName(updatedUser.getLastName());
            existingUser.setPhoneNumber(updatedUser.getPhoneNumber());
            existingUser.setUpdatedAt(java.time.LocalDateTime.now().atZone(java.time.ZoneId.systemDefault()).toInstant());
            // Check if password is updated
            if (updatedUser.getPasswordHash() != null && !updatedUser.getPasswordHash().isEmpty()) {
                existingUser.setPasswordHash(passwordEncoder.encode(updatedUser.getPasswordHash()));
            }

            return userRepository.save(existingUser);
        }).orElse(null);
    }

    public User updateUserStatus(int userId, int statusId) {
        Status status = statusRepository.findByStatusId(statusId); 
        if (status == null) {
            throw new RuntimeException("Status not found with ID: " + statusId);
        }

        return userRepository.findById(userId).map(existingUser -> {
            existingUser.setStatus(status); 
            return userRepository.save(existingUser);
        }).orElseThrow(() -> new RuntimeException("User not found with ID: " + userId));
    }

    public void deleteUser(int id) {
        userRepository.deleteById(id);
    }

    public List<User> getAllUsersWithRoles() {
        return userRepository.findAllUsersWithRoles();
    }

    public User findUserByUserName(String userName) {
        User user = userRepository.findByUserName(userName);
        return user;
    }

    public User findUserByEmail(String email) {
        User user = userRepository.findByEmail(email);
        return user;
    }

    public User findUserByUsernameAndStatusId(String email,int statusId) {
        User user = userRepository.findUserByUsernameAndStatusId(email,statusId);
        return user;
    }

    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        System.out.println("USER AUTHENTICATION FROM USER MODULE");
        User user = userRepository.findByUserName(username);
        UserDetails userDetails = null;
        if (user != null && "USER".equals(user.getRole().getRoleName())) {
            userDetails = org.springframework.security.core.userdetails.User.builder()
                    .username(user.getUserName())
                    .password(user.getPasswordHash())
                    .authorities(getAuthorities(user.getRole()))
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

    public User updateUserByEmail(String passwordHash, User user) {
        user.setPasswordHash(passwordEncoder.encode(passwordHash));
        System.out.println("updated user::::::: from updateUserByEmail");
        return userRepository.save(user);
    }

    public boolean existsByUsername(String username) {
        User user = userRepository.findByUserName(username);
        if (user != null) {
            return true;
        } else {
            return false;
        }
    }

    public int getTotalUsers() {
        return userRepository.countTotalUsers();
    }

    // public void sendResetPasswordEmail(String email) {
    //     User user = findUserByEmail(email);
    //     if (user == null) {
    //         throw new IllegalArgumentException("No user found with the provided email.");
    //     }

    //     try {
    //         MimeMessage message = mailSender.createMimeMessage();
    //         MimeMessageHelper helper = new MimeMessageHelper(message, true);
    //         helper.setTo(email);
    //         helper.setSubject("Reset Your Password");
    //         helper.setText("<p>Click the link below to reset your password:</p>" +
    //                        "<a href='http://localhost:8080/users/resetPassword?email=" + email + "'>Reset Password</a>", true);
    //         mailSender.send(message);
    //     } catch (Exception e) {
    //         throw new RuntimeException("Failed to send reset password email.", e);
    //     }
    // }
}
