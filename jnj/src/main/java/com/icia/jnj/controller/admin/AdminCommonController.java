package com.icia.jnj.controller.admin;

import java.io.*;
import java.security.*;
import java.util.*;

import javax.servlet.http.*;
import javax.validation.*;

import org.springframework.beans.factory.annotation.*;
import org.springframework.http.*;
import org.springframework.stereotype.*;
import org.springframework.ui.*;
import org.springframework.web.bind.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.*;
import org.springframework.web.servlet.mvc.support.*;

import com.google.gson.*;
import com.icia.jnj.constant.*;
import com.icia.jnj.domain.*;
import com.icia.jnj.service.*;
import com.icia.jnj.util.*;
import com.icia.jnj.vo.*;

@Controller
@RequestMapping("/admin")
public class AdminCommonController {

	@Autowired
	private Gson gson;
	
	@Autowired
	private CenterService 		centerService;		// center
	
	@Autowired
	private SponsorService 		sponsorService;		// pet_sponsor, center_sponsor_record
	
	@Autowired
	private AdoptService 		adoptService;		// adopt
	
	@Autowired
	private VolunteerService 	volService;			// volunteer
	
	@Autowired
	private MarketService 		marketService;		// market
	
	@Autowired
	private BoardService 		boardService;		// find
	
	@Autowired
	private QnaService			qnaService;			// qna
	
	@Autowired
	private FooterService 		footerService;
	
	@Autowired
	private StoreService		storeService;		
	
	@InitBinder
	public void initBinder(WebDataBinder dataBinder) {
		dataBinder.registerCustomEditor(String.class, "sponsorDate", new DatePropertyEditor());
		dataBinder.registerCustomEditor(String.class, "adoptApplyDate", new DatePropertyEditor());
		dataBinder.registerCustomEditor(String.class, "endDate", new DatePropertyEditor());
		dataBinder.registerCustomEditor(String.class, "startDate", new DatePropertyEditor());
	}
	
	
	// 1. 관리자 공지사항 ajax
	@GetMapping("/notice")
	public String notice(Model model, AdNoticeInfo info) {

		Map<String, Object> map = footerService.getNoticeList(info);
		model.addAttribute("map", gson.toJson(map));
		model.addAttribute("adminViewName", "common/adNotice.jsp");
		return "admin/adIndex";
	}

	// 1. 관리자 일반회원 - 게시판 이용 내역( ajax )
	@GetMapping(value = "/notice/sort", produces = "application/text; charset=utf8")
	public ResponseEntity<String> noticeAjax(Model model, AdNoticeInfo info) {

		Map<String, Object> map = footerService.getNoticeList(info);
		return new ResponseEntity<String>(gson.toJson(map), HttpStatus.OK);
	}
	
	// 1-1. 글쓰기페이지로 이동 -> 글쓰기화면
	@GetMapping("/notice/write")
	public String noticeWriteGo(Model model, Principal principal) {
		return "admin/common/adNoticeWrite";
	}
	@PostMapping("/notice/write")
	public ResponseEntity<Boolean> noticeWrite( Notice notice ) {
		footerService.insertBoardNotice(notice);
		return new  ResponseEntity<Boolean>( true, HttpStatus.OK);
	}

	// 1-2. 공지사항 글보기 화면
	@GetMapping("/notice/view")
	public String boardNoticeView(int noticeNo, Model model) {
		System.err.println(gson.toJson(footerService.viewBoardNotice(noticeNo)));
		model.addAttribute("map", gson.toJson(footerService.viewBoardNotice(noticeNo)));
		return "admin/common/adNoticeView";
	}

	// 1-3. 공지사항 정보 수정
	@GetMapping("/notice/update")
	public String noticeUpdateGo(Model model, int noticeNo) {
		model.addAttribute("notice", gson.toJson(footerService.getBoardNotice(noticeNo)));
		return "admin/common/adNoticeUpdate";
	}
	@PostMapping("/notice/update")
	public ResponseEntity<Boolean> noticeUpdate(Notice notice) {
		footerService.updateBoardNotice(notice);
		return new  ResponseEntity<Boolean>( true, HttpStatus.OK);
	}

