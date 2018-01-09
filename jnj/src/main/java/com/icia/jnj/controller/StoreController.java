package com.icia.jnj.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.*;
import org.springframework.ui.Model;
import org.springframework.util.SystemPropertyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.support.RequestContextUtils;

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.forwardedUrl;

import java.security.Principal;
import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.icia.jnj.dao.MemberDao;
import com.icia.jnj.domain.BasketProduct;
import com.icia.jnj.domain.ProductList;
import com.icia.jnj.service.MemberService;
import com.icia.jnj.service.StoreService;
import com.icia.jnj.vo.Orders;
import com.icia.jnj.vo.OrdersRecord;
import com.icia.jnj.vo.Review;

import ch.qos.logback.core.net.SyslogOutputStream;

@Controller
@SessionAttributes("basketList")
public class StoreController {
	@Autowired
	private StoreService service;
	@Autowired
	private MemberDao memberDao;
	
	//장바구니로 이동하자, 이동해서 뿌려줘ㅇㅅㅇ!
	//해당 jsp에 $goods_Info = ${goods_Info}; 써줘
	@GetMapping("/menu/store/basket")
	public String basketInfo(Model m,HttpSession session) {

		return"index";
	}
	
	@PostMapping("/menu/store/baskettt")
	public ResponseEntity<Void> goodsSelectListSave(ProductList pBasket, HttpSession session){
		ProductList basket = (ProductList)session.getAttribute("basketList");	//장바구니
		System.out.println("세션장바구니 : "+ basket);
		int isEqual = 0;
		int isEqualQnt = 0;
		int isEqualNo = 0;
		System.out.println("내가 가져온 장바구니 : "+pBasket);
		
		if(basket==null) {
			System.out.println("장바구니가 비었어ㅜㅜ추가시킨당");
			basket=pBasket;
			session.setAttribute("basketList", basket);
			System.out.println("비어있어서 추가했어 : "+basket);
		}else {
			int oBasketSize = basket.getProductList().size();
			int nBasketSize=pBasket.getProductList().size();
			for(int i=0; i<nBasketSize; i++) {
				System.out.println("가져온 장바구니 사이즈 : "+ pBasket.getProductList().size());
				for(int j=0; j<oBasketSize; j++) {
					System.out.println("기존 장바구니 사이즈 : "+ basket.getProductList().size());
					if(pBasket.getProductList().get(i).getGoodsNo().equals(basket.getProductList().get(j).getGoodsNo()) &&
							pBasket.getProductList().get(i).getOptionNo().equals(basket.getProductList().get(j).getOptionNo())) {
						isEqual=1;
						isEqualQnt=basket.getProductList().get(j).getQnt();
						isEqualNo=j;
					}
					
				}
				if( isEqual==1 ) {
					int total = pBasket.getProductList().get(i).getQnt()+ isEqualQnt;
					basket.getProductList().get(isEqualNo).setQnt(total);
				} else {
					basket.getProductList().add(pBasket.getProductList().get(i));
					System.out.println("goodsNo랑 optionNo 가 다를 때 추가 : "+basket);
				}
			}		
		}
		
		System.out.println("비교해서 같은 장바구니면 수량이 올라갔어");
		System.out.println(basket);
		session.setAttribute("basketList", basket);
		return new ResponseEntity<Void>(HttpStatus.OK);
	}
	//장바구니로 이동해서 뿌려줭
	@GetMapping("/menu/store/basketGo")
	public String basketGogo(Model m,HttpSession session) {
		ProductList basketList =(ProductList)session.getAttribute("basketList");
		
		System.out.println("////////////////");
		System.out.println(new Gson().toJson(basketList));
		m.addAttribute("cBasketList",new Gson().toJson(basketList));
		m.addAttribute("viewName","menu/store/storeBasket.jsp");
		System.out.println("cBasketList : "+basketList);
		return"index";
	}
	@PostMapping("/menu/store/delete")
	public ResponseEntity<Void> deleteBasket(HttpSession session, ProductList pBasket){
		//장바구니에서 물건을 삭제했을때
		//선택된 물건을 list로 만들고 해당 goodsNo와 optionNo값 가져와! 만들어진 list는 어차피 삭제될 list얌
		//session에 저장된 list에서 해당되는 goodsNo와 optionNo값이 있는지 찾아
		//해당되는 값을 지워
		//delete에서는 바로 세션에 저장시켜 sbasketList에서 remove시켜주고!
		ProductList basket = (ProductList)session.getAttribute("basketList");	//장바구니
		System.out.println("세션장바구니 : "+ basket);
		int isEqual = 0;
		int isEqualNo = 0;
		System.out.println("내가 삭제할려고 선택한 장바구니 : "+pBasket);
		if(basket==null) {return new ResponseEntity<Void>(HttpStatus.CONFLICT);}
		else {
			/*int oBasketSize = basket.getProductList().size();*/
			int nBasketSize=pBasket.getProductList().size();
			for(int i=0; i<nBasketSize; i++) {
				System.out.println("선택할려고 가져온 장바구니 사이즈 : "+ pBasket.getProductList().size());
				System.out.println("i는 : "+i);
				for(int j=0; j<basket.getProductList().size(); j++) {
					System.out.println("기존 세션 장바구니 사이즈 : "+ basket.getProductList().size());
					System.out.println("j는 : "+j);
					if(pBasket.getProductList().get(i).getGoodsNo().equals(basket.getProductList().get(j).getGoodsNo()) &&
							pBasket.getProductList().get(i).getOptionNo().equals(basket.getProductList().get(j).getOptionNo())) {
						isEqual=1;
						isEqualNo=j;
						System.out.println("i : j ???   "+i+j);
						/*isEqual=1;
						isEqualNo=j;
						if( isEqual==1 ) {
							basket.getProductList().remove(isEqualNo);
						} */
					}
					
				}
				System.out.println("isEqual : "+isEqual);
				if( isEqual==1 ) {
					basket.getProductList().remove(isEqualNo);
					System.out.println("삭제됐니?"+basket);
					
				} 
			}		
		}
		System.out.println("삭제해서 세션에 남은 장바구니 : "+basket);
		session.setAttribute("basketList", basket);
		return new ResponseEntity<Void>(HttpStatus.OK);
	}
	//결제페이지로 이동해서 뿌려줘야행
	@PostMapping("/menu/store/payGoGo")
	   public String BasketPay (HttpSession session, ProductList pBasket) {
	      //장바구니에서 물건 전체 결제 했을때
	      //선택된 물건을 list로 만들고 해당 goodsNo랑 optionNo를 가져와
	      //session에 저장된 list에서 해당되는 goodsNo랑 oprionNo가 있는 지 찾아서 
	      //해당값이 있으면 그걸 따로 세션에 저장시켜
	      ProductList basket = (ProductList)session.getAttribute("basketList");
	      System.out.println("현재 세션에 있는 값 : "+basket);
	      System.out.println("내가 선택한 값 : "+pBasket);
	      ProductList  payList = null;
	      int isEqual = 0;
	      int isEqualNo =0;
	      /*if(basket==null) {}*/
	         for(int i =0; i<pBasket.getProductList().size();i++) {
	        	 System.out.println("i의 값은 ? : "+i);
	            for(int j = 0; j<basket.getProductList().size();j++) {
	            	System.out.println("j의 값은 ? : "+j);
	            	if(pBasket.getProductList().get(i).getGoodsNo().equals(basket.getProductList().get(j).getGoodsNo())
	                     && pBasket.getProductList().get(i).getOptionNo().equals(basket.getProductList().get(j).getOptionNo())) {
	            		System.out.println("p의 i번째 goodsNo : "+pBasket.getProductList().get(i).getGoodsNo());
	            		System.out.println("p의 i번째 optionNo : "+pBasket.getProductList().get(i).getOptionNo());
	            		System.out.println("b의 i번째 goodsNo : "+basket.getProductList().get(i).getGoodsNo());
	            		System.out.println("b의 i번째 optionNo : "+basket.getProductList().get(i).getOptionNo());
	            		isEqual = 1;
	            		isEqualNo = j;
	               }
	            }
	            if(isEqual==1) {
	               payList=pBasket;
	               System.out.println("pBasket : "+pBasket);
	               System.out.println("payList : "+payList);
	            }
	         }
	      session.setAttribute("basketList", payList);
	      return "index";
	   }
	@GetMapping("/menu/store/payGoGo")
	public String payGogo (Model m, HttpSession session, ProductList pBasket) {
		ProductList basketList = (ProductList) session.getAttribute("basketList");
		System.out.println("pBasket은 내가 선택결제하고 싶은 상품 : "+pBasket);
	
		m.addAttribute("cBasketList",new Gson().toJson(basketList));
		m.addAttribute("viewName","menu/store/storeBasketPay.jsp");
		return "index";
	}
	//세션 지워
	/*@PostMapping("/menu/store/delete/session")
	public ResponseEntity<String> clearSession(HttpSession session) {
		session.getAttribute("basketList");
		System.out.println("session에서 get한거?! : "+session);
		session.removeAttribute("basketList");
		return new ResponseEntity<String>(HttpStatus.OK);
	}*/
	@GetMapping(value="/menu/store/miniBasket", produces="application/text; charset=utf8")
	public ResponseEntity<String> mini (Model m, HttpSession session) {
		ProductList basketList = (ProductList)session.getAttribute("basketList");
		System.out.println("왜안됨?"+basketList);
		return new ResponseEntity<String>(new Gson().toJson(basketList),HttpStatus.OK);
	}
	
	
	
	
	
	
	/*-----------------------------------------------------------------------------------*/
	
	
	
	
	
	
	
