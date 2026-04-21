package com.example.modak.search.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.search.mapper.SearchMapper;
import com.example.modak.search.model.IntegratedSearchResult;

@Service
public class SearchService {

    @Autowired
    private SearchMapper searchMapper;

    public IntegratedSearchResult getIntegratedSearchResult(String keyword) {
        IntegratedSearchResult result = new IntegratedSearchResult();

        keyword = normalizeKeyword(keyword);
        result.setKeyword(keyword);

        if (keyword.isEmpty()) {
            result.setEmptyKeyword(true);
            return result;
        }

        result.setProductList(searchMapper.selectIntegratedProductList(keyword));
        result.setCampList(searchMapper.selectIntegratedCampList(keyword));
        result.setFaqList(searchMapper.selectIntegratedFaqList(keyword));
        result.setEventList(searchMapper.selectIntegratedEventList(keyword));

        result.setProductCount(searchMapper.selectIntegratedProductCount(keyword));
        result.setCampCount(searchMapper.selectIntegratedCampCount(keyword));
        result.setFaqCount(searchMapper.selectIntegratedFaqCount(keyword));
        result.setEventCount(searchMapper.selectIntegratedEventCount(keyword));

        return result;
    }

    private String normalizeKeyword(String keyword) {
        if (keyword == null) {
            return "";
        }
        return keyword.trim();
    }
}