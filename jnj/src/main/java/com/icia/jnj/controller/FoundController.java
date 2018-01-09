package com.icia.jnj.controller;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.security.Principal;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.icia.jnj.service.FoundService;
import com.icia.jnj.vo.Find;

@Controller
public class FoundController {

	
	/*@Autowired
	private FoundService service;
	
	@Autowired
	private Gson gson;
	
	// Menu찾았어요 -> 찾았어요 화면 이동
		@GetMapping("/menu/board_found/list")
		public String main(@RequestParam(defaultValue="1") int pageno, Model model) {
			model.addAttribute("map", gson.toJson(service.listBoard(pageno)));
			model.addAttribute("viewName", "menu/board/found/foundBoardList.jsp");
			return "index";
		}
	
	// 버튼 글쓰기 -> 글쓰기 화면 이동
	@PreAuthorize("isAuthenticated()")
	@GetMapping("/menu/board_found/write")
	public String boardFindWritePage(Model model) {
		model.addAttribute("viewName", "menu/board/found/foundBoardWrite.jsp");
		return "index";
	}

	// 버튼 수정 -> 글수정 화면 이동
	@PreAuthorize("isAuthenticated()")
	@GetMapping("/menu/board_found/update")
	public String boardFindUpdatePage(Model model, int findNo) {
		model.addAttribute("find", gson.toJson(service.getFind(findNo)));
		model.addAttribute("viewName", "menu/board/found/foundBoardUpdate.jsp");
		return "index";
	}
	
	// 찾았어요 상세보기 이동 -> 찾았어요 글보기(상세보기)
		@PreAuthorize("isAuthenticated()")
		@GetMapping("/menu/board_found/view")
		public String boardFindViewPage(Model model, int findNo, Principal principal,
				@CookieValue(value="currView1", required = false) String currView1, HttpServletResponse response,
				@RequestParam(defaultValue="false")boolean check) {
			
			model.addAttribute("name",gson.toJson(principal.getName()));
			model.addAttribute("map",gson.toJson(service.boardFindViewPage( findNo)));
			model.addAttribute("viewName", "menu/board/found/foundBoardView.jsp");
			
			if( check == false )
			{
				List<Integer> currList;
				if(currView1==null)
					currList = new ArrayList<Integer>();
				else
					currList = new Gson().fromJson(currView1, new TypeToken<List<Integer>>(){}.getType());
				
				// 글번호를 포함하고 있다면
				if( currList.contains(findNo) ) {
					
					// 포함된 글번호의 인덱스를 구한다
					int idx = 0;
					for( int i=0; i<currList.size(); i++ ) {
						if( currList.contains(findNo) && currList.get(i) == findNo  )
							idx = i;
					}
					
					// 해당 인덱스를 삭제하고 제일 뒤에(최신) 새로 추가한다
					currList.remove(idx);
					currList.add(findNo);
				}
				// 글번호를 포함하고 있지 않다면
				else {
					// 만약 리스트가 5개의 글번호를 담고있다면
					if( currList.size() > 4) {
						// 제일 나중에 본 글을 삭제 시키고( 첫번째 인덱스 )
						// 최근 본 글번호를 추가( 마지막 인덱스 )
						currList.remove(0);
						currList.add(findNo);
					}
					else
						currList.add(findNo);
				}
				
				// Json으로 변환한 다음 recommend란 이름의 쿠키를 생성. 이미 존재하는 경우에는 덮어쓴다
				Cookie currView1Cookie = new Cookie("currView1", new Gson().toJson(currList));
				// 쿠키의 경로 설정. 나중에 지울때 필요함 - 하지만 지울 예정 없음
				currView1Cookie.setPath("/");
				// 쿠키의 수명 설정 60초*60분*24시간*30일로 한달 설정
				currView1Cookie.setMaxAge(60 * 60 * 24 * 30);
				// 스프링에서 쿠키를 저장하려면 response 객체 필요
				response.addCookie(currView1Cookie);
				
				System.err.println("33 : " + currList);
			}
			
			return "index";
	}
	
	// 글쓰기
	@PostMapping("/menu/board_found/write")
	public String boardFindWrite( Principal principal , Find find, MultipartFile file) throws IOException {
		service.boardFindWrite( principal,find, file);
		return "redirect:/menu/board_found/list";
	}
	
	// 글수정
		@PostMapping("/menu/board_found/update")
		public String boardFindUpdate(  String addr2, String addr3,Principal principal, Find find, @RequestParam(required = false)MultipartFile file) throws IOException {
			service.boardFindUpdate(principal,find, file);
			return "redirect:/menu/board_found/list";
		}	
		
	// 리스트에서 필터
	@GetMapping("/menu/board_found/view_filter")
	public String getFindList(@RequestParam(defaultValue="1") int pageno, @CookieValue(value = "findNo", required = false) Integer findNo, @RequestParam(defaultValue="0") int petSort, @RequestParam(defaultValue="전체")String firstAddr, Model model) {
		model.addAttribute("map", gson.toJson(service.getFindList(pageno, petSort, firstAddr)));
		model.addAttribute("viewName", "menu/board/found/foundBoardList.jsp");	
		return "index";
	}
	
	// 신고하기 및 쿠키를 이용한 중복신고방지
	@PostMapping("/menu/board_found/report")
	// 사용자에게서 report란 쿠키를 얻어온다. 이 쿠키에는 사용자가 추천한 글의 번호들이 담겨있다
	public ResponseEntity<Integer> report(@CookieValue(value = "report", required = false) String report, int findNo,
			int findDivision, HttpServletResponse response) throws UnsupportedEncodingException {
		System.out.println("서버 반응");

		List<Integer> recList;
		int reportCnt = 0;

		// 쿠키가 없을 경우 리스트를 생성
		if (report == null)
			recList = new ArrayList<Integer>();
		else
			// 쿠키가 있을 경우 아래와 같은 방식으로 List로 변환
			recList = new Gson().fromJson(report, new TypeToken<List<Integer>>() {
			}.getType());
		System.out.println(recList);
		System.out.println("테스트2:" + recList.contains(findNo));


		if (recList.contains(findNo) == false) {
			// recList에 지금 추천하려는 글의 번호가 들어있지 않은 경우 신고
			reportCnt = service.report(findDivision, findNo);
			System.out.println("cnt" + reportCnt);
			// recList에 추천한 글번호를 추가
			recList.add(findNo);
			// Json으로 변환한 다음 report란 이름의 쿠키를 생성. 이미 존재하는 경우에는 덮어쓴다
			Cookie reportCookie = new Cookie("report", URLEncoder.encode(new Gson().toJson(recList),"utf-8"));
			// 쿠키의 경로 설정. 나중에 지울때 필요함 - 하지만 지울 예정 없음
			reportCookie.setPath("/");
			// 쿠키의 수명 설정 60초*60분*24시간*30일로 한달 설정
			reportCookie.setMaxAge(60 * 60 * 24 * 30);
			// 스프링에서 쿠키를 저장하려면 response 객체 필요
			response.addCookie(reportCookie);
		}
		return new ResponseEntity<Integer>(reportCnt, HttpStatus.OK);
	}*/
}
	
