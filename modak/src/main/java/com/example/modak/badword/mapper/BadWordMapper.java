package com.example.modak.badword.mapper;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface BadWordMapper {
    List<String> selectAllWords();
    List<Map<String, Object>> selectAllWordsWithId();
    int insertWord(String word);
    int deleteWord(Long wordId);
}