package com.icia.jnj.dao;

import java.util.*;

import org.mybatis.spring.*;
import org.springframework.beans.factory.annotation.*;
import org.springframework.stereotype.*;

import com.icia.jnj.domain.*;
import com.icia.jnj.vo.*;

@Repository
public class StoreDao {
	
	@Autowired
	private SqlSessionTemplate tpl;
	
	// 페이지네이션을 위한 전체 스토어리스트 개수 	
	public int getStoreAllCnt() {
		return tpl.selectOne("storeMapper.getStoreAllCnt");
	}
	// 페이지네이션을 위한 카테고리별 스토어리스트 개수 
	public int getStoreCateCnt(String categoryName) {
		return tpl.selectOne("storeMapper.getStoreCateCnt", categoryName);
	}
	//getStoreSearchCnt
	public int getStoreSearchCnt(String keyword) {
		return tpl.selectOne("storeMapper.getStoreSearchCnt", keyword);
	}
	
	
	
	// 상단 인기순 4개 (스토어리스트)
	public List<Map<String, String>> getInterestList() {
		return tpl.selectList("storeMapper.getInterestList");
	}
	// 전체 카테고리 - 스토어리스트 12개 (스토어리스트)
	public List<Map<String, Object>> getStoreListAll(String colName, String sortType, int startArticleNum, int endArticleNum) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("colName", colName);
		map.put("sortType", sortType);
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum", endArticleNum);
		return tpl.selectList("storeMapper.getStoreListAll", map);
	}
	// 그 외 카테고리 - 스토어리스트 12개 (스토어리스트)
	public List<Map<String, Object>> getStoreListCate(String colName, String sortType, String categoryName, int startArticleNum, int endArticleNum) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("colName", colName);
		map.put("sortType", sortType);
		map.put("categoryName", categoryName);
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum", endArticleNum);
		return tpl.selectList("storeMapper.getStoreListCate", map);
	}
	// 검색 (스토어리스트)
	public List<Map<String, String>> getStoreSearch(String keyword, String colName, String sortType, int startArticleNum, int endArticleNum) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("colName", colName);
		map.put("sortType", sortType);
		map.put("keyword", keyword);
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum", endArticleNum);
		return tpl.selectList("storeMapper.getStoreSearch", map);
	}
	
	
	
	
	// 상품번호, 상품명, 상품가격, 상품내용 (스토어뷰)
	public Goods getViewGoods(int goodsNo) {
		return tpl.selectOne("storeMapper.getViewGoods", goodsNo);
	}
	// 상품이미지 (스토어뷰)
	public List<GoodsImg> getViewImg(int goodsNo) {
		return tpl.selectList("storeMapper.getViewImg", goodsNo);
	}
	// 상품옵션 (스토어뷰)
	public List<Map<String, Object>> getViewOption(int goodsNo) {
		return tpl.selectList("storeMapper.getViewOption", goodsNo);
	}
	
	
	
	
	// 상품후기 리스트보기 (스토어뷰)
	public List<Map<String, String>> getStoreReview(int goodsNo) {
		return tpl.selectList("storeMapper.getStoreReview", goodsNo);
	}
	// 상품후기 작성 (스토어뷰)
	public int insertStoreReview(Review review) {
		System.err.println("dao!!!!");
		return tpl.insert("storeMapper.insertStoreReview", review);
	}
	// 상품후기 수정 - 만족도, 구매옵션, 내용, 날짜 (스토어뷰)
	public int updateStoreReview(Review review) {
		return tpl.update("storeMapper.updateStoreReview", review);
	}
	// 상품후기 삭제 (스토어뷰)
	public int deleteStoreReview(int reviewNo) {
		return tpl.delete("storeMapper.deleteStoreReview", reviewNo);
	} 

	
	
	// 이미지 (구매리스트)
	public List<Map<String, Object>> getOrderListImg(String orderId) {
		return tpl.selectList("storeMapper.getOrderListImg", orderId);
	}
	// 굿즈 이름 (구매리스트)
	public List<Map<String, Object>> getOrderListGoodsName(String orderId) {
		return tpl.selectList("storeMapper.getOrderListGoodsName", orderId);
	}
	// 굿즈 옵션 (구매리스트)
	public List<Map<String, Object>> getOrderListGoodsOption(String orderId) {
		return tpl.selectList("storeMapper.getOrderListGoodsOption", orderId);
	}
	// 전체 수량 (구매리스트)
	public int getOrderListQnt(int orderNo) {
		return tpl.selectOne("storeMapper.getOrderListQnt", orderNo);
	}
	// 주문번호, 날짜, 총금액, 상태 (구매리스트)
	public List<Map<String, Object>> getOrderListOrders(String orderId, int startArticleNum, int endArticleNum) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("orderId", orderId);
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum", endArticleNum);
		return tpl.selectList("storeMapper.getOrderListOrders", map);
	}
	// 구매리스트 개수
	public int getOrderListOrdersCnt(String orderId) {
		return tpl.selectOne("storeMapper.getOrderListOrdersCnt", orderId);
	}
	
	
	
	// 이미지 (구매상세/교환/환불)
	public List<Map<String, Object>> getOrderViewImg(int orderNo) {
		return tpl.selectList("storeMapper.getOrderViewImg", orderNo);
	}
	// 주문번호, 굿즈 번호, 이름, 수량, 건당 금액, 상태 (구매상세/교환/환불)
	public List<Map<String, Object>> getOrderViewOrders(int orderNo) {
		return tpl.selectList("storeMapper.getOrderViewOrders", orderNo);
	}
	// 옵션 (구매상세/교환/환불)
	public List<Map<String, Object>> getOrderViewOption(int orderNo) {
		return tpl.selectList("storeMapper.getOrderViewOption", orderNo);
	}
	// 배송지 정보 (구매상세)
	public List<Map<String, Object>> getOrderViewDelivery(int orderNo) {
		return tpl.selectList("storeMapper.getOrderViewDelivery", orderNo);
	}
	// 주문정보, 결제정보 (구매상세)
	public List<Map<String, Object>> getOrderViewPay(int orderNo) {
		return tpl.selectList("storeMapper.getOrderViewPay", orderNo);
	}
	// 총 금액 (구매상세/교환/환불)
	public int getOrderViewPayMoney(int orderNo) {
		return tpl.selectOne("storeMapper.getOrderViewPayMoney", orderNo);
	}
	
	
	
	
	// 글쓰기 (교환/환불)
	public int insertRefund(Refund refund) {
		return tpl.insert("storeMapper.insertRefund", refund);
	}
	// 교환/환불에 따른 주문상세내역 상태 변경 - 접수 (교환/환불)
	public int updateOrdersRecordStateByRefund(int orderNo, int goodsNo, int optionNo) {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("goodsNo", goodsNo);
		map.put("orderNo", orderNo);
		map.put("optionNo", optionNo);
		return tpl.update("storeMapper.updateOrdersRecordStateByRefund", map);
	}
	// 교환/환불에 따른 주문내역 상태 변경 - 교환/환불중 (교환/환불)
	public int updateOrdersStateByRefund(int orderNo) {
		return tpl.update("storeMapper.updateOrdersStateByRefund", orderNo);
	}
	
	
	
	
	// 구매하기 상세정보 입력창
	// 이미지
	public String getGoodsImgForPay(int goodsNo) {
		return tpl.selectOne("storeMapper.getGoodsImgForPay", goodsNo);
	}
	// 굿즈번호, 이름, 가격
	public Map<String, Object> getGoodsForPay(int goodsNo) {
		return tpl.selectOne("storeMapper.getGoodsForPay", goodsNo);
	}
	// 옵션번호, 옵션내용
	public Map<String, Object> getGoodsOptionForPay(int goodsNo, int optionNo) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("goodsNo", goodsNo);
		map.put("optionNo", optionNo);
		return tpl.selectOne("storeMapper.getGoodsOptionForPay", map);
	}
	
	
	
	// 구매하기
	// 구매정보
	public int insertOrders(Orders orders) {
		return tpl.insert("storeMapper.insertOrders", orders);
	}
	// 구매상세정보
	public int insertOrdersRecord(OrdersRecord ordersRecord) {
		return tpl.insert("storeMapper.insertOrdersRecord", ordersRecord);
	}
	// 마지막 주문번호 찾기
	public int getMaxOrderNo() {
		return tpl.selectOne("storeMapper.getMaxOrderNo");
	}
	// 재고수량, 판매수량 변경
	public int updateSellStockQnt(int orderQnt, int goodsNo) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("goodsNo", goodsNo);
		map.put("orderQnt", orderQnt);
		return tpl.update("storeMapper.updateSellStockQnt", map);
	}
	
	
	
	// 주문 취소
	public void updateCancelOrders(int orderNo) {
		tpl.update("storeMapper.updateCancelOrders", orderNo);
	}
	public void updateCancelOrdersRecord(int orderNo) {
		tpl.update("storeMapper.updateCancelOrdersRecord", orderNo);
	}
	
	
	// 구매 확정
	public void updateSuccessOrdersRecord(int orderNo, int goodsNo, int optionNo) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("goodsNo", goodsNo);
		map.put("optionNo", optionNo);
		map.put("orderNo", orderNo);
		tpl.update("storeMapper.updateSuccessOrdersRecord", map);
	}
	public void updateSuccessOrders(int orderNo) {
		tpl.update("storeMapper.updateSuccessOrders", orderNo);
	}
	
	
	
	
	// 주리 0102
	// 상품
	// 리스트
	public int getCountGoodsRegisterList(AdStoreInfo info) {
		return tpl.selectOne("storeMapper.getCountGoodsRegisterList", info);
	}

	public List<Goods> getGoodsRegisterList(AdStoreInfo info) {
		return tpl.selectList("storeMapper.getGoodsRegisterList", info);
	}

	// 쓰기
	public int insertGoodsImg(GoodsImg gImg) {
		return tpl.insert("storeMapper.insertGoodsImg", gImg);
	}

	public int insertGoodsOption(GoodsOption gOption) {
		return tpl.insert("storeMapper.insertGoodsOption", gOption);
	}

	public int insertGoods(Goods goods) {
		return tpl.insert("storeMapper.insertGoods", goods);
	}

	public int getMaxGoodsNo() {
		return tpl.selectOne("storeMapper.getMaxGoodsNo");
	}

	// 수정
	public int updateGoodsImg(GoodsImg gImg) {
		return tpl.update("storeMapper.updateGoodsImg", gImg);
	}

	public int updateGoodsOption(GoodsOption gOption) {
		return tpl.update("storeMapper.updateGoodsOption", gOption);
	}

	public int updateGoods(Goods goods) {
		System.err.println(goods);
		return tpl.update("storeMapper.updateGoods", goods);
	}

	// 삭제
	public int deleteGoodsImg(int goodsNo) {
		return tpl.delete("storeMapper.deleteGoodsImg", goodsNo);
	}

	public int deleteGoodsOption(int goodsNo) {
		return tpl.delete("storeMapper.deleteGoodsOption", goodsNo);
	}

	public int deleteGoods(int goodsNo) {
		return tpl.delete("storeMapper.deleteGoods", goodsNo);
	}

	// 해당 상품 정보 가져오기
	public Goods getGoods(int goodsNo) {
		return tpl.selectOne("storeMapper.getGoods", goodsNo);
	}

	public List<GoodsImg> getGoodsImg(int goodsNo) {
		return tpl.selectList("storeMapper.getGoodsImg", goodsNo);
	}

	public List<GoodsOption> getGoodsOption(int goodsNo) {
		return tpl.selectList("storeMapper.getGoodsOption", goodsNo);
	}

	// 주문
	public int getCountAdminOrdersList(AdOrdersInfo info) {
		return tpl.selectOne("storeMapper.getCountAdminOrdersList", info);
	}

	public List<Orders> getAdminOrdersList(AdOrdersInfo info) {
		return tpl.selectList("storeMapper.getAdminOrdersList", info);
	}

	// 주문 상태 개수 가져오기
	public List<Map<String, Integer>> getAdminOrderState(AdOrdersInfo info) {
		return tpl.selectList("storeMapper.getAdminOrderState", info);
	}

	// 주문 상태 바꾸기
	public int updateOrdersState(int orderNo, int selectOrderState) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("orderNo", orderNo);
		map.put("orderState", selectOrderState);
		return tpl.update("storeMapper.updateOrdersState", map);
	}

	public int updateOrdersRecordState(int orderNo, int selectOrderState) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("orderNo", orderNo);
		map.put("orderState", selectOrderState);
		return tpl.update("storeMapper.updateOrdersRecordState", map);
	}

	// 후원 매출 내역 가져오기
	public int getTotalStoreMoney(String sqlWhere) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("sqlWhere", sqlWhere);
		return tpl.selectOne("storeMapper.getTotalStoreMoney", map);
	}

	public int getCountTotalStoreList(AdSalesStoreInfo info) {
		return tpl.selectOne("storeMapper.getCountTotalStoreList", info);
	}

	public List<Orders> getTotalStoreList(AdSalesStoreInfo info) {
		return tpl.selectList("storeMapper.getTotalStoreList", info);
	}
}
