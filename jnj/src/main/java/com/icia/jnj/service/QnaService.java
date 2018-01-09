package com.icia.jnj.service;

import java.io.File;
import java.io.IOException;
import java.security.Principal;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;

import com.google.gson.JsonElement;
import com.icia.jnj.dao.MemberDao;
import com.icia.jnj.dao.QnaDao;
import com.icia.jnj.domain.*;
import com.icia.jnj.util.PagingUtil;
import com.icia.jnj.vo.Pagination;
import com.icia.jnj.vo.QnA;


@Service
public class QnaService {
	@Autowired
	private QnaDao dao;
	@Autowired
	@Value("\\\\192.168.0.203\\service\\qna")
	private String uploadPath;
	@Autowired
	private MemberDao memberDao;
	
	// 수안=====================
		// qna 리스트+ 페이지네이션
		@PreAuthorize("#writeId == principal.username or hasRole('ROLE_ADMIN')")
		public Map<String, Object> getQnaList(int pageno, String writeId, Principal principal){
			
			if(principal.getName().equals("admin")) {
				int articleCnt = dao.qnaAllCount();
				Pagination pagination = PagingUtil.setPageMaker(pageno, articleCnt, 10);
				
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("pagination", pagination);
				
				map.put("qnaList", dao.getAllQnaList(writeId,  pagination.getStartArticleNum(), pagination.getEndArticleNum()));
				
				return map;
				
			} else {
				int articleCnt = dao.qnaCount(writeId);
				Pagination pagination = PagingUtil.setPageMaker(pageno, articleCnt, 10);
				
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("pagination", pagination);
				
				if(principal.getName().equals(writeId)) {
					map.put("qnaList", dao.getQnaList(writeId, pagination.getStartArticleNum(), pagination.getEndArticleNum()));
				} return map;
			}
			
			
		}
		

		
		// qna글 작성
		@Transactional(rollbackFor=Exception.class)
		@PreAuthorize("#qna.writeId == principal.username")
		public Boolean insertQna(QnA qna, MultipartFile file) throws IOException {
			
			String mAuthority = memberDao.getMemberAuthority(qna.getWriteId());
			
			
			if(mAuthority.equals("ROLE_CENTER")) {
				
				String qnaImg = System.currentTimeMillis() + "-" + file.getOriginalFilename();
				
				File f = new File(uploadPath, qnaImg);
				FileCopyUtils.copy(file.getBytes(), f);
				
				qna.setQnaDivision(2);
				
				if(file.getOriginalFilename()!="") {
					qna.setQnaImg(qnaImg);
					dao.insertQna(qna);
				} else {
					dao.insertQna(qna);
					qna.setQnaImg(null);
				}
			}else {
				
				String qnaImg = System.currentTimeMillis() + "-" + file.getOriginalFilename();
				
				File f = new File(uploadPath, qnaImg);
				FileCopyUtils.copy(file.getBytes(), f);
				
				qna.setQnaDivision(1);
				
				if(file.getOriginalFilename()!="") {
					qna.setQnaImg(qnaImg);
					dao.insertQna(qna);
				} else {
					dao.insertQna(qna);
					qna.setQnaImg(null);
				}
				
			}
			
			
			return true;
		}
		
		
		// qna글 보기
		@PreAuthorize("#writeId == principal.username or hasRole('ROLE_ADMIN')")
		public QnA getQnaView(int qnaNo, String writeId){
			
			if(writeId.equals("admin")) {
				QnA qna = dao.getAdminQnaView(qnaNo);
				if(dao.checkAnswer(qnaNo, qna.getWriteId())==1) {
					qna.setAnswerContent(qna.getAnswerContent());
				}else {
					qna.setAnswerContent("null");
				}
				return qna;
			} else {
				QnA qna = dao.getQnaView(qnaNo,writeId);
				if(dao.checkAnswer(qnaNo, writeId)==1) {
					qna.setAnswerContent(qna.getAnswerContent());
				}else {
					qna.setAnswerContent("null");
				}
				return qna;
			}
		}

		
		// qna글 수정
		@PreAuthorize("#qna.writeId == principal.username or hasRole('ROLE_ADMIN')")
		public Boolean updateQna(QnA qna, MultipartFile file) throws IOException {
			if(file.getOriginalFilename()!="") {
				String qnaImg = System.currentTimeMillis() + "-" + file.getOriginalFilename();
				
				File f = new File(uploadPath, qnaImg);
				FileCopyUtils.copy(file.getBytes(), f);
				
				
				qna.setQnaTitle(qna.getQnaTitle());
				qna.setQnaContent(qna.getQnaContent());
				qna.setQnaImg(qnaImg);
				
				dao.updateQna(qna);
			}else{
				// MultipartFile file이 null이 들어온경우 (dao, mapper필요)
				qna.setQnaTitle(qna.getQnaTitle());
				qna.setQnaContent(qna.getQnaContent());
				qna.setQnaImg(qna.getQnaImg());
				
				dao.updateQna(qna);
			}
			
			return true;
		}
		
		
		// qna글 삭제
		@PreAuthorize("#qna.writeId == principal.username or hasRole('ROLE_ADMIN')")
		public void deleteQna(QnA qna) {
			
			qna.setQnaNo(qna.getQnaNo());
			qna.setWriteId(qna.getWriteId());
			dao.deleteQna(qna);
		}
		
		
		// qna 답변쓰기(수정)
		@PreAuthorize("hasRole('ROLE_ADMIN')")
		public QnA updateAnswer(QnA qna) {
			System.err.println("여기는오니???"+qna);
			dao.updateAnswer(qna);
			return qna;
		}


		
	// 주리
	public Map<String, Object> getQnaList(AdMQnaInfo info) {

		info.setSqlText("");

		if (!info.getSearchText().equals("%")) {
			if (info.getSearchColName().equals("qnaTitle"))
				info.setSqlText("where qnaTitle like '%" + info.getSearchText() + "%'");

			else if (info.getSearchColName().equals("qnaDivision"))
				info.setSqlText("where qnaDivision like '%" + info.getSearchText() + "%'");

			else if (info.getSearchColName().equals("answerContent")) {
				if (info.getSearchText().equals("0")) // 처리중
					info.setSqlText("where answerContent is null");
				else if (info.getSearchText().equals("1"))
					info.setSqlText("where answerContent is not null");
			}
		} else {
			if (info.getSearchColName().equals("writeDate"))
				info.setSqlText("where to_date(writeDate, 'yyyyMMdd')>=to_date(" + info.getStartDate()
						+ ", 'yyyyMMdd') and to_date(writeDate, 'yyyyMMdd')<= to_date(" + info.getEndDate()
						+ ", 'yyyyMMdd')");
		}

		int articleCnt = dao.getCountQnaList(info);

		Pagination pagination = PagingUtil.setPageMaker(info.getPageno(), articleCnt, 10);

		info.setStartArticleNum(pagination.getStartArticleNum());
		info.setEndArticleNum(pagination.getEndArticleNum());

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("adMQnaInfo", info);
		map.put("pagination", pagination);
		map.put("qnaList", dao.getQnaAllList(info));
		map.put("stateCount1", dao.getMemberTotalQnaS1(info.getWriteId()));
		map.put("stateCount2", dao.getMemberTotalQnaS2(info.getWriteId()));
		return map;
	}

