package com.ecommerce.repository;
/**
 *
 * @author Yuzana Zaw Zaw
 */

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ecommerce.model.Cart;
import com.ecommerce.model.Product;
import com.ecommerce.model.User;


@Repository
public interface CartRepository extends JpaRepository<Cart,Integer>{
Cart findByUserAndProduct(User user, Product product);

List<Cart> findAllByUserUserId(long userId);

Cart findByUserUserIdAndProductProductId(Long userId, Long productId);

List<Cart> findByUserUserId(Long userId);
}
