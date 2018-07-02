package com.pure.study.member.model.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.pure.study.member.model.dao.MemberDAO;
import com.pure.study.member.model.vo.Instructor;
import com.pure.study.member.model.vo.Member;
import com.pure.study.member.model.vo.Review;

@Service
public class MemberServiceImpl implements MemberService {
	
	@Autowired
	MemberDAO memberDAO;
	
	/**********************************/
	@Override
	public int memberEnrollEnd(Member member) {
		System.out.println("?");
		return memberDAO.memberEnrollEnd(member);
	}

	@Override
	public int memberCristal(Member member) {
		return memberDAO.memberCristal(member);
	}

	@Override
	public int checkIdDuplicate(String userId) {
		return memberDAO.checkIdDuplicate(userId);
	}

	@Override
	public int insertMailCertification(String tomail, String ranstr) {
		return memberDAO.insertMailCertification(tomail,ranstr);
	}

	@Override
	public int checkEmail(String tomail) {
		return memberDAO.checkEmail(tomail);
	}

	@Override
	public int uploadMailCertification(String tomail, String encoded) {
		return memberDAO.uploadMailCertification(tomail,encoded);
	}

	@Override
	public Map<String, String> selectCheckJoinCode(String email) {
		return memberDAO.selectCheckJoinCode(email);
	}

	@Override
	public int deleteCertification(String email) {
		return memberDAO.deleteCertification(email);
	}

	@Override
	public List<Map<String, String>> selectCategory() {
		return memberDAO.selectCategory();
	}
	/**********************************/
	
	

	@Override
	public Member selectOneMember(String userId) {
		return memberDAO.selectOneMember(userId);
	}

	@Override
	public Member selectOneMember(Member fm) {
		return memberDAO.selectOneMember(fm);
	}

	@Override
	public int updatePwd(Member changeM) {
		return memberDAO.updatePwd(changeM);
	}

	@Override
	public int selectCntMember(Member m) {
		return memberDAO.selectCntMember(m);
	}

	@Override
	public int updateMember(Member member) {
		return memberDAO.updateMember(member);
	}

	@Override
	public int dropMember(String mid) {
		return memberDAO.dropMember(mid);
	}

	@Override
	public int updateEmail(Member m) {
		return memberDAO.updateEmail(m);
	}

	@Override
	public List<Map<String, String>> selectApplyList(Map<String, String> map, int numPerPage, int cPage) {
		return memberDAO.selectApplyList(map, numPerPage, cPage);
	}
	
	@Override
	public int selectApplyListCnt(Map<String, String> map) {
		return memberDAO.selectApplyListCnt(map);
	}
	

	@Override
	public List<Map<String, String>> selectWishList(Map<String, String> map, int numPerPage, int cPage) {
		return memberDAO.selectWishList(map, numPerPage, cPage);
	}

	@Override
	public int selectWishListCnt(Map<String, String> map) {
		return memberDAO.selectWishListCnt(map);
	}

	@Override
	public List<Map<String, String>> selectMyStudyList(Map<String, String> map, int numPerPage, int cPage) {
		return memberDAO.selectMyStudyList(map, numPerPage, cPage);
	}

	@Override
	public int selectMyStudyListCnt(Map<String, String> map) {
		return memberDAO.selectMyStudyListCnt(map);
	}

	@Override
	public List<Map<String, String>> selectKind() {
		return memberDAO.selectKind();
	}

	@Override
	public List<Map<String, String>> serviceagree() {
		return memberDAO.serviceagree();
	}

	@Override
	public List<Map<String, String>> informationagree() {
		return memberDAO.informationagree();
	}

	@Override
	public List<Map<String, String>> selectLeaderList(Map<String, String> map, int numPerPage, int cPage) {
		return memberDAO.selectLeaderList(map,numPerPage, cPage);
	}

	@Override
	public int selectLeaderListCnt(Map<String, String> map) {
		return memberDAO.selectLeaderListCnt(map);
	}

	@Override
	public List<Map<String, Object>> reviewEnrollView(String studyNo) {
		return memberDAO.reviewEnrollView(studyNo);
	}

	@Override
	public List<Map<String, Object>> leaderReviewEnrollView(String studyNo) {
		return memberDAO.leaderReviewEnrollView(studyNo);
	}

	
	@Override
	public int memberCheckEmail(String em) {
		return memberDAO.memberCheckEmail(em);
	}

	@Override
	public Member memberGetPoint(String email) {
		return memberDAO.memberGetPoint(email);
	}

	@Override
	public int instructorEnrollEnd(Instructor instructor) {
		return memberDAO.instructorEnrollEnd(instructor);
	}

	@Override
	public int instructorCheckEmail(Map<String, String> checkInstructor) {
		System.out.println("checkInstructor : "+checkInstructor);
		int result =memberDAO.instructorCheckEmail(checkInstructor);
		System.out.println(result);
		if(result==1) {
			result += memberDAO.instructorApproval(checkInstructor);			
		}
		System.out.println("result : "+result);
		return result;
	}

	@Override
	public int instructorCheckX(int mno) {
		return memberDAO.instructorCheckX(mno);
	}

	@Override
	public int updateInstructorEnrollEnd(Instructor instructor) {
		return memberDAO.updateInstructorEnrollEnd(instructor);
	}

	
	@Override
	public List<Map<String, Object>> selectInstructorMember(int cPage, int count) {
		return memberDAO.selectInstructorMember(cPage, count);
	}

