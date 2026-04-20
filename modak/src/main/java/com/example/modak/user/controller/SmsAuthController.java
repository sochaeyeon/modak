package com.example.modak.user.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.user.dao.SmsAuthService;
import com.google.gson.Gson;

@Controller
public class SmsAuthController {

    @Autowired
    SmsAuthService smsAuthService;

    @PostMapping(value = "/user/sms/send-code.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String sendSmsCode(@RequestParam HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = smsAuthService.sendSmsCode(map);
        return new Gson().toJson(resultMap);
    }

    @PostMapping(value = "/user/sms/verify-code.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String verifySmsCode(@RequestParam HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = smsAuthService.verifySmsCode(map);
        return new Gson().toJson(resultMap);
    }
}