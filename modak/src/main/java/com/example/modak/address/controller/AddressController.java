package com.example.modak.address.controller;

import java.util.HashMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import com.example.modak.address.dao.AddressService;
import com.google.gson.Gson;

@Controller
public class AddressController {

	@Autowired
	private AddressService addressService;

	private static final Gson gson = new Gson();

	@RequestMapping(value = "/user/address/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String addAddress(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		return toJson(addressService.addAddress(map));
	}

	@RequestMapping(value = "/user/address/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getAddressList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		return toJson(addressService.getAddressList(map));
	}

	@RequestMapping(value = "/user/address/edit.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String editAddress(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		return toJson(addressService.editAddress(map));
	}

	@RequestMapping(value = "/user/address/remove.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String removeAddress(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		return toJson(addressService.removeAddress(map));
	}

	private String toJson(HashMap<String, Object> resultMap) {
		return gson.toJson(resultMap);
	}
}