package com.icia.jnj.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.security.Principal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.*;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.icia.jnj.domain.AdMVolunteerInfo;
import com.icia.jnj.service.VolunteerService;
import com.icia.jnj.vo.Volunteer;
import com.icia.jnj.vo.VolunteerApply;
import com.icia.jnj.vo.VolunteerComment;

@Controller
@RequestMapping("/menu")
public class VolunteerController {
	@Autowired
	private Gson gson;
	@Autowired
	private VolunteerService service;
	
	
	// 봉사 리스트
	@GetMapping(value="/volunteer/record", produces="application/text; charset=utf8")
	public String volunteerList(@RequestParam(defaultValue="1") int pageno, @RequestParam(defaultValue="전체")String search, @RequestParam(defaultValue="desc")String sortType, @RequestParam(defaultValue="volunteerNo")String colName, Model model) {
		Map<String, Object> map = service.getVolunteerSearch(pageno, search, colName, sortType);
		map.put("colName", colName);
		map.put("sortType", sortType);
		model.addAttribute("map",gson.toJson(map));
		model.addAttribute("viewName","menu/volunteer/volunteerList.jsp");
		return "index";
	}
	
	// 리스트에서 필터
//	@GetMapping(value="/volunteer/search", produces="application/text; charset=utf8")
//	public ResponseEntity<String> getVolunteerSearch(@RequestParam(defaultValue="1") int pageno, @RequestParam(defaultValue="전체")String search, @RequestParam(defaultValue="desc")String sortType, @RequestParam(defaultValue="volunteerNo")String colName, Model model) {
//		System.out.println("왔는강??");
//		Map<String, Object> map = service.getVolunteerSearch(pageno, search, colName, sortType);
//		map.put("colName", colName);
//		map.put("sortType", sortType);
//	 	model.addAttribute("map",gson.toJson(map));
//		model.addAttribute("viewName", "menu/volunteer/volunteerList.jsp");
//	 	return new ResponseEntity<String>(gson.toJson(map),HttpStatus.OK);
//	}

	/*// 봉사 필터
	@GetMapping(value="/volunteer/record/sort", produces="application/text; charset=utf8")
	public ResponseEntity<String> volunteerList(@RequestParam(defaultValue="1")int pageno, Model model,@RequestParam(defaultValue="volunteerNo")String colName, @RequestParam(defaultValue="desc")String sortType, String memberId) {
		Map<String, Object> map = service.listVolunteer(pageno, colName, sortType);
	 	map.put("colName", colName);
	 	map.put("sortType", sortType);
	 	model.addAttribute("map",gson.toJson(map));
		model.addAttribute("viewName","menu/volunteer/volunteerList.jsp");
	 	return new ResponseEntity<String>(gson.toJson(map),HttpStatus.OK);
	 }*/
	
	
	
	// 봉사 글 쓰기
	@GetMapping("/volunteer/write")
	public String volunteerWrite(Model model,Principal principal) {
		if(principal==null) {
			model.addAttribute("viewName", "general/login.jsp");
		} else {
		model.addAttribute("viewName","menu/volunteer/volunteerWrite.jsp");
		}
		return "index";
	}
	@PostMapping("/volunteer/write")
	public String volunteer(Volunteer volunteer, Principal principal) {
		
		volunteer.setHostId(principal.getName());
		System.out.println(volunteer);
		service.insertVolunteer(volunteer);
		return "redirect:/menu/volunteer/record";
	}
	
	
	// 봉사 글 보기 화면
	@GetMapping("/volunteer/view")
	public String volunteerView(int volunteerNo, Model model, Principal principal) {
		if(principal==null) {
			model.addAttribute("viewName", "general/login.jsp");
		} else {
		model.addAttribute("map", gson.toJson(service.viewVolunteer(volunteerNo, principal.getName())));
		model.addAttribute("name", gson.toJson(principal.getName()));
		System.out.println(gson.toJson(principal.getName()));
		model.addAttribute("viewName","menu/volunteer/volunteerView.jsp");
		}
		return "index";
	}
	
	
	// 봉사 글 정보 수정
	@GetMapping("/volunteer/update")
	public String volunteerUpdate(Model model, int volunteerNo, RedirectAttributes ra) {
		model.addAttribute("volunteer",gson.toJson(service.getVolunteer(volunteerNo)));
		model.addAttribute("viewName","menu/volunteer/volunteerUpdate.jsp");
		return "index";
	}
	
