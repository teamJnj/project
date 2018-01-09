package com.icia.jnj.dao;

import java.util.*;

import org.mybatis.spring.*;
import org.springframework.beans.factory.annotation.*;
import org.springframework.stereotype.*;

import com.icia.jnj.vo.*;

@Repository
public class CenterDao {
	@Autowired
	private SqlSessionTemplate tpl;
	
	// =====================================================================
	// 센터 회원 정보 ======================================================
	
	public List<Center> getAllCenter() {
		return tpl.selectList( "centerMapper.getAllCenter" );
	}
	
	public List<Center> getAllPageCenter( int startArticleNum, int endArticleNum ) {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum", endArticleNum);
		return tpl.selectList( "centerMapper.getAllPageCenter",map );
	}
	
	// 아이디 중복확인
	public Center getCenter( String centerId ) {
		return tpl.selectOne( "centerMapper.getCenter", centerId );
	}
	
	//패스워드 얻어오기
	public String getPassword(String centerId) {
		return tpl.selectOne("centerMapper.getPassword", centerId);
	}
	
	// 센터 아이디 찾기에서 대표자이름과 이메일로 select
	public String getCenterId( String licensee, String email ) {
		Map<String,String> map = new HashMap<String,String>();
		map.put("licensee", licensee);
		map.put("email", email);
		return tpl.selectOne( "centerMapper.getCenterId",map );
	}
	
	// 일반 아이디 찾기에서 이름과 이메일로 select
	public String getMemberId( String memberName, String email ) {
		Map<String,String> map = new HashMap<String,String>();
		map.put("memberName", memberName);
		map.put("email", email);
		return tpl.selectOne( "memberMapper.getMemberId",map );
	}
	
	// 센터 비밀번호 찾기에서 센터아이디와 이메일로 select
	public int checkCenterIdAndEmail( String centerId, String email ) {
		Map<String,String> map = new HashMap<String,String>();
		map.put("centerId", centerId);
		map.put("email", email);
		return tpl.selectOne( "centerMapper.checkCenterIdAndEmail",map );
	}
	
	// 센터 회원가입시 아이디 중복체크
	public int checkExistCenterId( String centerId ) {
		System.out.println("센터아중첵디에오");
		return tpl.selectOne( "centerMapper.checkExistCenterId", centerId );
	}
	
	// 센터 회원가입시 이메일 중복체크
	public int checkExistCenterEmail( String email ) {
		return tpl.selectOne( "centerMapper.checkExistCenterEmail", email );
	}
	
	// 센터 업데이트
	public int updateCenter( Map<String, String> map ) {
		return tpl.update( "centerMapper.updateCenter", map );
	}
	
	// 센터정보 업데이트 -창재
	public int updateCenterInfo(Center center) {
		return tpl.update("centerMapper.updateCenterInfo", center);
	}
	
	// 센터 삭제
	public int deleteCenter( String centerId ) {
		return tpl.delete( "centerMapper.deleteCenter", centerId );
	}
	
	// 센터 회원가입 center vo insert
	public void insertCenter( Center center ) {
		System.out.println("센터 회원가입 CENTER 객체 DAO");
		tpl.insert( "centerMapper.insertCenter", center );
	}
	
	// 센터 회원가입 centerImg vo insert
	public void insertCenterImg( CenterImg cim ) {
		System.out.println("센터 회원가입 CTI 객체 DAO");
		tpl.insert("centerMapper.insertCenterImg",cim);
	}
	// 센터 회원가임 authority vo insert
	public void insertAuthority(String centerId, String authority) {
		System.out.println("센터 회원가입 authority 객체 DAO");
		Map<String,String> map = new HashMap<String,String>();
		map.put("id", centerId);
		map.put("authority", authority);
		tpl.insert("centerMapper.insertAuthority", map);
	}
	
	// 보안 테이블에 멤버 insert
	public void insertSUsers(SUsers sUsers) {
		tpl.insert("susersMapper.insertSUsers",sUsers);
	}
	
	// 센터상태 변경
	public int updateCenterState(String centerId, int centerState) {
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("centerId", centerId);
		map.put("centerState", centerState);
		return tpl.update("centerMapper.updateCenterState", map);
	}
	
	
	
	
	
	// 주리
	// 총 center 수
	public int getCountCenter() {
		return tpl.selectOne("centerMapper.getCountCenter");
	}

	// 총 center 수
	public int getSearchCountCenter(String colName, String find) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("colName", colName);
		map.put("find", find);
		System.out.println(colName + " //  " + find);
		return tpl.selectOne("centerMapper.getSearchCountCenter", map);
	}

	// 페이지네이션 10개씩 회원 전체 리스트 읽어오기
	public List<Center> getSearchAllPageCenter(int startArticleNum, int endArticleNum, String colName, String find) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("colName", colName);
		map.put("find", find);
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum", endArticleNum);
		return tpl.selectList("centerMapper.getSearchAllPageCenter", map);
	}

	// 센터 상태별로 총 개수를 가져온다
	public List<Map<String, Integer>> getCenterStateCount() {
		return tpl.selectList("centerMapper.getCenterStateCount");
	}

	// 센터 상태 얻어오기
	public int getCenterState(String centerId) {
		return tpl.selectOne("centerMapper.getCenterState", centerId);
	}

	public int deleteAuthority(String centerId) {
		return tpl.delete("centerMapper.deleteAuthority", centerId);
	}
}
