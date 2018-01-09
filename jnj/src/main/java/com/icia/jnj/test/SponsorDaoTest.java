package com.icia.jnj.test;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

import com.icia.jnj.dao.SponsorDao;
import com.icia.jnj.domain.SponsorPayInfo;

@RunWith( SpringJUnit4ClassRunner.class )
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/**/*-context.xml")
public class SponsorDaoTest {
	@Autowired
	private SqlSessionTemplate tpl;
	
	@Autowired
	private SponsorDao dao;
	
	//@Test
	public void tplTest() {
		System.out.println( tpl == null );
	}
	
	//@Test
	public void getSponsorCountTest() {
		System.out.println(dao.getSponsorCount());
	}
	
	//@Test
	public void getSponsorListTest() {
		System.out.println(dao.getSponsorList(1, 1, 10));
	}
	
	//@Test
	public void getSponsorViewTest() {
		System.out.println(dao.getSponsorView(6));
	}
	
	//@Test
	public void getSponsorViewPictureTest() {
		System.out.println(dao.getSponsorViewPicture(6));
	}
	
	//@Test
	public void payAllTest() {
		SponsorPayInfo spInfo = new SponsorPayInfo();
		spInfo.setMemberId("changjae");
		spInfo.setPetNo(6);
		spInfo.setSponsorNo(1);
		System.out.println(dao.selectMemberSponsorNo(spInfo));
		
		
		spInfo.setMemberSponsorNo(dao.selectMemberSponsorNo(spInfo)+1);
		spInfo.setPayMoney(300);
		spInfo.setPayWay(1);
		spInfo.setDepositor("김창재");
		dao.insertMemberSponsorRecord(spInfo);
		
		dao.updatePetSponsorMoney(spInfo);
		
		spInfo.setSponsorReply("후원후원후원후원후원");
		dao.updateMemberSponsorReply(spInfo);
	}
	@Test
	public void getMypageMemberSponsorTest() {
		System.out.println(dao.getMypageMemberSponsor("sponsorDate","desc", 1,10,"hyemi"));
	}
}
