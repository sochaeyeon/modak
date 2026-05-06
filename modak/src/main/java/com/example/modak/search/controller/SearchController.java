package com.example.modak.search.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.modak.search.dao.SearchService;
import com.google.gson.Gson;

@Controller
@RequestMapping("/search")
public class SearchController {

    @Autowired
    private SearchService searchService;

    // 통합검색 결과창 페이지
    @RequestMapping("/integrated.do")
    public String integratedSearchPage() {
        return "search/integrated-search";
    }

    // 통합검색 데이터 조회
    @RequestMapping(value = "/integrated.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String integratedSearch(@RequestParam HashMap<String, Object> map) {
        return new Gson().toJson(searchService.getIntegratedSearchResult((String) map.get("keyword")));
    }
}