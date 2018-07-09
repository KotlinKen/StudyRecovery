package com.pure.study.member.model.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.pure.study.member.model.vo.Instructor;
import com.pure.study.member.model.vo.Member;
import com.pure.study.member.model.vo.Review;

@Repository
public class MemberDAOImpl implements MemberDAO {
	@Autowired
	SqlSessionTemplate sqlSession;
	
	/**************************************/
	@Override
	public int memberEnrollEnd(Member member) {
		System.out.println(member);
		return sqlSession.insert("member.memberEnrollEnd",member);
	}
	
	@Override
	public int memberCristal(Member member) {
		return sqlSession.update("member.memberCristal",member);
	}
	@Override
	public int checkIdDuplicate(String userId) {
		return sqlSession.selectOne("member.checkIdDuplicate",userId);
	}
	@Override
	public int insertMailCertification(String tomail, String ranstr) {
		Map <String,String> map = new HashMap<>();
		map.put("tomail", tomail);
		map.put("ranstr", ranstr);
		return sqlSession.insert("member.insertMailCertification",map);
	}
	@Override
	public int checkEmail(String tomail) {
		return sqlSession.selectOne("member.checkEmail",tomail);
	}
	@Override
	public int uploadMailCertification(String tomail, String encoded) {
		Map <String,String> map = new HashMap<>();
		map.put("tomail", tomail);
		map.put("encoded", encoded);
		return sqlSession.update("member.uploadMailCertification",map);
	}
	@Override
	public Map<String, String> selectCheckJoinCode(String email) {
		return sqlSession.selectOne("member.selectCheckJoinCode",email);
	}

	@Override
	public int deleteCertification(String email) {
		return sqlSession.delete("member.deleteCertification",email);
	}

	@Override
	public List<Map<String, String>> selectCategory() {
		return sqlSession.selectList("member.selectCategory");
	}
	
	/**************************************/
	
	@Override
	public Member selectOneMember(String userId) {
		return sqlSession.selectOne("member.selectOneMember", userId);
	}

	@Override
	public Member selectOneMember(Member fm) {
		return sqlSession.selectOne("member.selectOneMemberId",fm);
	}

	@Override
	public int updatePwd(Member changeM) {
		return sqlSession.update("member.updatePwd",changeM);
	}

	@Override
	public int selectCntMember(Member m) {
		return sqlSession.selectOne("member.selectCntMember", m);
	}

	@Override
	public int updateMember(Member member) {
		return sqlSession.update("member.updateMember", member);
	}

	@Override
	public int dropMember(String mid) {
		return sqlSession.update("member.dropMember", mid);
	}

	@Override
	public int updateEmail(Member m) {
		return sqlSession.update("member.updateEmail", m);

	}

	@Override
	public List<Map<String, String>> selectApplyList(Map<String, String> map, int numPerPage, int cPage) {
		return sqlSession.selectList("member.selectApplyList", map, new RowBounds(numPerPage*(cPage-1),numPerPage));
	}

	@Override
	public int selectApplyListCnt(Map<String, String> map) {
		return sqlSession.selectOne("member.selectApplyListCnt", map);
	}
	@Override
	public List<Map<String, String>> selectWishList(Map<String, String> map, int numPerPage, int cPage) {
		return sqlSession.selectList("member.selectWishList", map, new RowBounds(numPerPage*(cPage-1),numPerPage));
	}

	@Override
	public int selectWishListCnt(Map<String, String> map) {
		return sqlSession.selectOne("member.selectWishListCnt", map);
	}

	@Override
	public List<Map<String, String>> selectMyStudyList(Map<String, String> map, int numPerPage, int cPage) {
		return sqlSession.selectList("member.selectMyStudyList", map, new RowBounds(numPerPage*(cPage-1),numPerPage));
	}

	@Override
	public int selectMyStudyListCnt(Map<String, String> map) {
		return sqlSession.selectOne("member.selectMyStudyListCnt", map);
	}

	@Override
	public List<Map<String, String>> selectKind() {
		return sqlSession.selectList("member.selectKind");
	}
	
	@Override
	public List<Map<String, String>> serviceagree() {
		return sqlSession.selectList("member.serviceagree");
	}
	
	@Override
	public List<Map<String, String>> informationagree() {
		return sqlSession.selectList("member.informationagree");
	}

	@Override
	public List<Map<String, String>> selectLeaderList(Map<String, String> map, int numPerPage, int cPage) {
		return sqlSession.selectList("member.selectLeaderList", map, new RowBounds(numPerPage*(cPage-1),numPerPage));
	}

	@Override
	public int selectLeaderListCnt(Map<String, String> map) {
		return sqlSession.selectOne("member.selectLeaderListCnt",map);
	}

