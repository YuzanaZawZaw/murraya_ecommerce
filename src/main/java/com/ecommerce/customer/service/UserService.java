package com.ecommerce.customer.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.ecommerce.customer.model.Role;
import com.ecommerce.customer.model.User;
import com.ecommerce.customer.repository.RoleRepository;
import com.ecommerce.customer.repository.UserRepository;
/**
*
* @author Yuzana Zaw Zaw
*/
@Service
public class UserService implements UserDetailsService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private RoleRepository roleRepository;

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public User getUserById(int id) {
        return userRepository.findById(id).orElse(null);
    }

    public User createUser(User user) {
        user.setPasswordHash(passwordEncoder.encode(user.getPasswordHash()));
        Role role = roleRepository.findByRoleId((long) 3);// DEFAULT USER

        if (role == null || role.getRoleName() == null || role.getRoleName().trim().isEmpty()) {
            throw new IllegalArgumentException("Invalid role specified for the user");
        }
        user.setRole(role);

        return userRepository.save(user);
    }

    public User updateUser(int id, User updatedUser) {
        return userRepository.findById(id).map(existingUser -> {
            existingUser.setUserName(updatedUser.getUserName());
            existingUser.setEmail(updatedUser.getEmail());
            existingUser.setFirstName(updatedUser.getFirstName());
            existingUser.setLastName(updatedUser.getLastName());
            existingUser.setPhoneNumber(updatedUser.getPhoneNumber());

            // Check if password is updated
            if (updatedUser.getPasswordHash() != null && !updatedUser.getPasswordHash().isEmpty()) {
                existingUser.setPasswordHash(passwordEncoder.encode(updatedUser.getPasswordHash()));
            }

            return userRepository.save(existingUser);
        }).orElse(null);
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

    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        System.out.println("Loading user: " + username);

        User user = userRepository.findByUserName(username);
        if (user == null) {
            throw new UsernameNotFoundException("User not found: " + username);
        }

        System.out.println("User found: " + user.getUserName());

        return org.springframework.security.core.userdetails.User.builder()
                .username(user.getUserName())
                .password(user.getPasswordHash())
                .authorities(getAuthorities(user.getRole()))
                .build();
    }

    private List<GrantedAuthority> getAuthorities(Role role) {
        if (role == null || role.getRoleName() == null || role.getRoleName().trim().isEmpty()) {
            return List.of();
        }
        return List.of(new SimpleGrantedAuthority("ROLE_" + role.getRoleName().toUpperCase()));
    }

    
    public User updateUserByEmail(String passwordHash,User user) {
        user.setPasswordHash(passwordEncoder.encode(passwordHash));
        System.out.println("updated user::::::: from updateUserByEmail");
        return userRepository.save(user);
    }

}
