package com.icia.jnj.controller;

import java.io.*;
import java.net.*;
import java.security.*;
import java.util.*;

import javax.servlet.http.*;

import org.springframework.beans.factory.annotation.*;
import org.springframework.http.*;
import org.springframework.security.access.prepost.*;
import org.springframework.stereotype.*;
import org.springframework.ui.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.*;
import org.springframework.web.servlet.mvc.support.*;

import com.google.gson.*;
import com.google.gson.reflect.*;
import com.icia.jnj.dao.*;
import com.icia.jnj.service.*;
import com.icia.jnj.vo.*;

@Controller
public class BoardController {

	@Autowired
	private BoardService service;
	
	@Autowired
	private BoardDao dao;
	
	@Autowired
	private Gson gson;
	
	
	// Menu찾아요 -> 찾아요 화면 이동
	@GetMapping(value="/menu/board_find/list", produces="application/text; charset=utf8")
	public String main(@RequestParam(defaultValue="1") int pageno, Model model) {
		model.addAttribute("map", gson.toJson(service.listBoard(pageno)));
		model.addAttribute("viewName", "menu/board/find/findBoardList.jsp");
		return "index";
	}
	

	// 버튼 글쓰기 -> 글쓰기 화면 이동
	@PreAuthorize("isAuthenticated()")
	@GetMapping("/menu/board_find/write")
	public String boardFindWritePage(Model model) {
		model.addAttribute("viewName", "menu/board/find/findBoardWrite.jsp");
		return "index";
	}

	// 버튼 수정 -> 글수정 화면 이동
	@PreAuthorize("isAuthenticated()")
	@GetMapping("/menu/board_find/update")
	public String boardFindUpdatePage(Model model, int findNo) {
		model.addAttribute("find", gson.toJson(service.getFind(findNo)));
		model.addAttribute("viewName", "menu/board/find/findBoardUpdate.jsp");
		return "index";
	}

	// 찾아요 상세보기 이동 -> 찾아요 글보기(상세보기)
	@PreAuthorize("isAuthenticated()")
	@GetMapping("/menu/board_find/view")
	public String boardFindViewPage(Model model, int findNo, Principal principal,
			@CookieValue(value="currView10", required = false) String currView10, HttpServletResponse response,
			@RequestParam(defaultValue="false")boolean check) {
		
		model.addAttribute("name",gson.toJson(principal.getName()));
		model.addAttribute("map",gson.toJson(service.boardFindViewPage( findNo)));
		model.addAttribute("viewName", "menu/board/find/findBoardView.jsp");
		
		if( check == false && !principal.getName().equals("admin") )
		{
			List<Integer> currList;
			if(currView10==null)
				currList = new ArrayList<Integer>();
			else
				currList = new Gson().fromJson(currView10, new TypeToken<List<Integer>>(){}.getType());
			
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
			Cookie currView10Cookie = new Cookie("currView10", new Gson().toJson(currList));
			// 쿠키의 경로 설정. 나중에 지울때 필요함 - 하지만 지울 예정 없음
			currView10Cookie.setPath("/");
			// 쿠키의 수명 설정 60초*60분*24시간*30일로 한달 설정
			currView10Cookie.setMaxAge(60 * 60 * 24 * 30);
			// 스프링에서 쿠키를 저장하려면 response 객체 필요
			response.addCookie(currView10Cookie);
			
			System.err.println("11 : " + currList);
		}
		
		return "index";
	}
	
	
	
	// 글쓰기
	@PostMapping("/menu/board_find/write")
	public String boardFindWrite(  Principal principal , Find find, MultipartFile file) throws IOException {
		System.err.println(find.getFindAddr());
		service.boardFindWrite (principal,find, file);
		return "redirect:/menu/board_find/list";
	}

	// 글수정
	@PostMapping("/menu/board_find/update")
	public String boardFindUpdate( Principal principal, Find find, @RequestParam(required = false)MultipartFile file) throws IOException {
		service.boardFindUpdate(principal,find, file);
		return "redirect:/menu/board_find/list";
	}

	// 글삭제 
	@PostMapping("/menu/board_find/delete")
	public String boardFindDelete( Principal principal , Model model, int findNo) {
		service.boardFindDelete(findNo);
		return "redirect:/menu/board_find/list";
	}
		
