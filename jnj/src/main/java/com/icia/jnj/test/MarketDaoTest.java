package com.icia.jnj.test;

import org.junit.*;
import org.junit.runner.*;
import org.mybatis.spring.*;
import org.springframework.beans.factory.annotation.*;
import org.springframework.test.context.*;
import org.springframework.test.context.junit4.*;

import com.icia.jnj.dao.*;
import com.icia.jnj.vo.*;

@RunWith( SpringJUnit4ClassRunner.class )
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/**/*-context.xml")
public class MarketDaoTest {
	
	@Autowired
	private SqlSessionTemplate tpl;
	
	@Autowired
	private RecruitDao dao;
	@Autowired
	//private MarketDao mdao;
	//@Test
	public void countMarketTest() {
		System.out.println(dao.getMarketCount());
	}
	//@Test
	public void tqlTest() {
		System.out.println(null==tpl);
	}
	//@Test
	public void getAllMarketTest() {
		System.out.println(dao.getAllMarket());
	}
	//@Test
	public void getAllPageMarketTest() {
		System.out.println(dao.getAllPageMarket(1, 10));;
	}
	//@Test
	public void getMarketTest() {
		System.out.println(dao.getMarket(130));
	}
	//@Test
	public void insertMarketTest() {
		Market m = new Market();
		m.setApplyEndDate("19990101");
		m.setBoothPrice(2);
		m.setMarketAddr("인천남구");
		m.setMarketContent("으으으으응");
		m.setMarketDate("19991102");
		m.setMarketTitle("왜왜");
		dao.insertMarket(m);
	}
	//@Test
	public void deleteMarketTest() {
		dao.deleteMarket(4);
	}
	//@Test
	public void updateMarketTest() {
		Market m = new Market();
		m.setMarketNo(3);
		m.setApplyEndDate("19990101");
		m.setApplyPeople(10);
		m.setBoothPrice(2);
		m.setMarketAddr("인천남구");
		m.setMarketContent("우와");
		m.setMarketDate("19991102");
		m.setMarketState(1);
		m.setMarketTitle("왜왜");
		m.setWriteDate("20171128");
		dao.updateMarket(m);
	}
	
	
	
	/*프리마켓 댓글*/
	//@Test
	public void getAllMarketCommentTest() {
		System.out.println(dao.getAllMarketComment());
	}
	//@Test
	public void getAllPageMarketCommentTest() {
		System.out.println(dao.getAllPageMarketComment(1, 10));;
	}
	//@Test
	public void insertMarketComment() {
		MarketComment mc = new MarketComment();
		mc.setCommentContent("댓글아dddddd으으응ㅇ");
		mc.setMarketNo(141);
		mc.setWriteId("leecw");
		dao.insertMarketComment(mc);
	}
	//@Test
	public void deleteAllMarketCommentTest() {
		dao.deleteAllMarketComment(1);
	}
	//@Test
	public void getMarketCommentTest() {
		System.out.println(dao.getMarketComment(130));
	}
	
	//@Test
	public void updateMarketCommentTest() {
		MarketComment mc = new MarketComment();
		mc.setMarketCommentNo(2);
		mc.setCommentContent("가나다라마바사");
		mc.setMarketNo(2);
		mc.setReportCnt(5);
		mc.setWriteDate("20171130");
		mc.setWriteId("lccwe");
		dao.updateMarketComment(mc);
	}
	//@Test
	public void deleteMarketCommentTest() {
		dao.deleteMarketComment( 2, 2);
	}
	
	
	/*프리마켓 신청*/
	//@Test
	public void getAllMarketApplyTest() {
		System.out.println(dao.getAllMarketApply());
	}
	//@Test
	public void getAllPageMarketApplyTest() {
		System.out.println(dao.getAllPageMarketApply(1, 10));
	}
	//@Test
	public void insertMarketApplyTest() {
		MarketApply ma = new MarketApply();
		ma.setMarketNo(143);
		ma.setMemberId("lee1231");
		ma.setApplyTel("0105154247");
		ma.setBoothNum(2);
		ma.setPayWay(1);
		ma.setDepositor("이치우이이이이");
		dao.insertMarketApply(ma);
	}
	//@Test
	public void deleteMarketApplyTest() {
		dao.deleteMarketApply(2, "chiwoo");
	}
	//@Test
	public void getMarketApplyList() {
		dao.getMarketApplyList(145);
	}
	@Test
	public void marketCommentCount() {
		//mdao.marketCommnetCount(1);;
	}
}