	// 1-4. 공지사항 삭제
	@PostMapping("/notice/delete")
	public ResponseEntity<Boolean> noticeDelete(Notice notice, RedirectAttributes ra) {
		footerService.deleteBoardNotice(notice);
		return new  ResponseEntity<Boolean>( true, HttpStatus.OK);
	}
	
	
	
	
	// 2. 관리자 일반,회원 - 1:1문의
	@GetMapping("/qna")
	public String qnaList(Model model, AdMQnaInfo info) {

		Map<String, Object> map = qnaService.getTotalQnaList(info);
		model.addAttribute("map", gson.toJson(map));
		model.addAttribute("adminViewName", "common/adQna.jsp");
		return "admin/adIndex";
	}

	// 2. 관리자 전체 - 1:1문의( ajax )
	@GetMapping(value = "/qna/sort", produces = "application/text; charset=utf8")
	public ResponseEntity<String> qnaListAjax(Model model, AdMQnaInfo info) {

		Map<String, Object> map = qnaService.getTotalQnaList(info);
		return new ResponseEntity<String>(gson.toJson(map), HttpStatus.OK);
	}

	// 2-1. 관리자 전체 - 1:1문의 - 상세보기
	@GetMapping("/qna/view")
	public String qnaView(Model model, int qnaNo, String writeId) {

		QnA qna = qnaService.getQnaView(qnaNo, writeId);

		Map<String, Object> map = new HashMap<String, Object>();
		model.addAttribute("qna", gson.toJson(qna));

		return "admin/common/adQnaWrite";
	}

	// 2-2. 관리자 전체 - 1:1문의 - qna 답변쓰기
	@PostMapping(value = "/qna/answer", produces = "application/text; charset=utf8")
	public ResponseEntity<String> updateAnswer(Model model, QnA qna) {
		qnaService.updateAnswer(qna);
		QnA newQna = qnaService.getQnaView(qna.getQnaNo(), qna.getWriteId());
		return new ResponseEntity<String>(gson.toJson(newQna), HttpStatus.OK);
	}
	
	
	// 3. 관리자 전체 - 프리마켓내역
	@GetMapping("/market")
	public String marketList( Model model, AdMarketInfo info ){
		
		Map<String,Object> map = marketService.getTotalMarketList( info );
		map.put( "adMMarketInfo", info );
		model.addAttribute("map", gson.toJson(map));
		
		model.addAttribute("adminViewName", "common/adMarket.jsp");
		return "admin/adIndex";
	}
	
	// 3. 관리자 전체 - 프리마켓내역( ajax )
	@GetMapping( value="/market/sort", produces="application/text; charset=utf8" )
	public ResponseEntity<String> marketListAjax( Model model, AdMarketInfo info ){
		
		Map<String,Object> map = marketService.getTotalMarketList( info );
		map.put( "adMMarketInfo", info );
		return new  ResponseEntity<String>( gson.toJson(map), HttpStatus.OK);
	}
	
	// 3-1. 관리자 전체 - 프리마켓 - 상세화면
	@GetMapping("/market/view")
	public String marketView(Model model, int marketNo) {
		model.addAttribute("map", gson.toJson(marketService.viewMarket(marketNo)));
		return "admin/common/adMarketView";
	}
	
	// 3-2. 글 정보 수정
	@GetMapping("/market/update")
	public String marketUpdate(Model model, int marketNo) {
		model.addAttribute("market", gson.toJson(marketService.getMarket(marketNo)));
		return "admin/common/adMarketUpdate";
	}
	@PostMapping("/market/update")
	public ResponseEntity<Boolean> marketUpdate(Market market) {
		marketService.updateMarket(market);
		return new ResponseEntity<Boolean>(true,HttpStatus.OK);
	}

	// 3-3. 프리마켓 글 삭제
	@PostMapping("/market/delete")
	public ResponseEntity<Boolean> marketDelete(Market market) {
		System.out.println(market);
		marketService.deleteMarket(market);
		return new ResponseEntity<Boolean>(true,HttpStatus.OK);
	}
	
