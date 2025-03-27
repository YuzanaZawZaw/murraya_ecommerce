package com.ecommerce.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.ecommerce.model.Image;
/**
*
* @author Yuzana Zaw Zaw
*/
@Repository
public interface ImageRepository extends JpaRepository<Image,Integer>{

    @Query("SELECT i FROM Image i WHERE i.product.id = :productId")
    List<Image> findImagesByProductId(@Param("productId") int productId);
    
} 
