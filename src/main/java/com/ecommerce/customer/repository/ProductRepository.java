package com.ecommerce.customer.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ecommerce.customer.model.Product;

/**
*
* @author Yuzana Zaw Zaw
*/
@Repository
public interface ProductRepository extends JpaRepository<Product, Integer>{

    Product getProductByProductId(int productId);
} 