	// 수현
	// 전체 카테고리 - 스토어리스트 12개 (스토어리스트)
	@GetMapping("/menu/store/record")
	public String getStoreListAll(@RequestParam(defaultValue="1") int pageNo, Model model, @RequestParam(defaultValue="goodsNo") String colName, @RequestParam(defaultValue="desc") String sortType, String categoryName,HttpSession session) {
		model.addAttribute("viewName", "menu/store/storeAllList.jsp");
		model.addAttribute("interestList", new Gson().toJson(service.getInterestList()));
		
		ProductList basketList = (ProductList) session.getAttribute("basketList");
		model.addAttribute("cBasketList",new Gson().toJson(basketList));
		
		if(categoryName==null) {
			model.addAttribute("categoryName", new Gson().toJson("전체"));
			model.addAttribute("storeList", new Gson().toJson(service.getStoreListAll(colName, sortType, pageNo)));
		} else {
			model.addAttribute("categoryName", new Gson().toJson(categoryName));
			model.addAttribute("storeList", new Gson().toJson(service.getStoreListCate(colName, sortType, categoryName, pageNo)));
		}
		return "index";
	}
	// 검색 (스토어리스트)
	@GetMapping("/menu/store/search")
	public String getStoreSearch( @RequestParam(defaultValue="1") int pageNo, HttpServletRequest req,String keyword, Model model, @RequestParam(defaultValue="goodsNo") String colName, @RequestParam(defaultValue="desc") String sortType, HttpSession session) {		
		ProductList basketList = (ProductList) session.getAttribute("basketList");
		model.addAttribute("cBasketList",new Gson().toJson(basketList));
		
		model.addAttribute("categoryName", new Gson().toJson("전체"));
		model.addAttribute("viewName", "menu/store/storeAllList.jsp");
		model.addAttribute("interestList", new Gson().toJson(service.getInterestList()));
		model.addAttribute("storeList", new Gson().toJson(service.getStoreSearch(keyword, colName, sortType, pageNo)));
		return "index";
	}
	

	
	
