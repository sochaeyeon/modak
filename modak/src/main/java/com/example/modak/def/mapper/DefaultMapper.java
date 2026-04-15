package com.example.modak.def.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.modak.def.model.Default;

// 규칙
// 검색 - select, 삭제 - delete, 추가 - insert, 수정 - update

@Mapper
public interface DefaultMapper {

    // 여러 개 리턴
   public List<Default> selectDefaultList(HashMap<String, Object> map);

    // 한 개 리턴
    public Default selectDefault(HashMap<String, Object> map);

    // 삭제
    public int deleteDefault(HashMap<String, Object> map);

    // 추가
    public int insertDefault(HashMap<String, Object> map);

    // 수정
    public int updateDefault(HashMap<String, Object> map);
}



