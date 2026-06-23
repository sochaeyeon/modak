package com.example.modak.badword.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.badword.dao.BadWordService;
import com.google.gson.Gson;

@Controller
public class BadWordController {

    @Autowired private BadWordService badWordService;

    @PostMapping(value = "/badword/check.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String check(@RequestParam String content) {
        Map<String, Object> result = new HashMap<>();
        result.put("result", "success");
        result.put("hasBadWord", badWordService.containsBadWord(content));
        return new Gson().toJson(result);
    }
}