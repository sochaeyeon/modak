package com.example.modak.address.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.address.mapper.AddressMapper;
import com.example.modak.address.model.Address;
import com.example.modak.common.Message;

import jakarta.servlet.http.HttpSession;

@Service
public class AddressService {

	@Autowired
	AddressMapper addressMapper;

	@Autowired
	HttpSession session;

	// 배송지 추가
	public HashMap<String, Object> addAddress(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			String userId = (String) session.getAttribute("sessionId");
			map.put("userId", userId);

			String defaultYn = (String) map.get("defaultYn");

			// 새 배송지를 기본배송지로 설정한 경우
			if ("Y".equals(defaultYn)) {
				addressMapper.updateDefaultYnToN(map);
			}

			int result = addressMapper.insertAddress(map);

			if (result > 0) {
				resultMap.put("message", Message.SUCCESS_ADD);
				resultMap.put("result", "success");
			} else {
				resultMap.put("message", Message.ERROR_COMMON);
				resultMap.put("result", "fail");
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("message", Message.ERROR_SERVER);
			resultMap.put("result", "fail");
		}
		return resultMap;
	}

	// 배송지 목록 조회
	public HashMap<String, Object> getAddressList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			String userId = (String) session.getAttribute("sessionId");
			map.put("userId", userId);
			List<Address> list = addressMapper.selectAddressList(map);
			if (list != null) {
				resultMap.put("message", Message.SUCCESS_ADD);
				resultMap.put("list", list);
			} else {
				resultMap.put("message", Message.ERROR_COMMON);
			}
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			resultMap.put("message", Message.ERROR_SERVER);
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	// 배송지 수정
	public HashMap<String, Object> editAddress(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    try {
	        String userId = (String) session.getAttribute("sessionId");
	        map.put("userId", userId);

	        String defaultYn = (String) map.get("defaultYn");
	        if ("Y".equals(defaultYn)) {
	            addressMapper.updateDefaultYnToN(map);
	        }

	        int result = addressMapper.updateAddress(map);

	        if (result > 0) {
	            resultMap.put("result", "success");
	            resultMap.put("message", Message.SUCCESS_UPDATE);
	        } else {
	            resultMap.put("result", "fail");
	            resultMap.put("message", Message.ERROR_COMMON);
	        }
	    } catch (Exception e) {
	        System.out.println(e.getMessage());
	        resultMap.put("result", "fail");
	        resultMap.put("message", Message.ERROR_SERVER);
	    }
	    return resultMap;
	}

	// 배송지 삭제
	public HashMap<String, Object> removeAddress(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    try {
	        String userId = (String) session.getAttribute("sessionId");
	        map.put("userId", userId);

	        int result = addressMapper.deleteAddress(map);

	        if (result > 0) {
	            resultMap.put("result", "success");
	            resultMap.put("message", Message.SUCCESS_DELETE);
	        } else {
	            resultMap.put("result", "fail");
	            resultMap.put("message", Message.ERROR_COMMON);
	        }
	    } catch (Exception e) {
	        System.out.println(e.getMessage());
	        resultMap.put("result", "fail");
	        resultMap.put("message", Message.ERROR_SERVER);
	    }
	    return resultMap;
	}
}