	// 댓글 추가
	@PreAuthorize("isAuthenticated()") 
	@PostMapping("/menu/board_find/comment_write")
	public ResponseEntity<List<FindComment>> insertBoard(Principal principal, FindComment findComment) {
		System.out.println(findComment.getCommentContent());
		System.out.println(findComment.getFindNo());
		System.out.println("==============================controller 실행된다아=======");
		List<FindComment> f = service.insertFindComment(principal, findComment);
		
		if (f!=null) {
			return new ResponseEntity<List<FindComment>>(f, HttpStatus.OK);
		}
		return new ResponseEntity<List<FindComment>>(HttpStatus.NOT_FOUND);
	}
	
	// 댓글 삭제
	@PreAuthorize("isAuthenticated()") 
		@PostMapping("/menu/board_find/comment_delete")
		public ResponseEntity<List<FindComment>> deleteFindComment(FindComment findComment) {
			System.err.println(findComment+"controller");
			boolean result = service.deleteFindComment(findComment);
			return new ResponseEntity<List<FindComment>>(HttpStatus.NOT_FOUND);
		}
		
	// 댓글 수정 
	@PreAuthorize("isAuthenticated()") 
	@PostMapping("/menu/board_find/comment_update")
	public ResponseEntity<Void> updateFindComment(FindComment findComment,HttpServletRequest req, RedirectAttributes ra) {
		service.updateFindComment(findComment);
		return new ResponseEntity<Void>(HttpStatus.NOT_FOUND);
	}
	
	
	// 리스트에서 필터
	@GetMapping("/menu/board_find/view_filter")
	public String getFindList(@RequestParam(defaultValue="1") int pageno, @CookieValue(value = "findNo", required = false) Integer findNo, @RequestParam(defaultValue="0") int petSort, @RequestParam(defaultValue="전체")String firstAddr, Model model) {
		model.addAttribute("map", gson.toJson(service.getFindList(pageno, petSort, firstAddr)));
		model.addAttribute("viewName", "menu/board/find/findBoardList.jsp");
		return "index";
	}
	
	// 신고하기 및 쿠키를 이용한 중복신고방지
	@PostMapping("/menu/board_find/report")
	// 사용자에게서 report란 쿠키를 얻어온다. 이 쿠키에는 사용자가 추천한 글의 번호들이 담겨있다
	public ResponseEntity<Integer> report(@CookieValue(value = "report", required = false) String report, int findNo,
			int findDivision, HttpServletResponse response, int findState) throws UnsupportedEncodingException {
		System.out.println("서버 반응");
		System.err.println(findState);
		
		List<Integer> recList;
		int reportCnt = 0;

		// 쿠키가 없을 경우 리스트를 생성
		if (report == null)
			recList = new ArrayList<Integer>();
		else
			// 쿠키가 있을 경우 아래와 같은 방식으로 List로 변환
			recList = new Gson().fromJson(report, new TypeToken<List<Integer>>(){}.getType());
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
		if(reportCnt==3) {
			service.updateFindState(findState, findDivision, findNo);
		}
		return new ResponseEntity<Integer>(reportCnt, HttpStatus.OK);
	}
	
