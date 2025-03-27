package com.ecommerce.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ecommerce.model.Role;
/**
*
* @author Yuzana Zaw Zaw
*/
@Repository
public interface RoleRepository extends JpaRepository<Role, Integer>{

    Role findByRoleId(Long roleId);
    
} 
