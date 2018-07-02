package com.pure.study.member.model.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.pure.study.member.model.vo.Instructor;
import com.pure.study.member.model.vo.Member;
import com.pure.study.member.model.vo.Review;

public interface MemberService {
	
	/****************************************/
	
	int memberEnrollEnd(Member member);

	int memberCristal(Member member);

	int checkIdDuplicate(String userId);

	int insertMailCertification(String tomail, String ranstr);

	int checkEmail(String tomail);

	int uploadMailCertification(String tomail, String encoded);

	Map<String, String> selectCheckJoinCode(String email);

	int deleteCertification(String email);

	List<Map<String, String>> selectCategory();
	/****************************************/

	Member selectOneMember(String userId);

	Member selectOneMember(Member fm);

	int updatePwd(Member changeM);

	int selectCntMember(Member equalM);

	int updateMember(Member member);
	
	int dropMember(String mid);

	int updateEmail(Member m);

	List<Map<String, String>> selectKind();
	
	List<Map<String, String>> serviceagree();

	List<Map<String, String>> informationagree();

	List<Map<String, String>> selectMyStudyList(Map<String, String> map, int numPerPage, int cPage);

	int selectMyStudyListCnt(Map<String, String> map);

	int selectApplyListCnt(Map<String, String> map);

	List<Map<String, String>> selectApplyList(Map<String, String> map, int numPerPage, int cPage);

	List<Map<String, String>> selectWishList(Map<String, String> map, int numPerPage, int cPage);

	int selectWishListCnt(Map<String, String> map);

	List<Map<String, String>> selectLeaderList(Map<String, String> map, int numPerPage, int cPage);

	int selectLeaderListCnt(Map<String, String> map);
	
	int memberCheckEmail(String em);

	Member memberGetPoint(String email);

	int instructorEnrollEnd(Instructor instructor);

	int instructorCheckEmail(Map<String, String> checkInstructor);

	int instructorCheckX(int mno);

	int updateInstructorEnrollEnd(Instructor instructor);
	
	
	List<Map<String, Object>> selectInstructorMember(int cPage, int count);

	int selectCntInstructorMember();

	List<Map<String, Object>> selectAllMemberList(int cPage, int count);

	int selectCntAllMemberList();

	int instructorCheckO(int mno);

	int updateScontent(Map<String, String> scont);

	int updateIcontent(Map<String, String> icont);

	int deleteScontent(String sno);

	int insertScontent(String scontent);

	int insertIcontent(String icontent);

	int deleteIcontent(String ino);

	List<Map<String, Object>> selectMemberList();

	int changOneEXP(Map<String, String> expMap);

	int changEXPPLUS(Map<String, String> expMap);

	Map<String, String> getExp(Map<String, String> expMap);

	int changEXPMINUS(Map<String, String> expMap);

	int changPOINTPLUS(Map<String, String> expMap);

	Map<String, String> getPoint(Map<String, String> expMap);

	int changPOINTMINUS(Map<String, String> expMap);
	
	int changNPOINTPLUS(Map<String, String> expMap);
	
	Map<String, String> getNPoint(Map<String, String> expMap);
	
	int changNPOINTMINUS(Map<String, String> expMap);


	List<Map<String, Object>> reviewEnrollView(String studyNo);

	List<Map<String, Object>> leaderReviewEnrollView(String studyNo);

	int reviewEnroll(Map<String, Object> map);

	List<Integer> reviewFinish(Map<String, Object> map);

	int updateMemberExp(Map<String, Object> map);

	List<Map<String, Object>> reviewList(Map<String, Object> listMap);

	String selectStudyName(String studyNo);

	int insertCrew(Map<String, String> map);

	int deleteApply(Map<String, String> map);

	int selectCntEmail(String newEmail);

	int deleteCrew(Map<String, String> map);

	int insertApply(Map<String, String> map);

	List<Map<String, Object>> giveReviewList(Map<String, Object> listMap);

	Map<String, Object> searchEvaluation(Map<String, Object> map);

	List<Map<String, Object>> selectGradeList();
	
	int adminInnerCheck(Map<String, String> link);

	int selectInnerAdmin(Map<String, String> link);
	
	int updateNpoint(Map<String,Object> map);
	
	Member selectOneMemberMno(int mno);

	List<Map<String, String>> selectMemberReviewList(int mno);

	List<Map<String, Object>> selectmemberReply(int mno);

	List<Map<String, Object>> selectInstructorMemberOX();

	Map<String, String> selectOneInstruct(int mno);

	void updateInstructorApply(int ino);

}
