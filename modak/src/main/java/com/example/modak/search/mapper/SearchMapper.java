package com.example.modak.search.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.modak.search.model.SearchCamp;
import com.example.modak.search.model.SearchEvent;
import com.example.modak.search.model.SearchFaq;
import com.example.modak.search.model.SearchProduct;

@Mapper
public interface SearchMapper {

    List<SearchProduct> selectIntegratedProductList(String keyword);
    int selectIntegratedProductCount(String keyword);

    List<SearchCamp> selectIntegratedCampList(String keyword);
    int selectIntegratedCampCount(String keyword);

    List<SearchFaq> selectIntegratedFaqList(String keyword);
    int selectIntegratedFaqCount(String keyword);

    List<SearchEvent> selectIntegratedEventList(String keyword);
    int selectIntegratedEventCount(String keyword);
}