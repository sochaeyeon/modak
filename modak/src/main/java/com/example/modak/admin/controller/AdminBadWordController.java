package com.example.modak.admin.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.badword.dao.BadWordService;
import com.google.gson.Gson;

@Controller
@RequestMapping("/admin/badword")
public class AdminBadWordController {

    @Autowired private BadWordService badWordService;

    @GetMapping("/list.do")
    public String listPage() {
        return "admin/badword-list";
    }

    @PostMapping(value = "/list.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String list() {
        return new Gson().toJson(badWordService.getWordList());
    }

    @PostMapping(value = "/add.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String add(@RequestParam String word) {
        return new Gson().toJson(badWordService.addWord(word));
    }

    @PostMapping(value = "/delete.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String delete(@RequestParam Long wordId) {
        return new Gson().toJson(badWordService.deleteWord(wordId));
    }
}