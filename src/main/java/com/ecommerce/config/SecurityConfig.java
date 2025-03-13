package com.ecommerce.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Yuzana Zaw Zaw
 */
@Configuration
@EnableWebSecurity
class SecurityConfig {

        private final JwtFilter jwtFilter;

        public SecurityConfig(JwtFilter jwtFilter) {
                this.jwtFilter = jwtFilter;
        }

        @Bean
        SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
                http
                                .headers(headers -> headers
                                                .defaultsDisabled()
                                                .frameOptions(frame -> frame.sameOrigin())
                                                .addHeaderWriter((request, response) -> response.setHeader(
                                                                "Content-Security-Policy",
                                                                "frame-ancestors 'self' https://trusted-site.com")))
                                .authorizeHttpRequests(auth -> auth
                                                .requestMatchers(
                                                                "/", "/admin/**", "/static/**",
                                                                "/userAuth/login",
                                                                "/userAuth/forgetPassword",
                                                                "/userAuth/resetPassword",
                                                                "/userAuth/register",
                                                                "/users/userHome",
                                                                "/users/subscribe",
                                                                "/users/userLoginForm",
                                                                "/users/forgetPasswordForm",
                                                                "/users/resetPasswordForm",
                                                                "/users/userSignUpForm",
                                                                "/users/userHomeModuleForm",
                                                                "/users/categories",
                                                                "/users/parentCategories",
                                                                "/users/childCategories",
                                                                "/css/**", "/js/**", "/images/**", "/tabs/**",
                                                                "/favicon.ico", "/WEB-INF/views/**",
                                                                "/adminAuth/adminLogin",
                                                                "/adminAuth/adminLoginForm",
                                                                "/adminAuth/forgetPassword",
                                                                "/adminAuth/adminForgetPasswordForm",
                                                                "/adminAuth/resetPassword",
                                                                "/adminAuth/adminResetPasswordForm",
                                                                "/adminAuth/adminDashboard",
                                                                "/admin/productManagement",
                                                                "/admin/categoryManagement",
                                                                "/admin/customerManagement",
                                                                "/admin/productReviewsManagement",
                                                                "/admin/categories",
                                                                "/admin/addCategory",
                                                                "/admin/addProduct",
                                                                "/admin/deleteProduct",
                                                                "/admin/updateProduct",
                                                                "/admin/viewProductDetails",
                                                                "/admin/viewProduct",
                                                                "/admin/uploadProductImages/",
                                                                "/admin/productImages",
                                                                "/admin/productImage",
                                                                "/admin/deleteProductImage/",
                                                                "/status/allStatuses",
                                                                "/userManagement/updateUserStatus/**",
                                                                "/admin/products/**",
                                                                "/admin/reviews/**",
                                                                "/users/products/trending/**"
                                                )
                                                .permitAll()
                                                .anyRequest().authenticated())
                                .csrf(csrf -> csrf.disable())
                                .sessionManagement(session -> session
                                                .sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                                .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class)
                                .exceptionHandling(ex -> ex
                                                .authenticationEntryPoint((request, response, authException) -> {
                                                        response.sendError(HttpServletResponse.SC_UNAUTHORIZED,
                                                                        "Unauthorized: Please log in");
                                                }));

                return http.build();
        }

        @Bean
        public AuthenticationManager authenticationManager(AuthenticationConfiguration authenticationConfiguration)
                        throws Exception {
                return authenticationConfiguration.getAuthenticationManager();
        }

        @Bean
        public PasswordEncoder passwordEncoder() {
                return new BCryptPasswordEncoder();
        }

}
