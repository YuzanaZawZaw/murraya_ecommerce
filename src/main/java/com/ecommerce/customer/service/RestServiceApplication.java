package com.ecommerce.customer.service;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication
@EnableJpaRepositories(basePackages = {"com.ecommerce.customer.repository", "com.ecommerce.admin.repository"})
@EntityScan(basePackages = {"com.ecommerce.customer.model", "com.ecommerce.admin.model"})  
@ComponentScan(basePackages = "com.ecommerce")
public class RestServiceApplication {
    public static void main(String[] args) {
        SpringApplication.run(RestServiceApplication.class, args);
    }
}

