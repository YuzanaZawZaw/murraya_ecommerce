package com.ecommerce.customer.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ecommerce.customer.model.Order;

@Repository
public interface OrderRepository extends JpaRepository<Order, Integer> {

    List<Order> findByUserUserId(Long userId);
    
}
