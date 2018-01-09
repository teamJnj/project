package com.icia.jnj.test;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

import com.icia.jnj.dao.AdoptDao;
import com.icia.jnj.dao.SponsorDao;
import com.icia.jnj.domain.SponsorPayInfo;

@RunWith( SpringJUnit4ClassRunner.class )
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/**/*-context.xml")
public class AdoptDaoTest {
	@Autowired
	private SqlSessionTemplate tpl;
	
	@Autowired
	private AdoptDao dao;
	
	//입양 내역 가져오기
	//@Test
	public void getMypageMemberAdoptTest() {
		System.out.println(dao.getMypageMemberAdopt("test1234", 1,5));
	}
	//입양 취소시 동물 상태 취소로
	@Test
	public void updatePetStateAdoptCancleTest() {
		System.out.println();
	}
	
	
}