	@Override
	public List<Map<String, Object>> reviewEnrollView(String studyNo) {
		return sqlSession.selectList("member.reviewEnrollView", studyNo);
	}

	@Override
	public List<Map<String, Object>> leaderReviewEnrollView(String studyNo) {
		return sqlSession.selectList("member.leaderReviewEnrollView", studyNo);
	}

	public int memberCheckEmail(String emil) {
		System.out.println(emil);
		return sqlSession.selectOne("member.memberCheckEmail",emil);
	}

	@Override
	public Member memberGetPoint(String email) {
		
		return sqlSession.selectOne("member.memberGetPoint", email);
	}

	@Override
	public int instructorEnrollEnd(Instructor instructor) {
	
		return sqlSession.insert("member.instructorEnrollEnd",instructor);
	}

	@Override
	public int instructorCheckEmail(Map<String, String> checkInstructor) {
		return sqlSession.selectOne("member.instructorCheckEmail", checkInstructor);
	}

	@Override
	public int instructorApproval(Map<String, String> checkInstructor) {
		return sqlSession.selectOne("member.instructorApproval", checkInstructor);
	}

	@Override
	public int instructorCheckX(int mno) {
		return sqlSession.selectOne("member.instructorCheckX",mno);
	}

	@Override
	public int updateInstructorEnrollEnd(Instructor instructor) {
		return sqlSession.update("member.updateInstructorEnrollEnd", instructor);
	}

	@Override
	public int reviewEnroll(Map<String,Object> map) {
		return sqlSession.insert("member.reviewEnroll", map);
	}

	@Override
	public List<Integer> reviewFinish(Map<String, Object> map) {
		return sqlSession.selectList("member.reviewFinish", map);
	}

	@Override
	public int updateMemberExp(Map<String,Object> map) {
		return sqlSession.update("member.updateMemberExp", map);
	}

	@Override
	public List<Map<String, Object>> reviewList(Map<String, Object> listMap) {
		return sqlSession.selectList("member.reviewList", listMap);
	}

	@Override
	public String selectStudyName(String studyNo) {
		return sqlSession.selectOne("member.selectStudyName", studyNo);
	}

	@Override
	public int insertCrew(Map<String, String> map) {
		return sqlSession.insert("member.insertCrew", map);
	}

	@Override
	public int deleteApply(Map<String, String> map) {
		return sqlSession.insert("member.deleteApply", map);
	}
	
	
	
	@Override
	public List<Map<String, Object>> selectInstructorMember(int cPage, int count) {
		return sqlSession.selectList("member.selectInstructorMember", null, new RowBounds(count*(cPage-1),count));
	}

	@Override
	public int selectCntInstructorMember() {
		return sqlSession.selectOne("member.selectCntInstructorMember");
	}

	@Override
	public List<Map<String, Object>> selectAllMemberList(int cPage, int count) {
		return sqlSession.selectList("member.selectAllMemberList", null, new RowBounds(count*(cPage-1),count));
	}

	@Override
	public int selectCntAllMemberList() {
		return sqlSession.selectOne("member.selectCntAllMemberList");
	}
	@Override
	public int instructorCheckO(int mno) {
		return sqlSession.selectOne("member.instructorCheckO",mno);
	}

	@Override
	public int updateScontent(Map<String, String> scont) {
		System.out.println(scont);
		return sqlSession.update("member.updateScontent", scont);
	}

	@Override
	public int updateIcontent(Map<String, String> icont) {
		System.out.println(icont);
		return sqlSession.update("member.updateIcontent", icont);
	}

	@Override
	public int deleteScontent(String sno) {
		return sqlSession.delete("member.deleteScontent",sno);
	}

	@Override
	public int insertScontent(String scontent) {
		return sqlSession.insert("member.insertScontent", scontent);
	}

	@Override
	public int insertIcontent(String icontent) {
		return sqlSession.insert("member.insertIcontent", icontent);
	}

	@Override
	public int deleteIcontent(String ino) {
		return sqlSession.delete("member.deleteIcontent", ino);
	}

	@Override
	public List<Map<String, Object>> selectMemberList() {
		return sqlSession.selectList("member.selectMemberList");
	}

	@Override
	public int changOneEXP(Map<String, String> expMap) {
		return sqlSession.update("member.changOneEXP", expMap);
	}

	@Override
	public int changEXPPLUS(Map<String, String> expMap) {
		return sqlSession.update("member.changEXPPLUS", expMap);
	}

	@Override
	public Map<String, String> getExp(Map<String, String> expMap) {
		return sqlSession.selectOne("member.getExp", expMap);
	}

