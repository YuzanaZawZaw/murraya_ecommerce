package com.ecommerce.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ecommerce.admin.model.Status;
import com.ecommerce.admin.service.StatusService;
/**
 *
 * @author Yuzana Zaw Zaw
 */
@Controller
@RequestMapping("/status")
public class StatusController {
    @Autowired
    private StatusService statusService;

    @GetMapping("/allStatuses")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getAllStatus() {
        List<Status> categoryList = statusService.getStatusList();
        Map<String, Object> response = new HashMap<>();
        response.put("statusList", categoryList);
        return ResponseEntity.ok(response);
    }
}