	// 최근 본 게시물 그리기
	@GetMapping(value="/menu/board/current", produces="application/text; charset=utf8")
	public ResponseEntity<String> currentClickView(
			@CookieValue(value="currView10", required = false) String currView10) {
		
		List<Integer> currList = null;
		List<Find> findList = new ArrayList<Find>();
		
		if(currView10!=null) {
			currList = new Gson().fromJson(currView10, new TypeToken<List<Integer>>(){}.getType());
			for( int i=0; i<currList.size(); i++ ) {
				int divisionNum = dao.getDivisionByFindNo(currList.get(i));
				findList.add( (divisionNum==2)?dao.boardFindViewPage(divisionNum, currList.get(i)): dao.getFind(currList.get(i)) );
				System.err.println("22-2 : " + findList.get(i).getFindNo());
			}
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put( "findList", findList );
		map.put( "divisionNum", findList );
		
		return new ResponseEntity<String>( (currView10==null)?"":gson.toJson(findList), HttpStatus.OK);
	}

	
//==================================================================================================================
//==================================================================================================================
//==================================================================================================================
//==================================================================================================================
//==================================================================================================================


	
	@Autowired
	private FoundService fService;
	
	// Menu찾았어요 -> 찾았어요 화면 이동
		@GetMapping("/menu/board_found/list")
		public String mainfound(@RequestParam(defaultValue="1") int pageno, Model model) {
			model.addAttribute("map", gson.toJson(fService.listBoard(pageno)));
			model.addAttribute("viewName", "menu/board/found/foundBoardList.jsp");
			return "index";
		}
	
	// 버튼 글쓰기 -> 글쓰기 화면 이동
	@PreAuthorize("isAuthenticated()")
	@GetMapping("/menu/board_found/write")
	public String boardfoundWritePage(Model model) {
		model.addAttribute("viewName", "menu/board/found/foundBoardWrite.jsp");
		return "index";
	}

	// 버튼 수정 -> 글수정 화면 이동
	@PreAuthorize("isAuthenticated()")
	@GetMapping("/menu/board_found/update")
	public String boardfoundUpdatePage(Model model, int findNo) {
		model.addAttribute("find", gson.toJson(fService.getFind(findNo)));
		model.addAttribute("viewName", "menu/board/found/foundBoardUpdate.jsp");
		return "index";
	}
	
	// 찾았어요 상세보기 이동 -> 찾았어요 글보기(상세보기)
		@PreAuthorize("isAuthenticated()")
		@GetMapping("/menu/board_found/view")
		public String boardfoundViewPage(Model model, int findNo, Principal principal,
				@CookieValue(value="currView10", required = false) String currView10, HttpServletResponse response,
				@RequestParam(defaultValue="false")boolean check) {
			
			model.addAttribute("name",gson.toJson(principal.getName()));
			model.addAttribute("map",gson.toJson(fService.boardFindViewPage( findNo)));
			model.addAttribute("viewName", "menu/board/found/foundBoardView.jsp");
			
			if( check == false && !principal.getName().equals(("admin"))  )
			{
				List<Integer> currList;
				if(currView10==null)
					currList = new ArrayList<Integer>();
				else
					currList = new Gson().fromJson(currView10, new TypeToken<List<Integer>>(){}.getType());
				
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
				Cookie currView10Cookie = new Cookie("currView10", new Gson().toJson(currList));
				// 쿠키의 경로 설정. 나중에 지울때 필요함 - 하지만 지울 예정 없음
				currView10Cookie.setPath("/");
				// 쿠키의 수명 설정 60초*60분*24시간*30일로 한달 설정
				currView10Cookie.setMaxAge(60 * 60 * 24 * 30);
				// 스프링에서 쿠키를 저장하려면 response 객체 필요
				response.addCookie(currView10Cookie);
				
				System.err.println("33 : " + currList);
			}
			return "index";
	}
	
	// 글쓰기
	@PostMapping("/menu/board_found/write")
	public String boardfoundWrite( Principal principal , Find found, MultipartFile file) throws IOException {
		fService.boardFindWrite( principal,found, file);
		return "redirect:/menu/board_found/list";
	}
	
	// 글수정
		@PostMapping("/menu/board_found/update")
		public String boardfoundUpdate(  Principal principal, Find find, @RequestParam(required = false)MultipartFile file) throws IOException {
			fService.boardFindUpdate(principal,find, file);
			return "redirect:/menu/board_found/list";
		}	
		
		
	// 리스트에서 필터
	@GetMapping("/menu/board_found/view_filter")
	public String getfoundList(@RequestParam(defaultValue="1") int pageno, @CookieValue(value = "findNo", required = false) Integer findNo, @RequestParam(defaultValue="0") int petSort, @RequestParam(defaultValue="전체")String firstAddr, Model model) {
		model.addAttribute("map", gson.toJson(fService.getFindList(pageno, petSort, firstAddr)));
		model.addAttribute("viewName", "menu/board/found/foundBoardList.jsp");	
		return "index";
	}
	
	
	
	@PostMapping("/menu/board_found/report")
	// 사용자에게서 report란 쿠키를 얻어온다. 이 쿠키에는 사용자가 추천한 글의 번호들이 담겨있다
	public ResponseEntity<Integer> report(@CookieValue(value = "report", required = false) String report, int findNo,
			int foundDivision, HttpServletResponse response) throws UnsupportedEncodingException {
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
			reportCnt = fService.report(foundDivision, findNo);
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
	}
	
	
	
	
	

	// 최근 본 게시물 클릭 시 상세 뷰 가기
	@GetMapping("/menu/board/currclick")
	public String currentClickViewGo(int findNo) {
		int divi = dao.getDivisionByFindNo(findNo);
		if (divi == 1) // 찾아요게시판
			return "redirect:/menu/board_find/view?findNo=" + findNo + "&check=true";
		else // 찾았어요 게시판
			return "redirect:/menu/board_found/view?findNo=" + findNo + "&check=true";
	}
}