	@Override
	public int changEXPMINUS(Map<String, String> expMap) {
		return sqlSession.update("member.changEXPMINUS", expMap);
	}

	@Override
	public int changPOINTPLUS(Map<String, String> expMap) {
		return sqlSession.update("member.changPOINTPLUS", expMap);
	}

	@Override
	public Map<String, String> getPoint(Map<String, String> expMap) {
		return sqlSession.selectOne("member.getPoint", expMap);
	}

	@Override
	public int changPOINTMINUS(Map<String, String> expMap) {
		return sqlSession.update("member.changPOINTMINUS", expMap);
	}
	
	@Override
	public int changNPOINTPLUS(Map<String, String> expMap) {
		return sqlSession.update("member.changNPOINTPLUS", expMap);
	}
	
	@Override
	public Map<String, String> getNPoint(Map<String, String> expMap) {
		return sqlSession.selectOne("member.getNPoint", expMap);
	}
	
	@Override
	public int changNPOINTMINUS(Map<String, String> expMap) {
		return sqlSession.update("member.changNPOINTMINUS", expMap);
	}

	@Override
	public int adminInnerCheck(Map<String, String> urlname) {
		return sqlSession.update("member.adminInnerCheck", urlname);
	}

	@Override
	public int selectInnerAdmin(Map<String, String> link) {
		System.out.println(link);
		return sqlSession.selectOne("member.selectInnerAdmin" ,link);
	}

	@Override

	public List<Map<String, String>> selectMemberReviewList(int mno) {
		return sqlSession.selectList("member.selectMemberReviewList", mno);
	}
	public int selectCntEmail(String newEmail) {
		Map<String,String> map = new HashMap<>();
		map.put("newEmail", newEmail);
		return sqlSession.selectOne("member.selectCntEmail", map);
	}

	@Override
	public int deleteCrew(Map<String, String> map) {
		return sqlSession.delete("member.deleteCrew", map);
	}

	@Override
	public int insertApply(Map<String, String> map) {
		return sqlSession.insert("member.insertApply", map);
	}

	@Override
	public List<Map<String, Object>> giveReviewList(Map<String, Object> listMap) {
		return sqlSession.selectList("member.giveReviewList", listMap);
	}

	@Override
	public Map<String, Object> searchEvaluation(Map<String, Object> map) {
		return sqlSession.selectOne("member.searchEvaluation", map);
	}

	@Override
	public List<Map<String, Object>> selectGradeList() {
		return sqlSession.selectList("member.selectGradeList");
	}

	@Override
	public int updateNpoint(Map<String, Object> map) {
		return sqlSession.update("member.updateNpoint", map);
	}

	@Override
	public Member selectOneMemberMno(int mno) {
		return sqlSession.selectOne("member.selectOneMemberMno",mno);
	}

	public List<Map<String, Object>> selectmemberReply(int mno) {
		return sqlSession.selectList("member.selectmemberReply",mno);
	}

	@Override
	public List<Map<String, Object>> selectInstructorMemberOX() {
		return sqlSession.selectList("member.selectInstructorMemberOX");
	}

	@Override
	public Map<String, String> selectOneInstruct(int mno) {
		return sqlSession.selectOne("member.selectOneInstruct", mno);
	}

	@Override
	public int updateInstructorApply(int ino) {
		System.out.println(ino);
	/*	Map<String,Integer> map = new HashMap<>();
		map.put("ino", ino);
		System.out.println(map);*/
		return sqlSession.update("member.updateInstructorApply", ino);
		
	}

	@Override
	public int updateInstructorCancel(int ino) {
		return sqlSession.update("member.updateInstructorCancel", ino);
	}

	@Override
	public List<Map<String, Object>> selectEvalList(Map<String, Object> map, int numPerPage, int cPage) {
		return sqlSession.selectList("member.selectEvalList",map, new RowBounds(numPerPage*(cPage-1),numPerPage));
	}

	@Override
	public int selectEvalCnt(Map<String, Object> map) {
		return sqlSession.selectOne("member.selectEvalCnt",map);
	}

	@Override
	public List<Map<String, String>> selectPayList(Map<String, Object> map, int numPerPage, int cPage) {
		return sqlSession.selectList("member.selectPayList",map, new RowBounds(numPerPage*(cPage-1),numPerPage));
	}

	@Override
	public int selectPayList(Map<String, Object> map) {
		return sqlSession.selectOne("member.selectPayListCnt",map);
	}
	@Override
	public List<Map<String, String>> memberSearch(Map<String, String> queryMap) {
		return sqlSession.selectList("member.memberSearch", queryMap);
	}

	
	
}