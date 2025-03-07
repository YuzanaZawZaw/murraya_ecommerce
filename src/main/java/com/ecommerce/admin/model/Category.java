package com.ecommerce.admin.model;

import jakarta.persistence.*;

import java.time.Instant;

import org.hibernate.annotations.UpdateTimestamp;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonFormat;
/**
 *
 * @author Yuzana Zaw Zaw
 */
@Entity
@Table(name = "categories")
public class Category {

    @Id
    @Column(name = "category_id", nullable = false, length = 50)
    private String categoryId;

    @Column(name = "name", nullable = false, length = 50)
    private String name;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @ManyToOne
    @JoinColumn(name = "parent_category_id", foreignKey = @ForeignKey(name = "categories_ibfk_1"))
    @JsonBackReference
    private Category parentCategory;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss.SSSZ", timezone = "UTC")
    private Instant createdAt;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss.SSSZ", timezone = "UTC")
    private Instant updatedAt;
    
    public Instant getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Instant createdAt) {
        this.createdAt = createdAt;
    }

    public Instant getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Instant updatedAt) {
        this.updatedAt = updatedAt;
    }

    public Category() {
    }

    public Category(String categoryId, String name, String description, Category parentCategory, Instant createdAt, Instant updatedAt) {
        this.categoryId = categoryId;
        this.name = name;
        this.description = description;
        this.parentCategory = parentCategory;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
    // Getters and Setters

    public String getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(String categoryId) {
        this.categoryId = categoryId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Category getParentCategory() {
        return parentCategory;
    }

    public void setParentCategory(Category parentCategory) {
        this.parentCategory = parentCategory;
    }

    @Override
    public String toString() {
        return "Category{" +
                "categoryId=" + categoryId +
                ", name='" + name + '\'' +
                ", description='" + description + '\'' +
                ", parentCategory=" + (parentCategory != null ? parentCategory.getName() : "null") +
                '}';
    }
}
