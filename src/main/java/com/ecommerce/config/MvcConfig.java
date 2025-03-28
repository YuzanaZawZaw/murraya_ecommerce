package com.ecommerce.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.view.InternalResourceViewResolver;

import com.ecommerce.model.Payment;
/**
*
* @author Yuzana Zaw Zaw
*/
@Configuration
public class MvcConfig implements WebMvcConfigurer {

    @Bean
    public InternalResourceViewResolver viewResolver() {
        InternalResourceViewResolver resolver = new InternalResourceViewResolver();
        resolver.setPrefix("/WEB-INF/views/");
        resolver.setSuffix(".jsp");
        return resolver;
    }

    @Override
    public void addViewControllers(@SuppressWarnings("null") ViewControllerRegistry registry) {
        registry.addViewController("/users/checkOutForm").setViewName("customer/checkOut");
    }

    @Override
    public void addFormatters(@SuppressWarnings("null") org.springframework.format.FormatterRegistry registry) {
        registry.addConverter(String.class, Payment.PaymentMethod.class, Payment.PaymentMethod::valueOf);
    }
}