	@PostMapping("/volunteer/update")
	public String volunteerUpdate(Volunteer volunteer,HttpServletRequest req, RedirectAttributes ra) {
		service.updateVolunteer(volunteer);
		return "redirect:/menu/volunteer/view?volunteerNo="+volunteer.getVolunteerNo();
	}
	
	// 봉사 글 삭제
	@PostMapping("/volunteer/delete")
	public String volunteerDelete(Volunteer volunteer, RedirectAttributes ra) {
		System.err.println("22 volunteerComment : ");
		service.deleteVolunteer(volunteer);
		return "redirect:/menu/volunteer/record";
	}
	
	//  전체 댓글 가져오기
	@PostMapping("/volunteer/comment")
	public ResponseEntity<List<VolunteerComment>> viewAllVolunteerComment(int volunteerNo) {
		
		return new ResponseEntity<List<VolunteerComment>>(service.viewVolunteerComment(volunteerNo), HttpStatus.OK);
	}
	
	// 댓글 작성
	@PostMapping("/volunteer/comment/insert")
	public ResponseEntity<List<VolunteerComment>> insertVolunteerComment(VolunteerComment vc, Principal principal){
		vc.setWriteId(principal.getName());
		List<VolunteerComment> r = service.insertVolunteerComment(vc);
		if (r!=null) {
			return new ResponseEntity<List<VolunteerComment>>(r, HttpStatus.OK);
		}
		return new ResponseEntity<List<VolunteerComment>>(HttpStatus.NOT_FOUND);
	}
	
	
	// 댓글 수정 
	@PostMapping("/volunteer/comment/update")
	public ResponseEntity<Void> updateVolunteerComment(VolunteerComment volunteerComment,HttpServletRequest req, RedirectAttributes ra) {
		System.err.println("22 volunteerComment : " + volunteerComment);
		service.updateVolunteerComment(volunteerComment);
		
		
		return new ResponseEntity<Void>(HttpStatus.NOT_FOUND);
	}
	
	
	// 댓글 삭제
	@PostMapping("/volunteer/comment/delete")
	public ResponseEntity<List<VolunteerComment>> deleteVolunteerComment(VolunteerComment volunteerComment) {
		System.err.println("22 VolunteerComment : " + volunteerComment);
		boolean result = service.deleteVolunteerComment(volunteerComment);
		System.out.println("아아아"+result);
		return new ResponseEntity<List<VolunteerComment>>(HttpStatus.NOT_FOUND);
	}
	
	
	// 봉사 신청
	@GetMapping("/volunteer/apply")
	public String volunteerApply(VolunteerApply volunteerApply, Model model,VolunteerComment volunteerComment ) {
		model.addAttribute("volunteerNo", gson.toJson(volunteerApply.getVolunteerNo()));
		model.addAttribute("viewName", "menu/volunteer/volunteerApply.jsp");
		return "index";
	}
	@PostMapping("/volunteer/apply" )
	public String volunteerApply(VolunteerApply volunteerApply,Principal principal) {
		volunteerApply.setMemberId(principal.getName());
		service.insertVolunteerApply(volunteerApply);
		return "redirect:/menu/volunteer/view?volunteerNo="+volunteerApply.getVolunteerNo();
	}
		
	// 봉사 신청 취소
	@PostMapping("/volunteer/apply/delete")
	public String volunteerApplyDelete(VolunteerApply volunteerApply, Principal principal, VolunteerComment volunteerComment) {
		volunteerApply.setMemberId(principal.getName());
		service.deleteVolunteerApply(volunteerApply);
		return "redirect:/menu/volunteer/view?volunteerNo="+volunteerApply.getVolunteerNo();
	}
	
	// 신고하기 및 쿠키를 이용한 중복신고방지
	@PostMapping("/volunteer/report_cnt")
	// 사용자에게서 report란 쿠키를 얻어온다. 이 쿠키에는 사용자가 추천한 글의 번호들이 담겨있다
	public ResponseEntity<Integer> report(@CookieValue(value = "report", required = false) String report, int volunteerNo,
		HttpServletResponse response) throws UnsupportedEncodingException {
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
			System.out.println("테스트2:" + recList.contains(volunteerNo));


		if (recList.contains(volunteerNo) == false) {
			// recList에 지금 추천하려는 글의 번호가 들어있지 않은 경우 신고
			reportCnt = service.report(volunteerNo);
			System.out.println("cnt" + reportCnt);
			// recList에 추천한 글번호를 추가
			recList.add(volunteerNo);
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

		
}
