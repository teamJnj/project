package com.icia.jnj.controller;

import java.io.IOException;
import java.security.Principal;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.gson.Gson;
import com.icia.jnj.constant.CT;
import com.icia.jnj.dao.*;
import com.icia.jnj.service.QnaService;
import com.icia.jnj.vo.QnA;

import oracle.net.aso.*;


@Controller
@RequestMapping("/common")
public class QnaController {
	@Autowired
	private QnaService service;
	@Autowired
	private CenterDao cDao;
	@Autowired
	private Gson gson;
	@Value("\\\\192.168.0.203\\service\\qna")
	private String uploadPath;
	
	
	// qna리스트
	@GetMapping({"/qna/record", "/qna"})
	public String getQnaList(@RequestParam(defaultValue = "1") int pageno, Model model, Principal principal) {
		String writeId = principal.getName();
		model.addAttribute("map",gson.toJson(service.getQnaList(pageno, writeId, principal)));
		model.addAttribute("viewName", "menu/board/QnA/qnaList.jsp");
		return "index";
	}
	
	// qna리스트-센터
	@GetMapping("/cQna")
	public String getCQna(@RequestParam(defaultValue = "1") int pageno, Model model, Principal principal) {
		String writeId = principal.getName();
		int cState = cDao.getCenterState(writeId);
		model.addAttribute("cState", gson.toJson(cState));
		model.addAttribute("isFirst", gson.toJson("first"));
		model.addAttribute("map", gson.toJson(service.getQnaList(pageno, writeId, principal)));
		model.addAttribute("viewName", "menu/board/QnA/cQnaList.jsp");
		return "index";
	}
	
	// qna리스트-센터
	@GetMapping("/cQna/record")
	public String getCQnaList(@RequestParam(defaultValue = "1") int pageno, Model model, Principal principal) {
		String writeId = principal.getName();
		int cState = cDao.getCenterState(writeId);
		model.addAttribute("cState", gson.toJson(cState));
		model.addAttribute("isFirst", gson.toJson("second"));
		model.addAttribute("map", gson.toJson(service.getQnaList(pageno, writeId, principal)));
		model.addAttribute("viewName", "menu/board/QnA/cQnaList.jsp");
		return "index";
	}
	
	
	// qna뷰화면 이동
	@GetMapping("/qna/view")
	public String getQnaView(int qnaNo, Principal principal, Model model) {
		model.addAttribute("map", gson.toJson(service.getQnaView(qnaNo, principal.getName())));
		model.addAttribute("writeId",gson.toJson(principal.getName()));
		model.addAttribute("viewName", "menu/board/QnA/qnaView.jsp");
		return "index";
	}
	// qna뷰화면 이동-센터
	@GetMapping("/cQna/view")
	public String getCQnaView(int qnaNo, Principal principal, Model model) {
		int cState = cDao.getCenterState(principal.getName());
		model.addAttribute("cState", gson.toJson(cState));
		model.addAttribute("map", gson.toJson(service.getQnaView(qnaNo, principal.getName())));
		model.addAttribute("writeId", gson.toJson(principal.getName()));
		model.addAttribute("viewName", "menu/board/QnA/cQnaView.jsp");
		return "index";
	}
	
	// qna 글쓰기
	@GetMapping("/qna/write1")
	public String getInsertQna(Model model, Principal principal) {
		model.addAttribute("writeId",gson.toJson(principal.getName()));
		model.addAttribute("viewName", "menu/board/QnA/qnaWrite.jsp");
		return "index";
	}
	// qna 글쓰기-센터
	@GetMapping("/cQna/write1")
	public String getInsertCQna(Model model, Principal principal) {
		int cState = cDao.getCenterState(principal.getName());
		model.addAttribute("cState", gson.toJson(cState));
		model.addAttribute("writeId", gson.toJson(principal.getName()));
		model.addAttribute("viewName", "menu/board/QnA/cQnaWrite.jsp");
		return "index";
	}
	
