package com.pure.study.member.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.pure.study.member.model.dao.MemberDAO;
import com.pure.study.member.model.vo.Member;

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

	

	

	

	
	
}
