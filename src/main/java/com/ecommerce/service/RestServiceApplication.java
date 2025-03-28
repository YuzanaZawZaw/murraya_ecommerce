package com.ecommerce.service;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
/**
*
* @author Yuzana Zaw Zaw
*/
@SpringBootApplication
@EnableJpaRepositories(basePackages = {"com.ecommerce.repository"})
@EntityScan(basePackages = {"com.ecommerce.model"})  
@ComponentScan(basePackages = "com.ecommerce")
@EnableCaching
public class RestServiceApplication {
    public static void main(String[] args) {
        SpringApplication.run(RestServiceApplication.class, args);
    }
}

