package com.ecommerce.admin.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.ecommerce.admin.model.Admin;
/**
*
* @author Yuzana Zaw Zaw
*/
@Repository
public interface AdminRepository extends JpaRepository<Admin, Integer>{

    Admin findByUserName(String username);

    @Query("SELECT u FROM Admin u JOIN FETCH u.role")
    List<Admin> findAllAdminWithRoles();

    Admin findByEmail(String email);

    Admin findAdminByUserNameAndPasswordHash(String userName, String newPasswordHash);

}
