package com.ecommerce.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ecommerce.model.Wishlist;

@Repository
public interface WishlistRepository  extends JpaRepository<Wishlist,Integer>{

    Wishlist findByUserUserIdAndProductProductId(Long userId, int productId);

    List<Wishlist> findAllByUserUserId(Long userId);

}
