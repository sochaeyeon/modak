package com.example.modak.badword.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CopyOnWriteArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.badword.mapper.BadWordMapper;

import jakarta.annotation.PostConstruct;

@Service
public class BadWordServiceImpl implements BadWordService {

    @Autowired private BadWordMapper badWordMapper;

    private final List<String> normalizedWords = new CopyOnWriteArrayList<>();

    @PostConstruct
    public void init() {
        refreshCache();
    }

    @Override
    public void refreshCache() {
        List<String> words = badWordMapper.selectAllWords();
        normalizedWords.clear();
        for (String w : words) {
            String norm = normalize(w);
            if (!norm.isEmpty()) {
                normalizedWords.add(norm);
            }
        }
    }

    private String normalize(String text) {
        if (text == null) return "";
        return text.replaceAll("[^가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z0-9]", "").toLowerCase();
    }

    @Override
    public boolean containsBadWord(String content) {
        if (content == null || content.isEmpty()) return false;

        String normalizedContent = normalize(content);

        for (String word : normalizedWords) {
            if (normalizedContent.contains(word)) {
                return true;
            }
        }
        return false;
    }

    @Override
    public Map<String, Object> getWordList() {
        Map<String, Object> result = new HashMap<>();
        result.put("result", "success");
        result.put("list", badWordMapper.selectAllWordsWithId());
        return result;
    }

    @Override
    public Map<String, Object> addWord(String word) {
        Map<String, Object> result = new HashMap<>();

        if (word == null || word.trim().isEmpty()) {
            result.put("result", "fail");
            result.put("message", "단어를 입력해주세요.");
            return result;
        }

        try {
            badWordMapper.insertWord(word.trim());
            refreshCache();
            result.put("result", "success");
        } catch (Exception e) {
            result.put("result", "fail");
            result.put("message", "이미 등록된 단어입니다.");
        }

        return result;
    }

    @Override
    public Map<String, Object> deleteWord(Long wordId) {
        Map<String, Object> result = new HashMap<>();
        badWordMapper.deleteWord(wordId);
        refreshCache();
        result.put("result", "success");
        return result;
    }
}