package com.ecommerce.customer.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.ecommerce.customer.model.User;
/**
*
* @author Yuzana Zaw Zaw
*/
@Repository
public interface UserRepository extends JpaRepository<User, Integer> { 
    User findByUserName(String username);

    @Query("SELECT u FROM User u JOIN FETCH u.role")
    List<User> findAllUsersWithRoles();

    User findByEmail(String email);

    @Query("SELECT COUNT(u) FROM User u")
    int countTotalUsers();
    
    @Query(value = "SELECT * FROM users u WHERE u.user_name = :userName AND u.status_id = :statusId", nativeQuery = true)
    User findUserByUsernameAndStatusId(@Param("userName") String userName, @Param("statusId") int statusId);
}
