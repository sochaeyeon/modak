package com.example.modak.membership.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.common.Message;
import com.example.modak.membership.mapper.FAQMapper;
import com.example.modak.membership.model.FAQ;

@Service
public class FAQService {
	
	@Autowired
	FAQMapper faqMapper;
	
	public HashMap<String, Object> getFAQList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			List<FAQ> list = faqMapper.selectFAQList(map);
			if(list != null) {
				resultMap.put("list", list);
				resultMap.put("message", Message.SUCCESS_SELECT);
			} else {
				resultMap.put("message", Message.ERROR_COMMON);
			}
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("message", Message.ERROR_SERVER);
			resultMap.put("result", "fail");
		}
		return resultMap;
	}
}
