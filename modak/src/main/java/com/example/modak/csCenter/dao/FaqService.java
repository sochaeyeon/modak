package com.example.modak.csCenter.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.common.Message;
import com.example.modak.csCenter.mapper.FaqMapper;
import com.example.modak.csCenter.model.Faq;

@Service
public class FaqService {

	@Autowired
	FaqMapper faqMapper;

	public HashMap<String, Object> getFaqList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		List<Faq> list = faqMapper.selectFaqList(map);

		resultMap.put("list", list);
		resultMap.put("message", "데이터 조회 성공");
		resultMap.put("result", "success");

		return resultMap;
	}

	public HashMap<String, Object> getFaqInfo(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		try {
			Faq info = faqMapper.selectFaq(map);

			resultMap.put("info", info);
			resultMap.put("result", "success");
			resultMap.put("message", Message.SUCCESS_SELECT);

		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.ERROR_SERVER);
		}
		return resultMap;
	}

}
