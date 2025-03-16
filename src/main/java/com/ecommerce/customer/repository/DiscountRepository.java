package com.ecommerce.customer.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ecommerce.customer.model.Discount;


@Repository
public interface DiscountRepository extends JpaRepository<Discount,Integer>{

    Discount findDistcountByDiscountId(int discountId);

    Discount findDistcountByCode(String discountCode);

}
