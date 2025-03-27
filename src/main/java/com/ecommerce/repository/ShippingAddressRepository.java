package com.ecommerce.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ecommerce.model.ShippingAddress;
import com.ecommerce.model.User;

@Repository
public interface ShippingAddressRepository extends JpaRepository<ShippingAddress, Long> {
    ShippingAddress findByUser(User user);
    ShippingAddress findByUserUserId(Long userId);
}
