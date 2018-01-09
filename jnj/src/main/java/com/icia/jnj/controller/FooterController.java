package com.icia.jnj.controller;

import java.security.Principal;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.gson.Gson;
import com.icia.jnj.domain.Guestbook;
import com.icia.jnj.service.FooterService;
import com.icia.jnj.vo.Notice;

@Controller
@RequestMapping("/menu")
public class FooterController {
	@Autowired
	private FooterService service;
	@Autowired
	private Gson gson;
	
	
	// 센터 리스트 이동
	@GetMapping("/board_center/record")
	public String getBoardCenterList(@RequestParam(defaultValue="1") int pageno,@RequestParam(defaultValue="전체")String keyword, Model model) {
		model.addAttribute("map", gson.toJson(service.getBoardCenterList(keyword, pageno)));
		model.addAttribute("keyword", gson.toJson(keyword));
		model.addAttribute("viewName", "menu/board/footer/centerList.jsp");
		return "index";
	}
	
	
	// 센터 뷰 이동
	@GetMapping("/board_center/view")
	public String getBoardCenterView(String centerId, Model model) {
		model.addAttribute("map", gson.toJson(service.getBoardCenterView(centerId)));
		model.addAttribute("viewName", "menu/board/footer/centerInfo.jsp");
		return "index";
	}
	
	
	
	//////////////////////////////////////////////////////////////////////////// 공지 사항
	// 공지사항 조회
	@GetMapping("/board_notice/record")
	public String board_noticeList(@RequestParam(defaultValue="1") int pageno, Model model,Principal principal) {
		System.out.println(principal==null);
		if(principal==null) {
			model.addAttribute("viewName", "general/login.jsp");
		} else {
			model.addAttribute("viewName", "menu/board/notice/noticeList.jsp");
			model.addAttribute("map", gson.toJson(service.listBoardNotice(pageno)));
			model.addAttribute("name", gson.toJson(principal.getName()));
		}
				
			
			
		
			
		return "index";
	}
		
		
		//1. 글쓰기페이지로 이동 -> 글쓰기화면  
		@GetMapping("/board_notice/write")
		public String boardNoticeWrite(Model model, Principal principal) {
			model.addAttribute("name", gson.toJson(principal.getName()));
			model.addAttribute("viewName", "menu/board/notice/noticeWrite.jsp");
			return "index";
		}
		
		// 2. 글쓰기
		@PostMapping("/board_notice/write")
		public String boardNotice(Notice notice)  {
			service.insertBoardNotice(notice);
			return "redirect:/menu/board_notice/record";
		}
		
		// 3. 공지사항 글보기 화면 
		@GetMapping("/board_notice/view")
		public String boardNoticeView(int noticeNo, Model model,Principal principal) {
			model.addAttribute("map",gson.toJson(service.viewBoardNotice(noticeNo)));
			model.addAttribute("name", gson.toJson(principal.getName()));
			model.addAttribute("viewName", "menu/board/notice/noticeView.jsp");
			return "index";
		}
		
		// 4. 공지사항 정보 수정
		@GetMapping("/board_notice/update")
		public String boardNoticeUpdate(Model model,int noticeNo, RedirectAttributes ra) {
			model.addAttribute("notice", gson.toJson(service.getBoardNotice(noticeNo)));
			model.addAttribute("viewName","menu/board/notice/noticeUpdate.jsp");
			return "index";
		}
		
		@PostMapping("/board_notice/update")
		public String boardNoticeUpdate(Notice notice,HttpServletRequest req, RedirectAttributes ra) {
			service.updateBoardNotice(notice);
			return "redirect:/menu/board_notice/view?noticeNo="+notice.getNoticeNo();
		}
		
		// 공지사항 삭제
		@PostMapping("/board_notice/delete")
		public String boardNoticeDelete(Notice notice, RedirectAttributes ra) {
			System.out.println("넘어오나??");
			service.deleteBoardNotice(notice);
			return "redirect:/menu/board_notice/record";
		}
		
		/*//혜미혜미혜미 방명록
		@GetMapping(value="/guest/view", produces="application/text; charset=utf8")
		public ResponseEntity<String> getGuestbookList(@RequestParam(defaultValue="1") int pageno,Model m){
			m.addAttribute("viewName", "menu/board/notice/noticeList.jsp");
			m.addAttribute("map", gson.toJson(service.getGuestbookList(pageno)));
			System.out.println("map : "+gson.toJson(service.getGuestbookList(pageno)));
			return new ResponseEntity<String>(HttpStatus.OK);
		}
		@PostMapping("/guest/write")
		public ResponseEntity<String> insertGuestbook(Guestbook guestbook)  {
			service.insertGuestbook(guestbook);
			return new ResponseEntity<String>(HttpStatus.OK);
		}
		@PostMapping("/guest/update")
		public ResponseEntity<String> updateGuestbook(Guestbook guestbook)  {
			service.updateGuestbook(guestbook);
			return new ResponseEntity<String>(HttpStatus.OK);
		}
		@PostMapping("/guest/delete")
		public ResponseEntity<String> deleteGuestbook(int guestbookNo)  {
			service.deleteGuestbook(guestbookNo);
			return new ResponseEntity<String>(HttpStatus.OK);
		}*/
	
}