	// 스토어뷰	
	@GetMapping("/menu/store/view")	
	public String getView(int goodsNo, Model model, Principal principal, HttpSession session) {
		if(principal==null) {
			model.addAttribute("viewName", "general/login.jsp");
		} else {
			model.addAttribute("mstate", new Gson().toJson(memberDao.getMemberState(principal.getName())));
			model.addAttribute("viewName", "menu/store/storeView.jsp");
			model.addAttribute("sView", new Gson().toJson(service.getView(goodsNo)));
			model.addAttribute("sComment", new Gson().toJson(service.getStoreReview(goodsNo)));
			model.addAttribute("memberId", new Gson().toJson(principal.getName()));
			
			ProductList basketList = (ProductList) session.getAttribute("basketList");
			model.addAttribute("cBasketList",new Gson().toJson(basketList));
		}
		return "index";
	}
	
	
	// 구매정보 입력 페이지
	@PostMapping("/menu/store/pay")
	public String payView(RedirectAttributes ra, @RequestParam List<Integer> orderQnt, @RequestParam List<Integer> goodsNo, @RequestParam List<Integer> optionNo) {
		
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		for(int i=0; i<optionNo.size(); i++) {
			System.out.println(goodsNo.get(i));
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("goodsImg", service.getGoodsImgForPay(goodsNo.get(i)));
			map.put("goods", service.getGoodsForPay(goodsNo.get(i))); // goodsNo.get(i) // 굿즈번호, 굿즈이름, 굿즈가격
			map.put("goodsOption", service.getGoodsOptionForPay(goodsNo.get(i), optionNo.get(i))); // goodsOption.get(i), goodsNo.get(i) // 옵션번호, 옵션내용
			map.put("orderQnt", orderQnt.get(i));
			list.add(map);
		}
			
		ra.addFlashAttribute("map", new Gson().toJson(list));
		return "redirect:/menu/store/pay/view";
	}
		