	@Override
	public int selectCntInstructorMember() {
		return memberDAO.selectCntInstructorMember();
	}

	@Override
	public List<Map<String, Object>> selectAllMemberList(int cPage, int count) {
		return memberDAO.selectAllMemberList(cPage, count);
	}

	@Override
	public int selectCntAllMemberList() {
		return memberDAO.selectCntAllMemberList();
	}
	
	@Override
	public int instructorCheckO(int mno) {
		return memberDAO.instructorCheckO(mno);
	}

	@Override
	public int updateScontent(Map<String, String> scont) {
		return memberDAO.updateScontent(scont);
	}

	@Override
	public int updateIcontent(Map<String, String> icont) {
		return memberDAO.updateIcontent(icont);
	}

	@Override
	public int deleteScontent(String sno) {
		return memberDAO.deleteScontent(sno);
	}

	@Override
	public int insertScontent(String scontent) {
		return memberDAO.insertScontent(scontent);
	}

	@Override
	public int insertIcontent(String icontent) {
		return memberDAO.insertIcontent(icontent);
	}

	@Override
	public int deleteIcontent(String ino) {
		return memberDAO.deleteIcontent(ino);
	}

	@Override
	public List<Map<String, Object>> selectMemberList() {
		return memberDAO.selectMemberList();
	}

	@Override
	public int changOneEXP(Map<String, String> expMap) {
		return memberDAO.changOneEXP(expMap);
	}

	@Override
	public int changEXPPLUS(Map<String, String> expMap) {
		return memberDAO.changEXPPLUS(expMap);
	}

	@Override
	public Map<String, String> getExp(Map<String, String> expMap) {
		return memberDAO.getExp(expMap);
	}

	@Override
	public int changEXPMINUS(Map<String, String> expMap) {
		return memberDAO.changEXPMINUS(expMap);
	}

	@Override
	public int changPOINTPLUS(Map<String, String> expMap) {
		return memberDAO.changPOINTPLUS(expMap);
	}

	@Override
	public Map<String, String> getPoint(Map<String, String> expMap) {
		return memberDAO.getPoint(expMap);
	}

	@Override
	public int changPOINTMINUS(Map<String, String> expMap) {
		return memberDAO.changPOINTMINUS(expMap);
	}
	
	@Override
	public int changNPOINTPLUS(Map<String, String> expMap) {
		return memberDAO.changNPOINTPLUS(expMap);
	}

	@Override
	public Map<String, String> getNPoint(Map<String, String> expMap) {
		return memberDAO.getNPoint(expMap);
	}

	@Override
	public int changNPOINTMINUS(Map<String, String> expMap) {
		return memberDAO.changNPOINTMINUS(expMap);
	}
	
	@Override
	public int reviewEnroll(Map<String,Object> map) {
		return memberDAO.reviewEnroll(map);
	}

	@Override
	public List<Integer> reviewFinish(Map<String, Object> map) {
		return memberDAO.reviewFinish(map);
	}

	@Override
	public int updateMemberExp(Map<String,Object> map) {
		return memberDAO.updateMemberExp(map);
	}

	@Override
	public List<Map<String, Object>> reviewList(Map<String, Object> listMap) {
		return memberDAO.reviewList(listMap);
	}

	@Override
	public String selectStudyName(String studyNo) {
		return memberDAO.selectStudyName(studyNo);
	}

	@Override
	public int insertCrew(Map<String, String> map) {
		return memberDAO.insertCrew(map);
	}

	@Override
	public int deleteApply(Map<String, String> map) {
		return memberDAO.deleteApply(map);
	}

	@Override
	public int selectCntEmail(String newEmail) {
		return memberDAO.selectCntEmail(newEmail);
	}

	@Override
	public int deleteCrew(Map<String, String> map) {
		return memberDAO.deleteCrew(map);
	}

	@Override
	public int insertApply(Map<String, String> map) {
		return memberDAO.insertApply(map);
	}

	@Override
	public List<Map<String, Object>> giveReviewList(Map<String, Object> listMap) {
		return memberDAO.giveReviewList(listMap);
	}

	@Override
	public Map<String, Object> searchEvaluation(Map<String, Object> map) {
		return memberDAO.searchEvaluation(map);
	}

	@Override
	public List<Map<String, Object>> selectGradeList() {
		return memberDAO.selectGradeList();
	}

	public int adminInnerCheck(Map<String, String> urlname) {
		return memberDAO.adminInnerCheck(urlname);
	}

	@Override
	public int selectInnerAdmin(Map<String, String> link) {
		return memberDAO.selectInnerAdmin(link);
	}

	@Override
	public List<Map<String, String>> selectMemberReviewList(int mno) {
		return memberDAO.selectMemberReviewList(mno);
	}

	@Override
	public List<Map<String, Object>> selectmemberReply(int mno) {
		return memberDAO.selectmemberReply(mno);
	}

	@Override
	public List<Map<String, Object>> selectInstructorMemberOX() {
		return memberDAO.selectInstructorMemberOX();
	}

	@Override
	public Map<String, String> selectOneInstruct(int mno) {
		return memberDAO.selectOneInstruct(mno);
	}

	@Override
	public void updateInstructorApply(int ino) {
		memberDAO.updateInstructorApply(ino);
	}
	
}
