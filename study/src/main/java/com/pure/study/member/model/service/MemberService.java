package com.pure.study.member.model.service;

import java.util.List;
import java.util.Map;

import com.pure.study.member.model.vo.Instructor;
import com.pure.study.member.model.vo.Member;

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


}
