package com.ecommerce.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ecommerce.model.Discount;

/**
 *
 * @author Yuzana Zaw Zaw
 */
@Repository
public interface DiscountRepository extends JpaRepository<Discount,Integer>{

    Discount findDistcountByDiscountId(int discountId);

    Discount findDistcountByCode(String discountCode);

}
