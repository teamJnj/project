package com.icia.jnj.dao;

import java.util.*;

import org.mybatis.spring.*;
import org.springframework.beans.factory.annotation.*;
import org.springframework.stereotype.*;

import com.icia.jnj.vo.SUsers;


@Repository
public class SUsersDao {
	@Autowired
	private SqlSessionTemplate tpl;
	
	// 센터 업데이트
	public int updatePassword(String id, String password) {
		Map<String, String> map = new HashMap<String, String>();
		
		map.put("password", password);
		map.put("id", id);
		
		return tpl.update( "susersMapper.updatePassword", map );
	}
	
	// 보안테이블에서 회원 정보를 삭제한다.
	public int deleteSUsers( String id ) {
		return tpl.delete( "susersMapper.deleteSUsers", id );
	}
	
	// 아이디로 user 찾기
	public SUsers getUsers(String id) {
		return tpl.selectOne("susersMapper.getUsers", id );
	}
}
