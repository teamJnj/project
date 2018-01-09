package com.icia.jnj.service;

import java.io.*;
import java.util.*;

import org.springframework.beans.factory.annotation.*;
import org.springframework.security.access.prepost.*;
import org.springframework.stereotype.*;
import org.springframework.util.*;
import org.springframework.web.multipart.*;

import com.icia.jnj.dao.*;
import com.icia.jnj.domain.*;
import com.icia.jnj.util.*;
import com.icia.jnj.vo.*;

@Service
public class StoreService {
	
	@Value("\\\\192.168.0.203\\service\\goods")
	private String uploadPath;
		
	@Autowired
	private	StoreDao dao;
	
	// 상단 인기순 4개 (스토어리스트)
	public List<Map<String, String>> getInterestList() {
		return dao.getInterestList();
	}
	// 전체 카테고리 - 스토어리스트 12개 (스토어리스트)
	public Map<String, Object> getStoreListAll(String colName, String sortType, int pageNo) {
		Pagination pagination = PagingUtil.setPageMaker(pageNo, dao.getStoreAllCnt(),12);
		Map<String, Object> map = new HashMap<String, Object>();		
		map.put("pagination", pagination);
		map.put("storeList", dao.getStoreListAll(colName, sortType, pagination.getStartArticleNum(), pagination.getEndArticleNum()));
		return map;
	}
	// 그 외 카테고리 - 스토어리스트 12개 (스토어리스트)
	public Map<String, Object> getStoreListCate(String colName, String sortType, String categoryName, int pageNo) {
		Pagination pagination = PagingUtil.setPageMaker(pageNo, dao.getStoreCateCnt(categoryName),12);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pagination", pagination);
		map.put("storeList", dao.getStoreListCate(colName, sortType, categoryName, pagination.getStartArticleNum(), pagination.getEndArticleNum()));
		return map;
	}
	// 검색 (스토어리스트)
	public Map<String, Object> getStoreSearch(String keyword, String colName, String sortType, int pageNo) {		
		System.out.println("검색dao "+keyword);
		Pagination pagination = PagingUtil.setPageMaker(pageNo, dao.getStoreSearchCnt(keyword),12);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pagination", pagination);
		map.put("storeList", dao.getStoreSearch(keyword, colName, sortType, pagination.getStartArticleNum(), pagination.getEndArticleNum()));
		return map;
	}
		
		
		
		
	// 스토어뷰
	public Map<String, Object> getView(int goodsNo) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("goods", dao.getViewGoods(goodsNo));
		map.put("goodsImg", dao.getViewImg(goodsNo));
		map.put("goodsOption", dao.getViewOption(goodsNo));
		return map;
	}
		
		
		
		
	// 상품후기 리스트보기 (스토어뷰)
	public List<Map<String, String>> getStoreReview(int goodsNo) {
		return dao.getStoreReview(goodsNo);
	}
	//@PreAuthorize("hasRole('ROLE_USER')")
	// 상품후기 작성 (스토어뷰)
	public boolean insertStoreReview(Review review) {
		return dao.insertStoreReview(review)==1? true : false;
	}
	
		
		
	
	 
	// 구매리스트
	public Map<String, Object> getMemberOrderList(String orderId, int pageNo) {
		Pagination pagination = PagingUtil.setPageMaker(pageNo, dao.getOrderListOrdersCnt(orderId), 10);
		List<Map<String, Object>> orderListOrders = dao.getOrderListOrders(orderId, pagination.getStartArticleNum(), pagination.getEndArticleNum());
		List<Map<String, Object>> orderListImg = dao.getOrderListImg(orderId);
		List<Map<String, Object>> orderListGoodsName = dao.getOrderListGoodsName(orderId);
		List<Map<String, Object>> orderListGoodsOption = dao.getOrderListGoodsOption(orderId);
			
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
			
			
		for(int i=0; i<orderListOrders.size(); i++) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("orderListImg", orderListImg.get(i));
			map.put("orderListGoodsName", orderListGoodsName.get(i));
			map.put("orderListGoodsOption", orderListGoodsOption.get(i));
			map.put("orderListOrders", orderListOrders.get(i));
			map.put("orderListQnt", dao.getOrderListQnt(Integer.parseInt(orderListImg.get(i).get("ORDERNO").toString())));
			list.add(map);
		}
			
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("mOrderList", list);
		map.put("pagination", pagination);
		
		return map;
	}
	
		
		
		
	// 구매상세 내역, 환불/교환 내역
	//@PreAuthorize("isAuthenticated() and returnObject.member_id == principal.username")
	public Map<String, Object> getOrderViewGoods(int orderNo) {
		List<Map<String, Object>> orderViewImg = dao.getOrderViewImg(orderNo);
		List<Map<String, Object>> orderViewOrders = dao.getOrderViewOrders(orderNo);
		List<Map<String, Object>> orderViewOption = dao.getOrderViewOption(orderNo);
		
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();		
				
		for(int i=0; i<orderViewOrders.size(); i++) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("orderViewImg", orderViewImg.get(i));
			map.put("orderViewOrders", orderViewOrders.get(i));
			map.put("orderViewOption", orderViewOption.get(i));
			list.add(map);
		}
		
		Map<String, Object> map = new HashMap<String, Object>();		
		map.put("orderViewOrders", list);
		map.put("orderViewDelivery", dao.getOrderViewDelivery(orderNo));
		map.put("orderViewPay", dao.getOrderViewPay(orderNo));
		return map;
	}
		
		
		
		
	// 글쓰기 + 상태 변경 - 접수 (교환)
	//@PreAuthorize("#writeId == principal.username")
	public boolean insertChange(List<Refund> refund) {
		int result = 0;
		int cnt = 0;
		for(int i=0; i<refund.size(); i++) {
			result = dao.insertRefund(refund.get(i));
			if(result!=0) {
				dao.updateOrdersRecordStateByRefund(refund.get(i).getOrderNo(), refund.get(i).getGoodsNo(), refund.get(i).getOptionNo());
				dao.updateOrdersStateByRefund(refund.get(i).getOrderNo());
				cnt++;
			}	
		}
		
		if(cnt==refund.size()) 
			return true;
		else 
			return false;
	}
	
	// 글쓰기 + 상태 변경 - 접수 (환불)
	//@PreAuthorize("#writeId == principal.username")
	public boolean insertRefund(List<Refund> refund) {
		int result = 0;
		int cnt = 0;
		for(int i=0; i<refund.size(); i++) {
			result = dao.insertRefund(refund.get(i));
			if(result!=0) {
				dao.updateOrdersRecordStateByRefund(refund.get(i).getOrderNo(), refund.get(i).getGoodsNo(), refund.get(i).getOptionNo());
				dao.updateOrdersStateByRefund(refund.get(i).getOrderNo());
				cnt++;
			}	
		}
		
		if(cnt==refund.size()) 
			return true;
		else 
			return false;
	}
	
	
	
	
	// 구매 정보작성 페이지
	// 이미지
	public String getGoodsImgForPay(int goodsNo) {
		return dao.getGoodsImgForPay(goodsNo);
	}
	// 굿즈번호, 이름, 가격
	public Map<String, Object> getGoodsForPay(int goodsNo) {
		return dao.getGoodsForPay(goodsNo);
	}
	// 옵션번호, 옵션내용
	public Map<String, Object> getGoodsOptionForPay(int goodsNo, int optionNo) {
		return dao.getGoodsOptionForPay(goodsNo, optionNo);
	}
	
	
	
	// 구매하기 
	public boolean payGoods(Orders orders, List<OrdersRecord> ordersRecord) {
		int orderNo = dao.getMaxOrderNo();
		
		int ordersRecordResult = 0;
		int orderCnt = 0;
		for(int i=0; i<ordersRecord.size(); i++) {
			if(orderNo==0) {
				orders.setOrderNo(1);
				ordersRecord.get(i).setOrderNo(1);
			} else {
				orders.setOrderNo(orderNo+1);
				ordersRecord.get(i).setOrderNo(orderNo+1);
			}
			
			ordersRecordResult = dao.insertOrdersRecord(ordersRecord.get(i));
			System.out.println(ordersRecord);
			if(ordersRecordResult!=0) {
				dao.updateSellStockQnt(ordersRecord.get(i).getOrderQnt(), ordersRecord.get(i).getGoodsNo());
				orderCnt++;
			}	
		}
		
		
		int ordersResult = dao.insertOrders(orders);
		if(orderCnt==ordersRecord.size()) {
			return true;
		} else {
			return false;
		}
	}
	
	// 주문 취소
	public void updateCancelOrders(int orderNo) {
		dao.updateCancelOrders(orderNo);
	}
	public void updateCancelOrdersRecord(int orderNo) {
		dao.updateCancelOrdersRecord(orderNo);
	}
	
	
	// 구매확정
	public void updateSuccessOrdersRecord(int orderNo, int goodsNo, int optionNo) {
		dao.updateSuccessOrdersRecord(orderNo, goodsNo, optionNo);
	}
	public void updateSuccessOrders(int orderNo) {
		dao.updateSuccessOrders(orderNo);
	}
	
	// 주리
	public Map<String, Object> getGoodsList(AdStoreInfo info) {

		// 검색 내용이 있는지 판단하고 있다면 검색내용을 spl문에 쓸 수 있게 바꿔서 셋팅
		// 없을때는 기본셋팅으로
		info.setSqlText("");

		if (!info.getSearchText().equals("%")) {
			if (info.getSearchColName().equals("goodsName"))
				info.setSqlText("where goodsName like '%" + info.getSearchText() + "%'");

			if (info.getSearchColName().equals("optionContent"))
				info.setSqlText("where optionContent like '%" + info.getSearchText() + "%'");

			else if (info.getSearchColName().equals("categoryName"))
				info.setSqlText("where categoryName like '%" + info.getSearchText() + "%'");

			else if (info.getSearchColName().equals("goodsState"))
				info.setSqlText("where goodsState like '%" + info.getSearchText() + "%'");
		} else {
			if (info.getSearchColName().equals("goodsPrice"))
				info.setSqlText(
						"where goodsPrice>=" + info.getStartMoney() + " and goodsPrice<= " + info.getEndMoney());

			else if (info.getSearchColName().equals("goodsDate"))
				info.setSqlText("where to_date(goodsDate, 'yyyyMMdd')>=to_date(" + info.getStartDate()
						+ ", 'yyyyMMdd') and to_date(goodsDate, 'yyyyMMdd')<= to_date(" + info.getEndDate()
						+ ", 'yyyyMMdd')");
		}

		int articleCnt = dao.getCountGoodsRegisterList(info);

		Pagination pagination = PagingUtil.setPageMaker(info.getPageno(), articleCnt, 10);

		info.setStartArticleNum(pagination.getStartArticleNum());
		info.setEndArticleNum(pagination.getEndArticleNum());

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("pagination", pagination);
		map.put("goodsList", dao.getGoodsRegisterList(info));

		return map;
	}

	// 상품 등록
	public void insertGoods(Goods goods, MultipartFile[] files, String[] optionContent) throws IOException {

		
		System.err.println("상품 추가 실행합니다!");
		
		// 상품 번호를 먼저 가져오고 상품 추가
		int goodsNo = dao.getMaxGoodsNo();
		goods.setGoodsNo(goodsNo);
		dao.insertGoods(goods);

		// 상품 사진 추가
		// files는 파일 업로드를 안해도 length가 1, 파일 하나 업로드해도 length가 1이다
		int idx = 0;
		for (MultipartFile file : files) {

			if (file.getOriginalFilename().equals(""))
				break;

			String imgName = System.currentTimeMillis() + "-" + (idx + 1) + "-" + file.getOriginalFilename();

			GoodsImg gImg = new GoodsImg();
			gImg.setGoodsNo(goodsNo);
			gImg.setGoodsImgNo(idx + 1);
			gImg.setGoodsImg(imgName);

			File f = new File(uploadPath, imgName);
			FileCopyUtils.copy(file.getBytes(), f);

			dao.insertGoodsImg(gImg);
			idx++;
		}

		// 상품 옵션 추가
		for (int i = 0; i < optionContent.length; i++) {
			GoodsOption option = new GoodsOption();
			option.setGoodsNo(goodsNo);
			option.setOptionNo(i + 1);
			option.setOptionContent(optionContent[i]);
			dao.insertGoodsOption(option);
		}

	}

	// 상품 수정
	public Map<String, Object> selectGoodsInfo(int goodsNo) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("goods", dao.getGoods(goodsNo));
		map.put("goodsImg", dao.getGoodsImg(goodsNo));
		map.put("goodsOption", dao.getGoodsOption(goodsNo));
		return map;
	}

	public void updateGoods(Goods goods, MultipartFile[] files, String[] optionContent, int optionSize, int imgSize)
			throws IOException {

		// 상품 변경
		System.err.println(goods);
		dao.updateGoods(goods);

		// 상품 사진 변경
		int idx = 0;
		for (MultipartFile file : files) {

			if (file.getOriginalFilename().equals("")) {
				System.out.println("사진이 빈칸입니다. 안바꾼다는 이야기죠! : " + idx);
			} else {
				System.out.println("사진이 바꿉시다.. : " + idx);
				String imgName = System.currentTimeMillis() + "-" + (idx + 1) + "-" + file.getOriginalFilename();

				GoodsImg gImg = new GoodsImg();
				gImg.setGoodsNo(goods.getGoodsNo());
				gImg.setGoodsImgNo(idx + 1);
				gImg.setGoodsImg(imgName);

				File f = new File(uploadPath, imgName);
				FileCopyUtils.copy(file.getBytes(), f);

				if (idx < imgSize)
					dao.updateGoodsImg(gImg);
				else
					dao.insertGoodsImg(gImg);
			}
			idx++;
		}
		System.err.println("사진 변경 완료");

		// 상품 옵션 변경
		for (int i = 0; i < optionContent.length; i++) {
			GoodsOption option = new GoodsOption();
			option.setGoodsNo(goods.getGoodsNo());
			option.setOptionNo(i + 1);
			option.setOptionContent(optionContent[i]);

			if (i < optionSize)
				dao.updateGoodsOption(option);
			else
				dao.insertGoodsOption(option);
		}
		System.err.println("옵션 변경 완료");
	}

	// 상품 삭제
	public void deleteGoods(int goodsNo) {
		dao.deleteGoods(goodsNo);
		dao.deleteGoodsOption(goodsNo);
		dao.deleteGoodsImg(goodsNo);
	}

	// 주문 리스트 읽기
	public Map<String, Object> getAdminOrderList(AdOrdersInfo info) {

		// 검색 내용이 있는지 판단하고 있다면 검색내용을 spl문에 쓸 수 있게 바꿔서 셋팅
		// 없을때는 기본셋팅으로
		info.setSqlText("");

		if (!info.getSearchText().equals("%")) {
			if (info.getSearchColName().equals("orderNo"))
				info.setSqlText("where orderNo like '%" + info.getSearchText() + "%'");
			else if (info.getSearchColName().equals("orderId"))
				info.setSqlText("where orderId like '%" + info.getSearchText() + "%'");
			else if (info.getSearchColName().equals("orderState")) {
				if (info.getSearchText().equals("3"))
					info.setSqlText("where orderState>=3 and orderState<=5");
				else if (info.getSearchText().equals("6"))
					info.setSqlText("where orderState>=6 and orderState<=8");
				else
					info.setSqlText("where orderState like '%" + info.getSearchText() + "%'");
			}

		} else {
			if (info.getSearchColName().equals("orderDate"))
				info.setSqlText("where to_date(orderDate, 'yyyyMMdd')>=to_date(" + info.getStartDate()
						+ ", 'yyyyMMdd') and to_date(orderDate, 'yyyyMMdd')<= to_date(" + info.getEndDate()
						+ ", 'yyyyMMdd')");
		}

		int articleCnt = dao.getCountAdminOrdersList(info);

		Pagination pagination = PagingUtil.setPageMaker(info.getPageno(), articleCnt, 10);

		info.setStartArticleNum(pagination.getStartArticleNum());
		info.setEndArticleNum(pagination.getEndArticleNum());

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("pagination", pagination);
		map.put("ordersList", dao.getAdminOrdersList(info));
		map.put("stateCount", dao.getAdminOrderState(info));
		map.put("adOrdersInfo", info);
		return map;
	}

	// 관리자가 구매내역 상태들 바꾸기
	public void updateAdminOrderState(int orderNo, int selectOrderState) {
		dao.updateOrdersState(orderNo, selectOrderState);
		dao.updateOrdersRecordState(orderNo, selectOrderState);
	}

	// 후원 매출 내역 가져오기
	public Map<String, Object> getStoreSalesList(AdSalesStoreInfo info) {

		info.setSqlText("");

		if (!info.getSearchText().equals("%")) {
		} else {
			if (info.getSearchColName().equals("orderDate")
					&& (info.getStartDate() != null && info.getEndDate() != null))
				info.setSqlText("where to_date(orderDate, 'yyyyMMdd')>=to_date(" + info.getStartDate()
						+ ", 'yyyyMMdd') and to_date(orderDate, 'yyyyMMdd')<= to_date(" + info.getEndDate()
						+ ", 'yyyyMMdd')");
		}

		int articleCnt = dao.getCountTotalStoreList(info);

		Pagination pagination = PagingUtil.setPageMaker(info.getPageno(), articleCnt, 10);

		info.setStartArticleNum(pagination.getStartArticleNum());
		info.setEndArticleNum(pagination.getEndArticleNum());

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("pagination", pagination);
		map.put("salesStoreList", dao.getTotalStoreList(info));
		map.put("adSalesStoreInfo", info);
		map.put("totalStoreMoney", dao.getTotalStoreMoney(""));

		return map;
	}
	
}
