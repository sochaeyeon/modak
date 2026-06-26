package com.example.modak.product.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ProductRecommendMapper {
    List<Integer> selectAllProductIds();
    List<HashMap<String, Object>> selectCachedRecommend(HashMap<String, Object> map);
    void deleteRecommendByProductId(HashMap<String, Object> map);
    void insertRecommend(HashMap<String, Object> map);
}