	// 3-4. 마켓 글쓰기 페이지로 이동 -> 글쓰기화면
	@GetMapping("/market/write")
	public String marketWrite(Model model) {
		return "admin/common/adMarketWrite";
	}
	@PostMapping("/market/write")
	public ResponseEntity<Boolean> market(Market market) {
		marketService.insertMarket(market);
		return new ResponseEntity<Boolean>(true,HttpStatus.OK);
	}
	
	
	// 3-5. 관리자 전체 - 프리마켓신청내역
	@GetMapping("/market/apply")
	public String marketApplyList(Model model, AdMarketApplyInfo info) {
		Map<String, Object> map = marketService.getTotalMarketApplyList(info);
		map.put("adMMarketApplyInfo", info);
		model.addAttribute("map", gson.toJson(map));

		return "admin/common/adMarketApply";
	}

	// 3-5. 관리자 전체 - 프리마켓신청내역( ajax )
	@GetMapping(value = "/market/apply/sort", produces = "application/text; charset=utf8")
	public ResponseEntity<String> marketApplyListAjax(Model model, AdMarketApplyInfo info) {

		Map<String, Object> map = marketService.getTotalMarketApplyList(info);
		map.put("adMMarketApplyInfo", info);
		return new ResponseEntity<String>(gson.toJson(map), HttpStatus.OK);
	}
	
	// 3-6. 관리자 전체 - 프리마켓 - 참가 거절
	@PostMapping(value = "/market/apply/cancle", produces = "application/text; charset=utf8")
	public ResponseEntity<String> marketApplyCancle(AdMarketApplyInfo info, int marketNo) {
		marketService.updateMarketApplyState(marketNo, info.getMemberId(), CT.VOLUNTEERAPPLY_VOLUNTEERAPPLYSTATE_CANCLE, "-1");
		Map<String, Object> map = marketService.getTotalMarketApplyList(info);
		map.put("adMarketApplyInfo", info);
		return new ResponseEntity<String>(gson.toJson(map), HttpStatus.OK);
	}
	
	
	
	
	
	
	// 4. 관리자 전체 - 상품 관리 리스트
	@GetMapping("/goods")
	public String goodsList( Model model, AdStoreInfo info ) {
		
		System.err.println(info);
		
		Map<String, Object> map = storeService.getGoodsList(info);
		map.put("adStoreInfo", info);
		model.addAttribute("map", gson.toJson(map));

		model.addAttribute( "adminViewName", "common/adGoods.jsp" );
		return "admin/adIndex";
	}

	// 4. 관리자 전체 - 상품 관리 리스트( ajax )
	@GetMapping(value = "/goods/sort", produces = "application/text; charset=utf8")
	public ResponseEntity<String> goodsListAjax( Model model, AdStoreInfo info ) {
		Map<String, Object> map = storeService.getGoodsList(info);
		map.put("adStoreInfo", info);
		return new ResponseEntity<String>(gson.toJson(map), HttpStatus.OK);
	}
	
	// 4-1. 상품 등록
	@GetMapping("/goods/register")
	public String goodsListRegister() {
		return "admin/common/adGoodsRegister";
	}
	@PostMapping("/goods/register")
	public ResponseEntity<Boolean> goodsListRegister(Model model, Goods goods, @RequestParam(required=false)MultipartFile[] files, String[] optionContent ) throws IOException {
		storeService.insertGoods(goods, files, optionContent);
		return new ResponseEntity<Boolean>(true,HttpStatus.OK);
	}
	
	
	
	// 4-2. 상품 수정
	@GetMapping("/goods/update")
	public String goodsUpdate(Model model, int goodsNo) {
		Map<String, Object> map = storeService.selectGoodsInfo(goodsNo);
		model.addAttribute("map", gson.toJson(map));
		return "admin/common/adGoodsUpdate";
	}
	@PostMapping("/goods/update")
	public ResponseEntity<Boolean> goodsUpdate(Model model, Goods goods, 
			@RequestParam(required=false)MultipartFile[] files, 
			@RequestParam(required=false)String[] optionContent,
			int optionSize, int imgSize) throws IOException {
		
		storeService.updateGoods(goods, files, optionContent, optionSize, imgSize);
		
		return new ResponseEntity<Boolean>(true,HttpStatus.OK);
	}
	
