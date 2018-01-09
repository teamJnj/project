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
public class MemberDaoTest {
	
	@Autowired
	private SqlSessionTemplate tpl;
	
	@Autowired
	private MemberDao mdao;
	
	@Autowired
	private CenterDao cdao;
	
	
	// ===================================================================
	// 일반 회원
	
	//@Test
	public void tplTest() {
		System.out.println( tpl == null );
	}
	
	//@Test
	public void getCountMember() {
		System.out.println( mdao.getCountMember() );
	}
	
	//@Test
	public void getAllMember() {
		System.out.println( mdao.getAllMember() );
	}
	
	//@Test
	public void getAllPageMember() {
		System.out.println( mdao.getAllPageMember(1,10) );
	}
	
	//@Test
	public void getMemeber() {
		System.out.println( mdao.getMemeber("juri") );
	}
	
	//@Test
	public void getMemberId() {
		System.out.println( mdao.getMemberId("박주리", "cj920406@naver.com") );
	}

	//@Test
	public void checkMemberIdAndEmail() {
		System.out.println( mdao.checkMemberIdAndEmail("juri", "cj920406@naver.com") );
	}
	
	//@Test
	public void checkExistMemberId() {
		System.out.println( mdao.checkExistMemberId("juri") );
	}
	
	//@Test
	public void checkMemberEmail() {
		System.out.println( mdao.checkExistMemberId("cj920406@naver.com") );
	}
	
	//@Test
	public void insertMember() {
		Member member = new Member();
		member.setMemberId("test1234");
		member.setPassword("111");
		member.setMemberName("테스트");
		member.setBirthDate("2017-11-28");
		member.setEmail("email");
		member.setPoint(10);
		member.setGrade(1);
		member.setReportCnt(1);
		member.setMemberState(1);
		//System.out.println( mdao.insertMember(member) );
	}
	
	//@Test
	public void updateMember() {
		//System.out.println( mdao.updateMember("test1234", "222", "2email") );
	}
	
	//@Test
	public void deleteMember() {
		System.out.println( mdao.deleteMember("test1234") );
	}
	
	
	
	// ===================================================================
	// 센터 회원
	//@Test
	public void getAllCenter() {
		System.out.println( cdao.getAllCenter() );
	}
	
	//@Test
	public void getAllPageCenter() {
		System.out.println( cdao.getAllPageCenter(1,10) );
	}
	
	//@Test
	public void getCenter() {
		System.out.println( cdao.getCenter("center1"));
	}
	
	//@Test
	public void getCenterId() {
		System.out.println( cdao.getCenterId("동물보호센터1","cj920406@naver.com") );
	}
	
	//@Test
	public void checkCenterIdAndEmail() {
		System.out.println( "test result : " + cdao.checkCenterIdAndEmail("center1","cj920406@naver.com") );
	}
	
	//@Test
	public void checkExistCenterId() {
		System.out.println( cdao.checkExistCenterId("center1"));
	}
	
	//@Test
	public void checkExistCenterEmail() {
		System.out.println( cdao.checkExistCenterEmail("cj920406@naver.com"));
	}
	
	//@Test
	public void insertCenter() {
		Center center = new Center();
		center.setCenterId("test1");
		center.setPassword("1");
		center.setCenterName("테스트");
		center.setCenterAddr("addr");
		center.setCenterTel("tel");
		center.setEmail("email");
		center.setHomepage("homepage");
		center.setLicensee("setLicensee");
		center.setLicenseNo(1);
		center.setLicenseImg("setLicenseImg");
		center.setSponsorAccountNo("setSponsorAccountNo");
		center.setSponsorAccountHolder("holder");
		center.setSponsorAccountBank("bank");
		center.setSponsorAccountImg("Img");
		center.setCenterState(1);
		//System.out.println( cdao.insertCenter(center));
	}
	
	//@Test
	public void updateCenter() {
		//System.out.println( cdao.updateCenter("test1", "1234"));
	}
	
	//@Test
	public void deleteCenter() {
		System.out.println( cdao.deleteCenter("test1"));
	}
	
}
