package com.icia.jnj.test;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.icia.jnj.dao.StoreDao;
import com.icia.jnj.vo.Refund;
import com.icia.jnj.vo.Review;


@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/**/*-context.xml")
public class StoreDaoTest {
	@Autowired
	private StoreDao dao;
	
	@Test
	public void Test1( ) {
		System.out.println(dao.getStoreAllCnt());
	}
	
	// 상단 인기순 4개 (스토어리스트)
	// @Test
	public void getInterestListTest( ) {
		System.out.println(dao.getInterestList());
	}
	// 스토어리스트 12개 (스토어리스트)
	// getStoreList() 
	// @Test
	public void getStoreListTest( ) {
		System.out.println(dao.getStoreListAll("goodsPrice", "desc", 5, 1));
	}
	// 필터 (스토어리스트)
	// getStoreFiter(String colName, String sortType)
	// @Test
	public void getStoreListCate( ) {
		System.out.println(dao.getStoreListCate("goodsPrice", "desc", "액세서리", 5, 1));
	}
	// 검색 (스토어리스트)
	// getStoreSearch(String search)
	// @Test
	public void getStoreSearchTest( ) {
		System.out.println(dao.getStoreSearch("팔", "goodsPrice", "desc", 5, 1));
	}	
		
		
		
		
	// 상품번호, 상품명, 상품가격, 상품내용 (스토어뷰)
	// getViewGoods(int goodsNo)
	// @Test
	public void getViewGoodsTest( ) {
		System.out.println(dao.getViewGoods(1));
	}
	// 상품이미지 (스토어뷰)
	// getViewImg(int goodsNo)
	// @Test
	public void getViewImgTest( ) {
		System.out.println(dao.getViewImg(1));
	}		
	// 상품옵션 (스토어뷰)
	// getViewOption(int goodsNo)
	// @Test
	public void getViewOptionTest( ) {
		System.out.println(dao.getViewOption(1));
	}
		
		
		
		
	// 상품후기 보기 (스토어뷰)
	// getStoreReview(int goodsNo)
	// @Test
	public void getStoreReviewTest( ) {
		System.out.println(dao.getStoreReview(1));
	}	
	// 상품후기 작성 (스토어뷰)
	// insertStoreReview(Review review)
	// @Test
	public void insertStoreReviewTest( ) {
		Review review = new Review();
		review.setGoodsNo(1);
		review.setOptionNo(1);
		review.setWriteId("aaa");
		review.setSatisfy(5);
		review.setReviewContent("만족만족");
		dao.insertStoreReview(review);
	}
	// 상품후기 수정 - 만족도, 구매옵션, 내용, 날짜 (스토어뷰)
	// updateStoreReview(Review review)
	// @Test
	/*public void updateStoreReviewTest( ) {
		Review review = dao.getReviewForUpdate(22, 1);
		review.setOptionNo(1);
		review.setSatisfy(3);
		review.setReviewContent("그냥그냥11");
		dao.updateStoreReview(review);
	}*/	
	// 상품후기 삭제 (스토어뷰)
	// deleteStoreReview(int reviewNo)
	// @Test
	public void deleteStoreReviewTest( ) {
		dao.deleteStoreReview(22);
	}	

	
	
	
	// 이미지 (구매리스트)
	// getOrderListImg(String orderId) 
	// @Test
	public void getOrderListImgTest( ) {
		//System.out.println(dao.getOrderListImg("aaa"));
	}
	// 굿즈 이름, 굿즈 옵션 (구매리스트)
	// getOrderListGoodsOption(String orderId)
	// @Test
	public void getOrderListGoodsOptionTest( ) {
		System.out.println(dao.getOrderListGoodsOption("aaa"));
	}
	// 주문번호, 날짜, 총금액, 상태 (구매리스트)
	// getOrderListOrders(String orderId)
	// @Test
	public void getOrderListOrdersTest( ) {
		//System.out.println(dao.getOrderListOrders("aaa"));
	}

	
	
	
	// 이미지 (구매상세/교환/환불)
	// getOrderViewImg(int orderNo)
	// @Test
	public void getOrderViewImgTest( ) {
		System.out.println(dao.getOrderViewImg(5));
	}
	// 주문번호, 굿즈 번호, 이름, 수량, 건당 금액, 상태 (구매상세/교환/환불)
	// getOrderViewOrders(int orderNo)
	// @Test
	public void getOrderViewOrdersTest( ) {
		System.out.println(dao.getOrderViewOrders(5));
	}
	// 옵션 (구매상세/교환/환불)
	// getOrderViewOption(int orderNo)
	// @Test
	public void getOrderViewOptionTest( ) {
		System.out.println(dao.getOrderViewOption(5));
	}
	// 배송지 정보 (구매상세)
	// getOrderViewDelivery(int orderNo)
	// @Test
	public void getOrderViewDeliveryTest( ) {
		System.out.println(dao.getOrderViewDelivery(5));
	}	
	// 주문정보, 결제정보 (구매상세)
	// getOrderViewPay(int orderNo)
	// @Test
	public void getOrderViewPayTest( ) {
		System.out.println(dao.getOrderViewPay(5));
	}	
	// 총 금액 (구매상세/교환/환불)
	// getOrderViewPayMoney(int orderNo)
	// @Test
	public void getOrderViewPayMoneyTest( ) {
		System.out.println(dao.getOrderViewPayMoney(5));
	}

	
	
	
	// 글쓰기 (교환/환불)
	// insertRefund(Refund refund)
	// @Test
	public void insertRefundTest( ) {
		Refund refund = new Refund();
		refund.setOrderNo(5);
		refund.setGoodsNo(1);
		refund.setOptionNo(1);
		refund.setRefundDivision(1);
		refund.setRefundAccountNo("1111-11111-11");
		refund.setRefundAccountBank("국민은행"); 
		refund.setRefundAccountHolder("aaa");
		refund.setRefundReason("상품하자");
		dao.insertRefund(refund);
	}
	// 교환/환불에 따른 주문상세내역 상태 변경 - 접수 (교환/환불)
	// @Test
	public void Test( ) {
		dao.updateOrdersRecordStateByRefund(5, 1, 1);
	}
}