	@PostMapping("/qna/write2")
	public String postInsertQna(QnA qna, Principal principal, @RequestParam(required = false) MultipartFile file, Model model, HttpServletRequest req, RedirectAttributes ra) throws IOException {
		qna.setWriteId(principal.getName());
		
		qna.setQnaDivision(CT.QNA_QNADIVISION_MEMBER);
		boolean result = service.insertQna(qna, file);
		
		ra.addFlashAttribute("isSuccess",result);
		return "redirect:/common/qna/record?writeId="+principal.getName();
	}
	@PostMapping("/cQna/write2")
	public String postInsertCQna(QnA qna, Principal principal, @RequestParam(required = false) MultipartFile file, Model model, HttpServletRequest req, RedirectAttributes ra) throws IOException {
		qna.setWriteId(principal.getName());

		qna.setQnaDivision(CT.QNA_QNADIVISION_CENTER);
		boolean result = service.insertQna(qna, file);
		
		ra.addFlashAttribute("isSuccess",result);
		return "redirect:/common/cQna/record?writeId="+principal.getName();
	}
	
	
	// qna 수정
	@PostMapping("/qna/update1")
	public String getUpdateQna(QnA qna, Model model, Principal principal) {
		model.addAttribute("writeId",gson.toJson(principal.getName()));
		model.addAttribute("qna",gson.toJson(qna));
		model.addAttribute("viewName", "menu/board/QnA/qnaUpdate.jsp");
		return "index";
	}
	
	// qna 수정-센터
	@PostMapping("/cQna/update1")
	public String getUpdateCQna(QnA qna, Model model, Principal principal) {
		int cState = cDao.getCenterState(principal.getName());
		model.addAttribute("cState", gson.toJson(cState));
		model.addAttribute("writeId", gson.toJson(principal.getName()));
		model.addAttribute("qna", gson.toJson(qna));
		model.addAttribute("viewName", "menu/board/QnA/cQnaUpdate.jsp");
		return "index";
	}
	
	@PostMapping("/qna/update2")
	public String postUpdateQna(QnA qna, Principal principal, @RequestParam(required = false) MultipartFile file, Model model, HttpServletRequest req, RedirectAttributes ra) throws IOException {
		qna.setQnaDivision(CT.QNA_QNADIVISION_MEMBER);
		boolean result = service.updateQna(qna, file);
		ra.addFlashAttribute("isSuccess",result);
		
		return "redirect:/common/qna/record?writeId="+principal.getName();
	}
	@PostMapping("/cQna/update2")
	public String postUpdateCQna(QnA qna, Principal principal, @RequestParam(required = false) MultipartFile file, Model model, HttpServletRequest req, RedirectAttributes ra) throws IOException {
		qna.setQnaDivision(CT.QNA_QNADIVISION_CENTER);
		boolean result = service.updateQna(qna, file);
		ra.addFlashAttribute("isSuccess",result);
		
		return "redirect:/common/cQna/record?writeId="+principal.getName();
	}
	
	// qna 삭제
	@PostMapping("/qna/delete")
	public String deleteQna(QnA qna, RedirectAttributes ra, Principal principal) {
		qna.setQnaNo(qna.getQnaNo());
		qna.setWriteId(qna.getWriteId());
		service.deleteQna(qna);
		return "redirect:/common/qna/record?writeId="+principal.getName();
	}
	// qna 삭제
	@PostMapping("/cQna/delete")
	public String deleteCQna(QnA qna, RedirectAttributes ra, Principal principal) {
		qna.setQnaNo(qna.getQnaNo());
		qna.setWriteId(qna.getWriteId());
		service.deleteQna(qna);
		return "redirect:/common/cQna/record?writeId=" + principal.getName();
	}
	
	// 관리자만 할 수 있는거
	// qna 답변등록(수정)
	@PostMapping("/qna/update3")
	public ResponseEntity<Void> updateAnswer(QnA qna, Principal principal) {
		
		service.updateAnswer(qna);
		
		return new ResponseEntity<Void>(HttpStatus.OK);
	}
	
}
