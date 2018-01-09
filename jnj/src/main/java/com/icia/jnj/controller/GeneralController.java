package com.icia.jnj.controller;

import java.io.IOException;
import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.mail.MessagingException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.*;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.google.gson.Gson;
import com.icia.jnj.service.CenterService;
import com.icia.jnj.service.GeneralService;
import com.icia.jnj.service.MemberService;
import com.icia.jnj.util.PagingUtil;
import com.icia.jnj.vo.Authority;
import com.icia.jnj.vo.Center;
import com.icia.jnj.vo.CenterImg;
import com.icia.jnj.vo.Member;
import com.icia.jnj.vo.Message;
import com.icia.jnj.vo.Pagination;

@Controller
public class GeneralController {

	@Autowired
	private GeneralService service;

	@Autowired
	private CenterService Cservice;

	@Autowired
	private MemberService Mservice;
	
	// 사용자명 가져오기
	@GetMapping("/username") 
	@ResponseBody public String currentUserName(Principal principal) { 
		return principal.getName(); 
		} 
	

	// 메인화면 / 경로
	@GetMapping("/")
	public String main(Model model) {
		model.addAttribute("viewName", "general/main.jsp");
		
		return "index";
	}

	// 로그인 페이지이동
	@GetMapping("/login")
	public String login(Model model) {
		model.addAttribute("viewName", "general/login.jsp");
		return "index";
	}

	// G02로그인(일반, 센터), G03(로그아웃) Security

	// 아이디찾기 페이지 이동 (일반/센터)
	@GetMapping("find_id")
	public String memberIdFindForm(int type) {
		if (type == 1) {
			return "general/memberIdFind";
		} else {
			return "general/centerIdFind";
		}

	}

	

	// 아이디찾기 실행 (일반/센터)
	@PostMapping("/find_id")
	public ResponseEntity<String> findId(int type, String memberName, String licensee, String email) {
		if (type == 1)
			return new ResponseEntity<String>(service.findId(memberName, licensee, email), HttpStatus.OK);
		return new ResponseEntity<String>(service.findId(memberName, licensee, email), HttpStatus.OK);
	}

	

	// 비밀번호찾기 페이지 이동 (일반/센터)
	@GetMapping("find_pwd")
	public String memberPwdFindForm(int type) {
		if (type == 1) {
			return "general/memberPwdFind";
		} else {
			return "general/centerPwdFind";
		}
	}

	// 회원가입 선택 페이지 이동 (일반/센터)
	@GetMapping("/join")
	public String join(Model model) {
		model.addAttribute("viewName", "general/joinMain.jsp");
		return "index";
	}

	// 일반 회원가입 폼 페이지 이동
	@GetMapping("/join_member")
	public String memberJoinForm(Model model) {
		model.addAttribute("viewName", "general/memberJoin.jsp");
		return "index";
	}

	// 센터 회원가입 폼 페이지 이동
	@GetMapping("/join_center")
	public String centerJoinForm(Model model) {
		model.addAttribute("viewName", "general/centerJoin.jsp");
		return "index";
	}

	// 센터 비밀번호 찾기 메일발송
	@PostMapping("/find_pwd")
	public ResponseEntity<Map<String, String>> sendPwdEmail(int type, String id, String email)
			throws MessagingException {
		if (type == 1) {
			Map<String, String> map = Cservice.sendPwdEmail(id, email);
			return new ResponseEntity<Map<String, String>>(map, HttpStatus.OK);
		} else {
			Map<String, String> map = Mservice.sendPwdEmail(id, email);
			return new ResponseEntity<Map<String, String>>(map, HttpStatus.OK);
		}

	}

	// 센터&일반 인증번호 입력페이지로 이동
	@GetMapping("/check_code")
	public String pwdCodeCheckPage(int type) {
		if (type == 1) {
			return "general/centerPwdCodeCheck";
		} else {
			return "general/memberPwdCodeCheck";
		}
	}
	
	
	
	// 비밀번호 재설정 화면 이동(일반,센터)
	@GetMapping("/setting_pwd")
	public String settingPwdPage(int type, String id, Model model) {
		
		System.out.print( "type : " + type);
		System.out.print( "id : " + id);
		
		model.addAttribute("id", new Gson().toJson(id));
		
		if(type==1) {
			return "general/centerPwdUpdate";
		} else {
			return "general/memberPwdUpdate";
		}
	}
	
	// 비밀번호 재설정 (일반, 센터) 
	@PostMapping("/setting_pwd")
	public ResponseEntity<Void> settingPwdPage( int type, String password , String id ) {
		
		System.out.println("password : " + password );
		System.out.println("type : " + type );
		System.out.println("id : " + id );
		
		if(type==1) {
			Cservice.updatePassword(password, id);
			Map<String, String> map = new HashMap<String, String>(); 
			return new ResponseEntity<Void>(HttpStatus.OK);
		}else {
			Mservice.updatePassword(password, id);
			Map<String, String> map = new HashMap<String, String>(); 
			return new ResponseEntity<Void>(HttpStatus.OK);
		}
		
	}
	
	
	
	
	// 아이디 사용가능 여부 확인(일반)
		@PostMapping("/check_id")
		public ResponseEntity<Boolean> idCheck(int type, String memberId, String centerId) {
			System.out.println(memberId);
			System.out.println(centerId);
			if(type==1) {
				return new ResponseEntity<Boolean>(Mservice.idCheck(memberId), HttpStatus.OK);
			} else {
				return new ResponseEntity<Boolean>(Cservice.idCheck(centerId), HttpStatus.OK);
			}
		}
		
		
		
