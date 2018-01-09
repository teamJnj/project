package com.icia.jnj.test;


import org.junit.Test;
import org.junit.runner.RunWith;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.icia.jnj.dao.BoardDao;
import com.icia.jnj.dao.FooterDao;
import com.icia.jnj.domain.Guestbook;
import com.icia.jnj.vo.Find;

@RunWith( SpringJUnit4ClassRunner.class )
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/**/*-context.xml")
public class findTest {
	
	@Autowired
	private SqlSessionTemplate tpl;

	@Autowired
	private BoardDao dao;
	
	@Autowired
	private FooterDao fdao;
	
	// 글 상세정보 가져오기
	//@Test
	public void boardFindViewPage() {
		System.out.println(dao.boardFindViewPage(1, 1));
	}
	
	// 글쓰기 찾아요
	//@Test
	public void boardFindWrite( ) {
		
		Find find = new Find();
		
		// service 설정
		find.setFindDivision(1);
		find.setWriteId("ㅇㅅㅇ");
		find.setHits(0);
		find.setCommentNum(0);
		find.setReportCnt(0);
		find.setFindState(1);
		
		// 사용자 입력
		find.setFindTitle("a");
		find.setFindContent("aa");
		find.setFindAddr("aa동");
		find.setFindDate("93/01/22");
		find.setMapX("300");
		find.setMapY("300");
		find.setPetImg("ㅇㅅ<");
		find.setPetName("냐아오오오옹이");
		//find.setPetSort("개");
		find.setPetKind("고등어");
		find.setPetGender(2);
		find.setPetAge(99);
		find.setPetFeature("고등ㅇ어고등");
		find.setWriteTel("01012345678");
		
		System.err.println( "find : " + find);
		//dao.boardFindWrite(find);
		
		
	}
	
	//@Test
	public void delete() {
		int findNo=23;
		dao.boardFindDelete(findNo);
		
	}
	
	
	/*//혜미 방명록 테스트
	//@Test
	public void getGuestbookCount() {
		System.out.println(fdao.getGuestbookCount());
	}
	//@Test
	public void getGuestbookList() {
		System.out.println(fdao.getGuestbookList(1,5));
	}
	//@Test
	public void insertGuestbook() {
		Guestbook guest = new Guestbook();
		guest.setGuestbookNo(3);
		guest.setMemberId("hyemi");
		guest.setContent("포켓몬들 짱귀여웡");
		guest.setWriteDate("18/01/01");
		fdao.insertGuestbook(guest);
		System.out.println("Guestbook : "+ guest);
	}
	//@Test
	public void updateGuestbook() {
		Guestbook guest = new Guestbook();
		guest.setGuestbookNo(3);
		guest.setMemberId("hyemi");
		guest.setContent("포켓몬들 짱안귀여워");
		guest.setWriteDate("18/01/01");
		fdao.updateGuestbook(guest);
		System.out.println("update : "+guest);
	}
	//@Test
	public void deleteGuestbook() {
		fdao.deleteGuestbook(3);
	}*/

}
