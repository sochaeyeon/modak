package com.example.modak.admin.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface AdminMapper {

	HashMap<String, Object> selectAdminById(String adminId);
	void updateAdminLoginDate(String adminId);
	long selectMonthSales();
	void updateRefundStatus(Map<String, Object> map);
	long selectLastMonthSales();
	Map<String, Object> selectActiveOrders();
	int selectTotalUsers();
	int selectNewUsers();
	int selectRentingCount();
	int selectWaitingInquiryCount();
	int selectTotalInquiryCount();
	List<HashMap<String, Object>> selectMonthlySales();
	List<HashMap<String, Object>> selectRecentOrders();
	List<HashMap<String, Object>> selectWaitingInquiries();
	List<HashMap<String, Object>> selectTopProducts();
	List<HashMap<String, Object>> selectGradeStats();

	List<Map<String, Object>> selectAdminOrderList(HashMap<String, Object> map);
	int selectAdminOrderCount(HashMap<String, Object> map);
	void updateOrderStatus(HashMap<String, Object> map);
	int updateRentalStatusByOrderStatus(HashMap<String, Object> map);
	List<Map<String, Object>> selectReturnRequestList();
	int updateReturnRequestStatus(HashMap<String, Object> map);
	HashMap<String, Object> selectPaymentByOrderId(String orderId);
	int updatePaymentRefunded(HashMap<String, Object> map);

	List<Map<String, Object>> selectInquiryList(HashMap<String, Object> map);
	void insertInquiryAnswer(HashMap<String, Object> map);
	void updateInquiryStatus(HashMap<String, Object> map);
	void updateInquiryAnswer(HashMap<String, Object> map);

	List<HashMap<String, Object>> selectMemberList(HashMap<String, Object> map);
	int selectMemberCount(HashMap<String, Object> map);
	HashMap<String, Object> selectMemberSummary();
	void updateMemberStatus(HashMap<String, Object> map);

	List<Map<String, Object>> selectAdminProductList(HashMap<String, Object> map);
	int selectAdminProductCount(HashMap<String, Object> map);
	void insertProduct(HashMap<String, Object> map);
	void insertProductImg(HashMap<String, Object> map);
	int updateProduct(HashMap<String, Object> map);
	void updateProductImg(HashMap<String, Object> map);
	void insertProductSpec(HashMap<String, Object> map);
	void updateProductSpec(HashMap<String, Object> map);
	void insertProductFeature(HashMap<String, Object> map);
	void updateProductFeature(HashMap<String, Object> map);
	void updateProductAvail(HashMap<String, Object> map);
	void updateProductViewCount(HashMap<String, Object> map);
	void deleteProductImg(HashMap<String, Object> map);
	void deleteProductSpec(HashMap<String, Object> map);
	void deleteProductFeature(HashMap<String, Object> map);
	void deleteProduct(HashMap<String, Object> map);
	int deleteMainProductImg(HashMap<String, Object> map);
	int insertMainProductImg(HashMap<String, Object> map);

	List<Map<String, Object>> selectProductStockList(HashMap<String, Object> map);
	int updateProductStock(HashMap<String, Object> map);
	int insertProductStock(HashMap<String, Object> map);

	List<Map<String, Object>> selectDetailImages(HashMap<String, Object> map);
	int insertDetailImage(HashMap<String, Object> map);
	int deleteDetailImage(HashMap<String, Object> map);

	List<Map<String, Object>> selectOptionGroups(HashMap<String, Object> map);
	int insertOptionGroup(HashMap<String, Object> map);
	int deleteOptionGroup(HashMap<String, Object> map);
	List<Map<String, Object>> selectOptionValues(HashMap<String, Object> map);
	int insertOptionValue(HashMap<String, Object> map);
	int deleteOptionValue(HashMap<String, Object> map);
	List<Map<String, Object>> selectOptionItems(HashMap<String, Object> map);
	int updateOptionItemAvail(HashMap<String, Object> map);

	List<Map<String, Object>> selectBrandList();

	List<Map<String, Object>> selectAdminReviewList(HashMap<String, Object> map);
	List<Map<String, Object>> selectReviewList(HashMap<String, Object> map);
	void deleteReview(HashMap<String, Object> map);

	List<HashMap<String, Object>> selectEventList(HashMap<String, Object> map);
	int selectEventCount();
	void insertEvent(HashMap<String, Object> map);
	void updateEvent(HashMap<String, Object> map);
	void updateEventImage(HashMap<String, Object> map);
	void deleteEvent(HashMap<String, Object> map);
	void deleteEventImages(HashMap<String, Object> map);

	List<Map<String, Object>> selectAdminRentalList(HashMap<String, Object> map);
	void updateRentalStatus(HashMap<String, Object> map);
	void updateRentalDate(HashMap<String, Object> map);

	List<Map<String, Object>> selectCampList(HashMap<String, Object> map);
	void updateCampStatus(HashMap<String, Object> map);
	Map<String, Object> selectCampDetail(HashMap<String, Object> map);
	void updateCampInfo(HashMap<String, Object> map);
	void deleteCamp(HashMap<String, Object> map);
	void insertCamp(HashMap<String, Object> map);
	void insertCampImg(HashMap<String, Object> map);

	int insertReturnInspection(HashMap<String, Object> map);
	List<Map<String, Object>> selectInspectionList();
	List<Map<String, Object>> selectRefundList();
	List<Map<String, Object>> selectExchangeList();
	int updateExchangeStatus(HashMap<String, Object> map);

	List<HashMap<String, Object>> selectRentalsReturnTomorrow();
	List<HashMap<String, Object>> selectSalesByPeriod(HashMap<String, Object> map);
	List<HashMap<String, Object>> selectViewStats(HashMap<String, Object> map);
	List<Map<String, Object>> selectProductViewStats();

	List<Map<String, Object>> selectCouponList(HashMap<String, Object> map);
	void insertCoupon(HashMap<String, Object> map);
	void updateCoupon(HashMap<String, Object> map);
	void updateCouponStatus(HashMap<String, Object> map);
	void deleteCoupon(HashMap<String, Object> map);
	void insertUserCoupon(HashMap<String, Object> map);
	void insertCouponToAllUsers(HashMap<String, Object> map);
	List<Map<String, Object>> selectUserCouponList(HashMap<String, Object> map);
	void updateUserCouponStatus(HashMap<String, Object> map);
	void deleteUserCoupon(HashMap<String, Object> map);

	List<HashMap<String, Object>> selectGradeList();
	int updateGrade(HashMap<String, Object> map);
	void updateMemberGrade(HashMap<String, Object> map);

	int insertAlarm(HashMap<String, Object> map);
	int insertAlarmToAllUsers(HashMap<String, Object> map);
	List<HashMap<String, Object>> selectAlarmLogs(HashMap<String, Object> map);
	HashMap<String, Object> selectMemberById(HashMap<String, Object> map);

	void upsertDelivery(HashMap<String, Object> map);
	List<Map<String, Object>> selectDeliveryList(HashMap<String, Object> map);

	HashMap<String, Object> selectRentalByRentalId(HashMap<String, Object> map);
	HashMap<String, Object> selectOrderById(HashMap<String, Object> map);
}