	@GetMapping("/menu/store/pay/view")
	public String payView(Model model) {
		model.addAttribute("viewName", "menu/store/storePay.jsp");
		return "index";
	}
	
	// 구매하기
	@PostMapping("/menu/store/order")
	public String order(SessionStatus session,Principal principal, @RequestParam List<Integer> orderRecordState, @RequestParam List<Integer> orderQnt, @RequestParam List<Integer> money, @RequestParam List<Integer> goodsNo, @RequestParam List<Integer> optionNo, Orders orders, RedirectAttributes ra) {
	   orders.setOrderId(principal.getName());
	   List<OrdersRecord> list = new ArrayList<OrdersRecord>();
	   for(int i=0; i<orderQnt.size(); i++) {
	      OrdersRecord or = new OrdersRecord(); 
	      or.setGoodsNo(goodsNo.get(i));
	      or.setMoney(money.get(i));
	      or.setOptionNo(optionNo.get(i));
	      or.setOrderQnt(orderQnt.get(i));
	      or.setOrderRecordState(orderRecordState.get(i));
	      list.add(or);
	   }
	   service.payGoods(orders, list);
	   System.out.println(orders.getOrderNo());
	   ra.addFlashAttribute("orderNo", orders.getOrderNo());
	   
	   session.setComplete();
	   
	   return "redirect:/menu/store/order/success";
	  }
	   
	// 구매성공
	@GetMapping("/menu/store/order/success")
	public String orderSuccess(Model model, HttpServletRequest req, Principal principal) {
	   Map<String, ?> rmap = RequestContextUtils.getInputFlashMap(req);
	   int orderNo = (Integer)rmap.get("orderNo");
	   model.addAttribute("viewName", "menu/store/storePaySuccess.jsp");
	   model.addAttribute("map", new Gson().toJson(service.getOrderViewGoods(orderNo)));
	   model.addAttribute("memberId", new Gson().toJson(principal.getName()));
	   return "index";
	}
}
