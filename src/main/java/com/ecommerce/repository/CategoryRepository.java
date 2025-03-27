package com.ecommerce.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ecommerce.model.Category;
/**
*
* @author Yuzana Zaw Zaw
*/
@Repository
public interface CategoryRepository extends JpaRepository<Category, String>{

    List<Category> findByParentCategoryIsNull();

    List<Category> findByParentCategory(Category category);

    Category findCategoryByCategoryId(String categoryId);

    List<Category> findByParentCategoryIsNotNull();
    
}
