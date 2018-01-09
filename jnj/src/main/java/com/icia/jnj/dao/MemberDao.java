package com.icia.jnj.dao;

import java.util.*;

import org.mybatis.spring.*;
import org.springframework.beans.factory.annotation.*;
import org.springframework.stereotype.*;

import com.icia.jnj.vo.*;

@Repository
public class MemberDao {
	
	@Autowired
	private SqlSessionTemplate tpl;
	
	// =====================================================================
	// 일반 회원 관련 ======================================================
	
	// member있는가
	public int isMember(Volunteer volunteer) {
		return tpl.selectOne( "memberMapper.isMember", volunteer );
	}
	
	// 총 member 수
	public int getCountMember() {
		return tpl.selectOne("memberMapper.getCountMember");
	}
	
	// 한명의 회원 정보 읽어오기
	public Member getMemeber(String memberId) {
		return tpl.selectOne("memberMapper.getMemeber", memberId);
	}
	
	// 검색 한 내용의 총 개수를 읽어온다.
	public int getSearchCountMember(String colName, String find) {
		Map<String,String> map = new HashMap<String,String>();
		map.put("colName", colName);
		map.put("find", find);
		return tpl.selectOne( "memberMapper.getSearchCountMember", map );
	}
	
	
	
	// 페이지네이션없이 회원 전체 목록 읽어오기
	public List<Member> getAllMember(){
		return tpl.selectList( "memberMapper.getAllMember" );
	}
	
	
	// 페이지네이션 10개씩 회원 전체 리스트 읽어오기
	public List<Member> getAllPageMember( int startArticleNum, int endArticleNum ) {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("startArticleNum", startArticleNum);
		map.put("endArticleNum", endArticleNum);
		return tpl.selectList( "memberMapper.getAllPageMember", map );
	}
	
	// 페이지네이션 10개씩 회원 전체 리스트 읽어오기
		public List<Member> getSearchAllPageMember( int startArticleNum, int endArticleNum, String colName, String find ) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("colName", colName);
			map.put("find", find);
			map.put("startArticleNum", startArticleNum);
			map.put("endArticleNum", endArticleNum);
			return tpl.selectList( "memberMapper.getSearchAllPageMember", map );
		}

	// 아이디 찾기 : 이름과 이메일로 아이디 찾기
	public String getMemberId( String memberName, String email ) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("memberName", memberName);
		map.put("email", email);
		return tpl.selectOne( "memberMapper.getMemberId", map );
	}
	
	// 비밀번호 찾기 : 아이디랑 이메일이 존재하는지 체크
	public int checkMemberIdAndEmail( String memberId, String email ) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("memberId", memberId);
		map.put("email", email);
		return tpl.selectOne( "memberMapper.checkMemberIdAndEmail", map );
	}
	
	
	// 아이디가 존재하는지 체크
	public int checkExistMemberId( String memberId ) {
		System.out.println("memberId디에오");
		return tpl.selectOne( "memberMapper.checkExistMemberId", memberId );
	}
	
	
	// 이메일이 존재하는지 체크
	public int checkExistMemberEmail( String email ) {
		System.out.println("email디에오");
		return tpl.selectOne( "memberMapper.checkExistMemberEmail", email );
	}
	
	
	// 멤버 추가하기
	public void insertMember( Member member ) {
		tpl.insert( "memberMapper.insertMember", member );
	}
	
	
	// 멤버 정보 업데이트하기
	public int updateMember( Map<String, String> map) {
		return tpl.update( "memberMapper.updateMember", map );
	}
	
	// 멤버 삭제하기
	public int deleteMember(String memberId) {
		return tpl.delete( "memberMapper.deleteMember", memberId );
	}
	
	// 멤버 삭제를 위한 비밀번호 찾기
	public String getPassword(String memberId) {
		return tpl.selectOne("memberMapper.getPassword",memberId);
	}
	
	// 권한 삭제
	public int deleteAuthority(String memberId) {
		return tpl.delete( "memberMapper.deleteAuthority", memberId );
	}
	
	// 멤버 상태 업데이트
	public int updateMemberState(String memberId, int memberState) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberId", memberId);
		map.put("memberState", memberState);
		return tpl.update("memberMapper.updateMemberState", map);
	}

	// 멤버 회원가입 authority vo insert
	public void insertAuthority(String memberId, String authority) {
		System.out.println("센터 회원가입 authority 객체 DAO");
		Map<String,String> map = new HashMap<String,String>();
		map.put("id", memberId);
		map.put("authority", authority);
		tpl.insert("memberMapper.insertAuthority", map);
	}

	// 보안 테이블에 멤버 insert
	public void insertSUsers(SUsers sUsers) {
		tpl.insert("susersMapper.insertSUsers",sUsers);
	}
	
	public List<Map<String,Integer>> getMembetStateCount(){
		return tpl.selectList("memberMapper.getMembetStateCount");
	}
	
	//혜미
	//멤버 상태 가져오기
	public int getMemberState(String memberId) {
		return tpl.selectOne("memberMapper.getMemberState", memberId);
	}
	
	//수안
	//멤버 AUTHORITIES 확인하기
	public String getMemberAuthority(String memberId) {
		return tpl.selectOne("memberMapper.getMemberAuthority", memberId);
	}

}
