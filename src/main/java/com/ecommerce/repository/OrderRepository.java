package com.ecommerce.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.ecommerce.model.Order;
import com.ecommerce.model.Status;

@Repository
public interface OrderRepository extends JpaRepository<Order, Integer> {

    List<Order> findByUserUserId(Long userId);

    @Query("SELECT SUM(o.totalAmount) FROM Order o")
    Double calculateTotalSales();

    @Query("SELECT COUNT(o) FROM Order o")
    int countTotalOrders();

    List<Order> findOrderByStatus(Status status);

    List<Order> findByCreatedAtBetween(LocalDateTime atStartOfDay, LocalDateTime atTime);
    
}
