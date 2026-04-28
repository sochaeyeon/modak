package com.example.modak.refund.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.refund.mapper.RefundMapper;

@Service
public class RefundService {
	
	@Autowired
	RefundMapper refundMapper;

}
