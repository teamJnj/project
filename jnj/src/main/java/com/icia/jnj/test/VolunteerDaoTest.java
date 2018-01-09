package com.icia.jnj.test;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

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
public class VolunteerDaoTest {

	@Autowired
	private SqlSessionTemplate tpl;
	
	@Autowired
	private RecruitDao dao;
	
	
// == volunteer테이블 ===============================================
	//@Test
	public void tplTest() {
		System.out.println( tpl==null );
	}
	
	
	/*//@Test
	public void getAllPageVolunteer() {
		System.out.print(dao.getAllPageVolunteer(1,10));
	}*/
	
	@Test
	public void getSortAllVolunteer() {
		System.out.print(dao.getSortAllVolunteer("volunteerNo", "dese", "%광주%", 1, 16));
	}
	//@Test
	public void getSortCountVolunteer() {
		System.out.println(dao.getSortCountVolunteer("%광주%"));
	}
	
	//@Test
	public void getVolunteer() {
		System.out.print(dao.getVolunteer(4));
	}
	
	//@Test
	public void updateVolunteer() {
		
		Volunteer vol = new Volunteer();
		
		vol.setVolunteerNo(23);
		vol.setApplyEndDate("2017-01-01");
		vol.setMinPeople(1);
		vol.setMaxPeople(10);
		vol.setHostTel("010-8888-9692");
		
		dao.updateVolunteer(vol);
	}
	
	//@Test
	public void deleteVolunteer() {
		dao.deleteVolunteer(23);
	}
	
	
	// == volunteer_comment테이블 ===============================================
	//@Test
	public void getAllVolunteerComment() {
		System.out.print( dao.getAllVolunteerComment() );
	}
	
	//@Test
	public void getAllPageVolunteerComment() {
		System.out.print( dao.getAllPageVolunteerComment(1,10) );
	}
	
	//@Test
	public void insertVolunteerComment() {
		
		VolunteerComment volunteerC = new VolunteerComment();
		volunteerC.setVolunteerCommentNo(100);
		volunteerC.setVolunteerNo(1);
		volunteerC.setWriteId("id");
		volunteerC.setCommentContent("내용");
		volunteerC.setWriteDate("2017-11-11");
		volunteerC.setReportCnt(10);
		
		dao.insertVolunteerComment(volunteerC);
		
		
	}
	
	//@Test
	public void updateVolunteerComment() {
		
		VolunteerComment volunteerC = new VolunteerComment();
		volunteerC.setVolunteerCommentNo(100);
		volunteerC.setVolunteerNo(1);
		volunteerC.setWriteId("id");
		volunteerC.setCommentContent("11111내용");
		volunteerC.setWriteDate("2017-11-11");
		volunteerC.setReportCnt(10);
		
		dao.updateVolunteerComment(volunteerC);
	}
	
	
	//@Test
	public void deleteVolunteerComment() {
		dao.deleteVolunteerComment(1, 1);
	}
	
	//@Test
	public void deleteAllVolunteerComment() {
		dao.deleteAllVolunteerComment(1);
	}
	
	//@Test
	public void getAllVolunteerApply() {
		//System.out.println(dao.getAllVolunteerApply());
	}
	
	//@Test
	public void getAllPageVolunteerApply() {
		System.out.println(dao.getAllPageVolunteerApply(1,10));
	}
	
	//@Test
	public void insertVolunteerApply() {
		VolunteerApply volunteerApply = new VolunteerApply();
		volunteerApply.setVolunteerNo(10);
		volunteerApply.setMemberId("idid");
		volunteerApply.setApplyTel("applyDate");
		volunteerApply.setApplyDate("2017-11-11");
		volunteerApply.setVolunteerApplyState(1);
		
		dao.insertVolunteerApply(volunteerApply);
	}
	
	//@Test
	public void deleteVolunteerApply() {
		dao.deleteVolunteerApply( 2, "sohee" );
	}
	//@Test
	public void getMypageMemberVolunteerAllList() {
		dao.getMypageMemberVolunteerAllList("juri",  1, 5);
	}
	/*//@Test
	public void getMypageMemberVolunteerCount() {
		dao.getMypageMemberVolunteerCount("juri", "center4");
	}*/
	//@Test
	public void getMypageMemberVolunteerHostMe() {
		dao.getMypageMemberVolunteerHostMe("center3", 1, 5);
	}
	//@Test
	public void getMypageMemberVolunteerJoin() {
		dao.getMypageMemberVolunteerJoin("juri", 1, 5);
	}
	//@Test
	public void getMypageMemberVolunteerList() {
		dao.getMypageMemberVolunteerList(2,1,5);
	}
	//@Test
	public void updateMemberVolunteerApplyState() {
		dao.updateMemberVolunteerApplyState("juri",0);
	}
	//@Test
	public void getMypageMemberVolunteerHostMeCount() {
		dao.getMypageMemberVolunteerHostMeCount("juri");
	}
	//@Test
	public void getMypageMemberVolunteerJoinCount() {
		dao.getMypageMemberVolunteerJoinCount("juri");
	}
//	@Test
	public void getMypageMemberVolunteerListCount() {
		dao.getMypageMemberVolunteerListCount(5);
	}
	
	//@Test
	public void stateTest() {
		Date today = new Date();
		System.out.println(today);
		String volunteerDate = "2017-12-20";
		String applyEndDate = "2017-12-19";
		Date date = null;
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		try {
			date = format.parse(volunteerDate);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		System.out.println(date);
		
		int compare = date.compareTo(today);
		if( compare>0) {
			System.out.println("아직 봉사날짜가 오지않음");
		}
		
		
	}
}
