package com.ecommerce.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ecommerce.model.Status;

/**
*
* @author Yuzana Zaw Zaw
*/
@Repository
public interface StatusRepository extends JpaRepository<Status, Integer>{

    Status findByStatusId(int statusId);

    Status findStatusByStatusName(String statusName);

}
