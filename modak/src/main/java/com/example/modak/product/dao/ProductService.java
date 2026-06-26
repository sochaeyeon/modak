package com.example.modak.product.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.common.Message;
import com.example.modak.csCenter.model.Faq;
import com.example.modak.product.mapper.ProductMapper;
import com.example.modak.product.model.Brand;
import com.example.modak.product.model.Product;
import com.example.modak.product.model.ProductFeature;
import com.example.modak.product.model.ProductOption;
import com.example.modak.product.model.ProductSpec;

@Service
public class ProductService {

	@Autowired
	ProductMapper productMapper;

	// 제품 리스트 불러오기 product list
	public HashMap<String, Object> getProductList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			// 검색어 앞뒤 공백 제거
			if (map.get("searchKeyword") != null) {
				String keyword = String.valueOf(map.get("searchKeyword")).trim();
				map.put("searchKeyword", keyword);
			}

			List<Product> list = productMapper.selectProductList(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.SUCCESS_SELECT);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.FAIL_SELECT);
		}
		return resultMap;
	}

	// 브랜드 리스트 불러오기 brand list
	public HashMap<String, Object> getBrandList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			// XML에서 정의한 selectBrandList 호출 (결과는 Brand 모델 리스트)
			List<Brand> list = productMapper.selectBrandList(map);

			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("message", Message.SUCCESS_SELECT);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("message", Message.FAIL_SELECT);
		}
		return resultMap;
	}

	// getProduct() 전체 교체
	public HashMap<String, Object> getProduct(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			// ① 상품 기본 정보
			Product info = productMapper.selectProduct(map);
			if (info == null) {
				resultMap.put("result", "fail");
				resultMap.put("message", "상품 정보를 찾을 수 없습니다.");
				return resultMap;
			}
			// ② 조회수 +1
			productMapper.increaseViewCount(map);

			// ③ 상품 이미지
			List<Product> img = productMapper.selectProductImages(map);

			// ④ 주문 카운트
			int orderCount = productMapper.selectOrderCount(map);

			// ⑤ 상품 스펙
			ProductSpec spec = productMapper.selectProductSpec(map);

			// ⑥ 상품 특징
			List<ProductFeature> features = productMapper.selectProductFeatures(map);

			// ⑦ FAQ - 상품 타입에 따라 카테고리 분기
			List<String> faqCategories;
			if ("RENTAL".equals(info.getProductType())) {
				faqCategories = java.util.Arrays.asList("대여", "반납", "연장", "배송", "취소");
			} else {
				faqCategories = java.util.Arrays.asList("주문", "배송", "환불", "결제", "취소");
			}
			map.put("categories", faqCategories);
			List<Faq> faqList = productMapper.selectFaqList(map);
			// 8 상품별 옵션
			List<ProductOption> options = productMapper.selectProductOptions(map);

			// ⑧ resultMap에 담기
			resultMap.put("info", info);
			resultMap.put("img", img);
			resultMap.put("orderCount", orderCount);
			resultMap.put("spec", spec);
			resultMap.put("features", features);
			resultMap.put("faqList", faqList);
			resultMap.put("options", options);
			resultMap.put("result", "success");
			resultMap.put("message", Message.SUCCESS_SELECT);

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", e.getMessage());
		}
		return resultMap;
	}

	public HashMap<String, Object> getMainCategoryList() {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			List<HashMap<String, Object>> list = productMapper.selectMainCategoryList();
			resultMap.put("list", list);
			resultMap.put("result", "success");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", e.getMessage());
		}
		return resultMap;
	}

	public HashMap<String, Object> getPopularProducts() {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			List<Product> list = productMapper.selectPopularProducts();
			resultMap.put("list", list);
			resultMap.put("result", "success");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", e.getMessage());
		}
		return resultMap;
	}

//	product detail 하단 추천 제품
	public HashMap<String, Object> getRelatedProducts(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			List<Product> list = productMapper.selectRelatedProducts(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", e.getMessage());
		}
		return resultMap;
	}

	// 상품 옵션 리스트 조회
	public HashMap<String, Object> getProductOptions(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			List<ProductOption> list = productMapper.selectProductOptions(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", e.getMessage());
		}
		return resultMap;
	}

	public List<HashMap<String, Object>> selectAllCategoryList() {
		return productMapper.selectAllCategoryList();
	}

	public HashMap<String, Object> getOptionItemId(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();

		try {
			String optionValueIds = String.valueOf(map.get("optionValueIds"));

			if (optionValueIds == null || optionValueIds.equals("") || optionValueIds.equals("null")) {
				resultMap.put("result", "fail");
				resultMap.put("message", "옵션값이 없습니다.");
				return resultMap;
			}

			String[] arr = optionValueIds.split(",");
			ArrayList<Integer> optionValueIdList = new ArrayList<>();

			for (String id : arr) {
				optionValueIdList.add(Integer.parseInt(id.trim()));
			}

			map.put("optionValueIdList", optionValueIdList);
			map.put("optionCount", optionValueIdList.size());

			Integer optionItemId = productMapper.selectOptionItemId(map);

			if (optionItemId == null) {
				resultMap.put("result", "fail");
				resultMap.put("message", "옵션 조합을 찾을 수 없습니다.");
				return resultMap;
			}

			resultMap.put("result", "success");
			resultMap.put("optionItemId", optionItemId);

		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", "fail");
			resultMap.put("message", "옵션 조합 조회 중 오류");
		}

		return resultMap;
	}

	// 옵션별 재고 확인
	public HashMap<String, Object> getOptionStock(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    try {
	        String optionValueIds = String.valueOf(map.get("optionValueIds"));
	        String[] arr = optionValueIds.split(",");
	        ArrayList<Integer> list = new ArrayList<>();
	        for (String id : arr) list.add(Integer.parseInt(id.trim()));
	        map.put("optionValueIdList", list);
	        map.put("optionCount", list.size());

	        HashMap<String, Object> stock = productMapper.selectOptionStock(map);
	        resultMap.put("result", stock != null ? "success" : "fail");
	        resultMap.put("stock", stock);
	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "fail");
	    }
	    return resultMap;
	}
}