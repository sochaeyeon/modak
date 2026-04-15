package com.example.modak.def.dao;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.def.mapper.DefaultMapper;

// 규칙
// 검색 - get, 삭제 - remove, 수정 - edit, 추가 - add
@Service
public class DefaultService {

   @Autowired 
   DefaultMapper defaultMapper;
   
   public HashMap<String, Object> getDefaultList(HashMap<String, Object> map){
      // Mapper 호출 결과를 담을 resultMap 선언
      HashMap<String, Object> resultMap = new HashMap<String, Object>();

      // try ~ chatch문
      try {
         // Mapper 호출해서 담을 list 선언
         // select - List<Default> list = defaultMapper.getDefaultList();
         //          Default info = defaultMapper.getDefault(); 
         // update, insert, delete - int result = defaultMapper.edit/add/removeDefault();
         // update, insert, delete로 Mapper 호출 시
         // if(result > 0) {
         //     resultMap.put("message", MSG_~ );
         // } else {
         //     resultMap.put("message", MSG_~);
         // }
         // List<default> list = defaultMapper.getItemList();
         resultMap.put("result", "success");
      } catch (Exception e) {
         // TODO: handle exception
         System.out.println(e.getMessage());
         // resultMap.put("message", MSG_~);
         resultMap.put("result", "fail");
      }
      return resultMap;
   }

}
