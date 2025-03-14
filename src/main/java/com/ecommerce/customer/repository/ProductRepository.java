package com.ecommerce.customer.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.ecommerce.customer.model.Product;

/**
 *
 * @author Yuzana Zaw Zaw
 */
@Repository
public interface ProductRepository extends JpaRepository<Product, Integer> {

    Product getProductByProductId(int productId);

    // @Query("SELECT p FROM Product p LEFT JOIN p.metrics pm " +
    // "ORDER BY COALESCE(pm.views, 0) DESC, COALESCE(pm.purchases, 0) DESC,
    // COALESCE(pm.likes, 0) DESC")
    // List<Product> findTrendingProducts();

    // @Query("SELECT p FROM Product p " +
    // "LEFT JOIN FETCH p.metrics pm " +
    // "LEFT JOIN FETCH p.image img WHERE p.statusId = 1" +
    // "ORDER BY COALESCE(pm.views, 0) DESC, COALESCE(pm.purchases, 0) DESC,
    // COALESCE(pm.likes, 0) DESC")
    // List<Product> findTrendingProducts();

    // @Query("SELECT p FROM Product p " +
    // "LEFT JOIN FETCH p.metrics pm " +
    // "LEFT JOIN FETCH p.images img " +
    // "WHERE p.status.statusId = 1 " +
    // "AND img.imageId = (SELECT MIN(img2.imageId) FROM Image img2 WHERE
    // img2.product.productId = p.productId) " +
    // "ORDER BY COALESCE(pm.views, 0) DESC, COALESCE(pm.purchases, 0) DESC,
    // COALESCE(pm.likes, 0) DESC")
    // List<Product> findTrendingProducts();

    @Query("SELECT p FROM Product p " +
            "LEFT JOIN FETCH p.metrics pm " +
            "LEFT JOIN FETCH p.images img " +
            "LEFT JOIN p.category c " +
            "WHERE p.status.statusId = 1 " +
            "AND c.parentCategory.categoryId = :parentCategoryId " + // Use the correct field name
            "AND img.imageId = (SELECT MIN(img2.imageId) FROM Image img2 WHERE img2.product.productId = p.productId) " +
            "ORDER BY COALESCE(pm.views, 0) DESC, COALESCE(pm.purchases, 0) DESC, COALESCE(pm.likes, 0) DESC")
    List<Product> findTrendingProductsByParentCategoryId(@Param("parentCategoryId") String parentCategoryId);
}