	// 이메일 사용가능 여부 확인(일반)
		@PostMapping("/check_email")
		public ResponseEntity<Boolean> idEmail(int type, String str_email01, String selectEmail) {
			
			String email = str_email01+"@"+selectEmail;
			
			System.out.println(email);
			
			if(type==1) {
				return new ResponseEntity<Boolean>(Mservice.idEmail(email), HttpStatus.OK);
			} else {
				return new ResponseEntity<Boolean>(Cservice.idEmail(email), HttpStatus.OK);
			}
		
		}
		
		
	// 일반 회원가입
		@PostMapping("/join_member")
		public String joinMember(Member member, Model model, String str_email01, String selectEmail) {
			System.out.println(member);
			member.setGrade(1);
			member.setMemberState(1); // 0:블락.. 1 : 사용중..
			member.setPoint(0);
			member.setReportCnt(0);
			
			String email = str_email01+"@"+selectEmail;
			
			member.setEmail(email);
			
			Mservice.joinMember(member);  
			model.addAttribute("viewName", "general/login.jsp");
			return "index";
		}
		
	// 센터 회원가입
		@PostMapping("/join_center")
		public String joinMember( Center center , Model model, MultipartFile[] files) throws IOException {
			
			center.setCenterState(2); // 가입대기상태로 가입시켜야하니까
			Cservice.joinCenter( center, files);
			
			model.addAttribute("viewName", "general/login.jsp");
			return "index";
		}
		
		
		
		
		
		
		
	// 수현 - 쪽지	
		
	@GetMapping("/general/massage/msgcnt")
	public ResponseEntity<Integer> getReceivedMsgCount(Principal principal) {
		int result = service.getReceivedMsgCount(principal.getName());
		// 기본자료형과 그 자료형 클래스(wrapper class)는 자동변환: auto-boxing
		return new ResponseEntity<Integer>(result, HttpStatus.OK);
	}
		
	// 보낸 쪽지 리스트
	@GetMapping("/general/message/send/record")
	public String getSendList(Principal principal, @RequestParam(defaultValue="1") int pageNo, Model model) {
		model.addAttribute("viewName", "general/message/msgList.jsp");
		model.addAttribute("map", new Gson().toJson(service.getSendList(principal.getName(), pageNo)));
		return "index";
	}

	// 받은 쪽지 리스트
	@GetMapping("/general/message/receive/record")
	public String getReceiveList(Principal principal, @RequestParam(defaultValue="1") int pageNo, Model model) {
		model.addAttribute("viewName", "general/message/msgList.jsp");
		model.addAttribute("map", new Gson().toJson(service.getReceiveList(principal.getName(), pageNo)));
		return "index";
	}

	// 보낸 쪽지 뷰
	@GetMapping("/general/message/send/view")
	public String getSendView(int messageNo, Principal principal, Model model) {
		model.addAttribute("viewName", "general/message/msgView.jsp");
		model.addAttribute("msgView", new Gson().toJson(service.getSendView(messageNo, principal.getName())));
		return "index";
	}

	// 받은 쪽지 뷰
	@GetMapping("/general/message/receive/view")
	public String getReceiveView(int messageNo, Principal principal, Model model) {
		model.addAttribute("viewName", "general/message/msgView.jsp");
		model.addAttribute("msgView", new Gson().toJson(service.getReceiveView(messageNo, principal.getName())));
		return "index";
	}

	//
 	
	// 쪽지 작성화면
	@PostMapping("/general/message/write")
	public String writeMessagePage(Model model, String receiverId) {
		model.addAttribute("viewName", "general/message/msgWrite.jsp");
		model.addAttribute("receiverId", new Gson().toJson(receiverId));
		return "index";
	}	
	
	// 쪽지 보내기
	@ResponseBody
	@PostMapping("/general/message/write/1")
	public boolean insertMessage(Message msg, Principal principal) {
		msg.setSenderId(principal.getName());
		boolean result = service.insertMessage(msg);
		return result;
	}	
	

	// 쪽지 삭제
	@PostMapping("/general/message/delete")
	public String deleteMsg(@RequestParam List<Integer> messageNo, @RequestParam List<Integer> msgState, @RequestParam List<String> sort) {
		for(int i=0; i<messageNo.size(); i++) {
			if(msgState.get(i)==3 || msgState.get(i)==4) {
				service.deleteMsg(messageNo.get(i));
			} else if(msgState.get(i)==1 || msgState.get(i)==2) {
				if(sort.get(i).equals("send")) {
					service.updateSendDel(messageNo.get(i));
				} else if(sort.get(i).equals("receive")) {
					service.updateReceiveDel(messageNo.get(i));
				}
			}
		}
		return "redirect:/general/message/receive/record";
	}
	
	
}