	// 상품 삭제
	@PostMapping("/goods/delete")
	public ResponseEntity<Void> goodsdelete(Model model, int goodsNo){
		System.err.println(goodsNo);
		storeService.deleteGoods(goodsNo);
		return new ResponseEntity<Void>(HttpStatus.OK);
	}
	
	
	
	
	
	// 일반회원 구매내역 리스트
	// 9. 관리자 전체 - 구매내역
	@GetMapping("/orders")
	public String ordersList(Model model, AdOrdersInfo info) {

		info.setSqlWhere("");

		Map<String, Object> map = storeService.getAdminOrderList(info);
		model.addAttribute("map", gson.toJson(map));

		model.addAttribute( "adminViewName", "common/adOrders.jsp" );
		return "admin/adIndex";
	}

	// 9. 관리자 전체 - 구매내역
	@GetMapping(value = "/orders/sort", produces = "application/text; charset=utf8")
	public ResponseEntity<String> ordersListAjax(Model model, AdOrdersInfo info) {
		info.setSqlWhere("");
		Map<String, Object> map = storeService.getAdminOrderList(info);
		return new ResponseEntity<String>(gson.toJson(map), HttpStatus.OK);
	}

	// 9-1. 관리자 전체 - 구매내역 - 상태바꾸기...
	@PostMapping(value = "/orders/state", produces = "application/text; charset=utf8")
	public ResponseEntity<String> orderStateAjax(Model model, AdOrdersInfo info, int orderNo, int selectOrderState) {
		storeService.updateAdminOrderState(orderNo, selectOrderState);
		info.setSqlWhere("");
		Map<String, Object> map = storeService.getAdminOrderList(info);
		return new ResponseEntity<String>(gson.toJson(map), HttpStatus.OK);
	}
	
	// 9-2. 관리자 전체 - 구매상세뷰
	@GetMapping("/orders/view")
	public String getMemberOrderView(Model model, int orderNo, String orderId) {
		model.addAttribute("writeId", new Gson().toJson(orderId));
		model.addAttribute("map", new Gson().toJson(storeService.getOrderViewGoods(orderNo)));
		return "admin/common/adOrderView";
	}
	
	
	
	
	// 후원 매출 내역
	@GetMapping("/sales")
	public String salesList(Model model, AdSalesInfo info) {

		info.setSqlWhere("");

		Map<String, Object> map = sponsorService.getSponsorSalesList(info);
		model.addAttribute("map", gson.toJson(map));

		model.addAttribute( "adminViewName", "common/adSales.jsp" );
		return "admin/adIndex";
	}
	@GetMapping(value = "/sales/sort", produces = "application/text; charset=utf8")
	public ResponseEntity<String> salesListAjax(Model model, AdSalesInfo info) {
		info.setSqlWhere("");
		System.err.println("info : " + info);
		Map<String, Object> map = sponsorService.getSponsorSalesList(info);
		return new ResponseEntity<String>(gson.toJson(map), HttpStatus.OK);
	}
	
	
	
	// 스토어 매출 내역
	@GetMapping("/sales_store")
	public String salesStoreList(Model model, AdSalesStoreInfo info) {

		info.setSqlWhere("");

		Map<String, Object> map = storeService.getStoreSalesList(info);
		model.addAttribute("map", gson.toJson(map));

		model.addAttribute("adminViewName", "common/adSalesStore.jsp");
		return "admin/adIndex";
	}

	@GetMapping(value = "/sales_store/sort", produces = "application/text; charset=utf8")
	public ResponseEntity<String> salesStoreListAjax(Model model, AdSalesStoreInfo info) {
		info.setSqlWhere("");
		Map<String, Object> map = storeService.getStoreSalesList(info);
		return new ResponseEntity<String>(gson.toJson(map), HttpStatus.OK);
	}
	
}