	public Map<String, Object> getTotalQnaList(AdMQnaInfo info) {

		info.setSqlText("");

		if (!info.getSearchText().equals("%")) {
			if (info.getSearchColName().equals("qnaTitle"))
				info.setSqlText("where qnaTitle like '%" + info.getSearchText() + "%'");

			else if (info.getSearchColName().equals("qnaDivision"))
				info.setSqlText("where qnaDivision like '%" + info.getSearchText() + "%'");

			else if (info.getSearchColName().equals("answerContent")) {
				if (info.getSearchText().equals("0")) // 처리중
					info.setSqlText("where answerContent is null");
				else if (info.getSearchText().equals("1"))
					info.setSqlText("where answerContent is not null");
			}
		} else {
			if (info.getSearchColName().equals("writeDate"))
				info.setSqlText("where to_date(writeDate, 'yyyyMMdd')>=to_date(" + info.getStartDate()
						+ ", 'yyyyMMdd') and to_date(writeDate, 'yyyyMMdd')<= to_date(" + info.getEndDate()
						+ ", 'yyyyMMdd')");
		}

		int articleCnt = dao.getCountTotalQnaList(info);

		Pagination pagination = PagingUtil.setPageMaker(info.getPageno(), articleCnt, 10);

		info.setStartArticleNum(pagination.getStartArticleNum());
		info.setEndArticleNum(pagination.getEndArticleNum());

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("adMQnaInfo", info);
		map.put("pagination", pagination);
		map.put("qnaList", dao.getTotalQnaAllList(info));
		map.put("stateCount3", dao.getMemberTotalQnaS3());
		map.put("stateCount4", dao.getMemberTotalQnaS4());
		return map;
	}

}
