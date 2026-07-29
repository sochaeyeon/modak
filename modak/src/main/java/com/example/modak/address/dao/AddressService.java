package com.example.modak.address.dao;

import java.util.HashMap;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.address.mapper.AddressMapper;
import com.example.modak.address.model.Address;
import com.example.modak.common.Message;

import jakarta.servlet.http.HttpSession;

@Service
public class AddressService {

	private static final Logger logger = LoggerFactory.getLogger(AddressService.class);

	private static final String RESULT = "result";
	private static final String MESSAGE = "message";
	private static final String SUCCESS = "success";
	private static final String FAIL = "fail";

	@Autowired
	private AddressMapper addressMapper;

	@Autowired
	private HttpSession session;

	public HashMap<String, Object> addAddress(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			putUserId(map);
			applyDefaultAddressIfNeeded(map);

			int result = addressMapper.insertAddress(map);

			updatePhoneIfProvided(map);

			if (result > 0) {
				resultMap.put(MESSAGE, Message.SUCCESS_ADD);
				resultMap.put(RESULT, SUCCESS);
				resultMap.put("addressId", map.get("addressId"));
			} else {
				resultMap.put(MESSAGE, Message.ERROR_COMMON);
				resultMap.put(RESULT, FAIL);
			}
		} catch (Exception e) {
			handleException(resultMap, e);
		}
		return resultMap;
	}

	public HashMap<String, Object> getAddressList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			putUserId(map);
			List<Address> list = addressMapper.selectAddressList(map);

			if (list != null) {
				resultMap.put(MESSAGE, Message.SUCCESS_ADD);
				resultMap.put("list", list);
				resultMap.put(RESULT, SUCCESS);
			} else {
				resultMap.put(MESSAGE, Message.ERROR_COMMON);
				resultMap.put(RESULT, FAIL);
			}
		} catch (Exception e) {
			handleException(resultMap, e);
		}
		return resultMap;
	}

	public HashMap<String, Object> editAddress(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			putUserId(map);
			applyDefaultAddressIfNeeded(map);

			int result = addressMapper.updateAddress(map);

			if (result > 0) {
				resultMap.put(RESULT, SUCCESS);
				resultMap.put(MESSAGE, Message.SUCCESS_UPDATE);
			} else {
				resultMap.put(RESULT, FAIL);
				resultMap.put(MESSAGE, Message.ERROR_COMMON);
			}
		} catch (Exception e) {
			handleException(resultMap, e);
		}
		return resultMap;
	}

	public HashMap<String, Object> removeAddress(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			putUserId(map);

			int result = addressMapper.deleteAddress(map);

			if (result > 0) {
				resultMap.put(RESULT, SUCCESS);
				resultMap.put(MESSAGE, Message.SUCCESS_DELETE);
			} else {
				resultMap.put(RESULT, FAIL);
				resultMap.put(MESSAGE, Message.ERROR_COMMON);
			}
		} catch (Exception e) {
			handleException(resultMap, e);
		}
		return resultMap;
	}

	private void putUserId(HashMap<String, Object> map) {
		String userId = (String) session.getAttribute("sessionId");
		map.put("userId", userId);
	}

	private void applyDefaultAddressIfNeeded(HashMap<String, Object> map) {
		String defaultYn = (String) map.get("defaultYn");
		if ("Y".equals(defaultYn)) {
			addressMapper.updateDefaultYnToN(map);
		}
	}

	private void updatePhoneIfProvided(HashMap<String, Object> map) {
		String receiverPhone = (String) map.get("receiverPhone");
		if (receiverPhone != null && !receiverPhone.trim().isEmpty()) {
			addressMapper.updateUserPhoneIfEmpty(map);
		}
	}

	private void handleException(HashMap<String, Object> resultMap, Exception e) {
		logger.error("AddressService error", e);
		resultMap.put(RESULT, FAIL);
		resultMap.put(MESSAGE, Message.ERROR_SERVER);
	}
}