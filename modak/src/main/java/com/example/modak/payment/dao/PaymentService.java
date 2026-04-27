package com.example.modak.payment.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.payment.mapper.PaymentMapper;

@Service
public class PaymentService {

	@Autowired
	PaymentMapper paymentMapper;
	
	// 배송지 목록 조회
    public HashMap<String, Object> getAddressList(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();

        try {
            List<HashMap<String, Object>> list = paymentMapper.selectAddressList(map);

            resultMap.put("result", "success");
            resultMap.put("list", list);

        } catch (Exception e) {
            System.out.println(e.getMessage());
            resultMap.put("result", "fail");
            resultMap.put("message", "배송지 목록 조회 실패");
        }

        return resultMap;
    }
    // cart 
    public HashMap<String, Object> getCheckoutItems(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();

        try {
            List<HashMap<String, Object>> list = paymentMapper.selectCheckoutItems(map);

            resultMap.put("result", "success");
            resultMap.put("list", list);

        } catch (Exception e) {
            System.out.println(e.getMessage());
            e.printStackTrace();
            resultMap.put("result", "fail");
            resultMap.put("message", e.getMessage());
        }

        return resultMap;
    }
    
    
}