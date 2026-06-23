package com.example.modak.badword.dao;

import java.util.Map;

public interface BadWordService {
    boolean containsBadWord(String content);
    Map<String, Object> getWordList();
    Map<String, Object> addWord(String word);
    Map<String, Object> deleteWord(Long wordId);
    void refreshCache();
}