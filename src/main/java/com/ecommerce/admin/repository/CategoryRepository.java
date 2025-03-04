package com.ecommerce.admin.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ecommerce.admin.model.Category;
/**
*
* @author Yuzana Zaw Zaw
*/
@Repository
public interface CategoryRepository extends JpaRepository<Category, String>{

    List<Category> findByParentCategoryIsNull();

    List<Category> findByParentCategory(Category category);

    Category findCategoryByCategoryId(String categoryId);
    
}
