package com.icia.jnj.test;

import org.junit.Test;
import org.junit.runner.*;
import org.mybatis.spring.*;
import org.springframework.beans.factory.annotation.*;
import org.springframework.test.context.*;
import org.springframework.test.context.junit4.*;

import com.icia.jnj.dao.*;
import com.icia.jnj.vo.Pet;
import com.icia.jnj.vo.PetImg;

@RunWith( SpringJUnit4ClassRunner.class )
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/**/*-context.xml")
public class PetDaoTest {
	@Autowired
	private SqlSessionTemplate tpl;
	@Autowired
	private PetDao dao;
	
//	@Test
	public void tplTest() {
		System.out.println( tpl == null );
	}
	
//	@Test
	public void getPetNumTest() {
		System.out.println(dao.getPetNum("center1"));
	}
	
//	@Test
	public void listTest() {
		System.out.println(dao.list(2, 5, "center1", 1));
	}
	
//	@Test
	public void insertPetTest() {
		Pet pet = new Pet();
		pet.setPetNo(dao.getPetNoSeq());
		pet.setPetName("호돌이");
		pet.setPetSort(3);
		pet.setKind("백두산호랑이");
		pet.setGender(1);
		pet.setNeutral(false);
		pet.setAge(30);
		pet.setWeight(88);
//		pet.setDisease("피부가 파랗게 질림");
		pet.setFeature("상모를 잘돌려요");
		pet.setMercyDate("2018-06-08");
		pet.setCenterId("center2");
		
		System.out.println(dao.insertPet(pet));
		
		
		PetImg petImg = new PetImg();
		petImg.setPetNo(pet.getPetNo());
		petImg.setPetImgNo(1);
		petImg.setPetImg("호돌이.jpg");
		System.out.println(dao.insertPetImg(petImg));
	}
	
//	@Test
	public void updatePetTest() {
		Pet pet = new Pet();
		pet.setPetNo(20);
		pet.setPetName("호돌이");
		pet.setPetSort(3);
		pet.setKind("백두산호랑이");
		pet.setGender(1);
		pet.setNeutral(false);
		pet.setAge(30);
		pet.setWeight(88);
//		pet.setDisease("피부가 파랗게 질림");
		pet.setFeature("상모를 잘돌려요");
		pet.setMercyDate("2018-06-08");
		pet.setCenterId("center2");
		
		System.out.println(dao.insertPet(pet));
		
		
		PetImg petImg = new PetImg();
		petImg.setPetNo(pet.getPetNo());
		petImg.setPetImgNo(1);
		petImg.setPetImg("호돌이.jpg");
		System.out.println(dao.insertPetImg(petImg));
	}
}