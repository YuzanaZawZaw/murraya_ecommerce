package com.ecommerce.admin.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ecommerce.admin.model.Status;
import com.ecommerce.admin.repository.StatusRepository;

/**
*
* @author Yuzana Zaw Zaw
*/
@Service
public class StatusService {
    @Autowired
    public StatusRepository statusRepository;

    public List<Status> getStatusList() {
        return statusRepository.findAll();
    }
}
