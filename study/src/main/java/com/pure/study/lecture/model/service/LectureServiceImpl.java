package com.pure.study.lecture.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.pure.study.lecture.model.dao.LectureDAO;
import com.pure.study.lecture.model.vo.Lecture;

@Service
public class LectureServiceImpl implements LectureService {
	@Autowired
	private LectureDAO ld;

	@Override
	public List<Map<String, String>> selectLocList() {
		return ld.selectLocList();
	}

	@Override
	public List<Map<String, Object>> selectTownList(int localNo) {
		return ld.selectTownList(localNo);
	}

	@Override
	public List<Map<String, String>> selectKindList() {
		return ld.selectKindList();
	}
	
	@Override
	public List<Map<String, String>> selectDiff() {
		return ld.selectDiffList();
	}

	@Override
	public List<Map<String, Object>> selectSubList(int kindNo) {
		return ld.selectSubList(kindNo);
	}

	@Override
	public int insertLecture(Lecture lecture) {
		return ld.insertLecture(lecture);
	}

	@Override
	public List<Map<String, Object>> selectLectureList(int cPage, int numPerPage) {
		return ld.selectLectureList(cPage, numPerPage);
	}

	@Override
	public Map<String, String> selectLectureOne(int sno) {
		return ld.selectLectureOne(sno);
	}

	@Override
	public int deleteLecture(int sno) {
		return ld.deleteLecture(sno);
	}

	@Override
	public int applyLecture(Map<String, Integer> map) {
		return ld.applyLecture(map);
	}

	@Override
	public int preinsertApply(Map<String, Integer> map) {
		return ld.preinsertApply(map);
	}

	@Override
	public int selectTotalLectureCount() {
		return ld.selectTotalLectureCount();
	}

	@Override
	public int selectTotalLectureCountBySearch(Map<String, Object> map) {
		return ld.selectTotalLectureCountBySearch(map);
	}

	@Override
	public List<Map<String, Object>> selectLectureListBySearch(Map<String, Object> terms) {
		// TODO Auto-generated method stub
		return ld.selectLectureListBySearch(terms);
	}

	@Override
	public List<Map<String, Object>> selectByDeadline(Map<String, Object> terms) {
		// TODO Auto-generated method stub
		return ld.selectByDeadline(terms);
	}

	@Override
	public int lectureDeadlineCount(Map<String, Object> terms) {
		// TODO Auto-generated method stub
		return ld.lectureDeadlineCount(terms);
	}

	@Override
	public List<Map<String, Object>> selectByApply(Map<String, Object> terms) {
		// TODO Auto-generated method stub
		return ld.selectByApply(terms);
	}

	@Override
	public int studyByApplyCount(Map<String, Object> terms) {
		// TODO Auto-generated method stub
		return ld.studyByApplyCount(terms);
	}

	@Override
	public int lectureWish(Map<String, Integer> map) {
		return ld.lectureWish(map);
	}

	@Override
	public int addWishLecture(Map<String, Integer> map) {
		return ld.addWishLecture(map);
	}

	@Override
	public int insertPay(Map<String, Object> map) {
		return ld.insertPay(map);
	}

	@Override
	public int lectureWishCancel(Map<String, Integer> map) {
		return ld.lectureWishCancel(map);
	}

	@Override
	public List<Map<String, Object>> selectLectureListByMno(Map<String, Object> key) {
		return ld.selectLectureListByMno(key);
	}

	@Override
	public int confirmInstructor(int mno) {
		return ld.confirmInstructor(mno);
	}

	@Override
	public int deleteLectures(Map<String, Object> map) {
		return ld.deleteLectures(map);
	}

	@Override
	public Lecture selectLectureByMnoTypeLecture(int sno) {
		return ld.selectLectureByMnoTypeLecture(sno);
	}

	@Override
	public List<Map<String, Object>> restTypeLister(Map<String, String> queryMap) {
		return ld.restTypeLister(queryMap);
	}

	@Override
	public int lectureCancel(Map<String, Integer> map) {
		return ld.lectureCancel(map);
	}

	@Override
	public long selectPay(Map<String, Integer> map) {
		return ld.selectPay(map);
	}

	@Override
	public void successPayCancel(long pno) {
		ld.successPayCancel(pno);
	}

	@Override
	public int selectTotalPayCount() {
		return ld.selectTotalPayCount();
	}

	@Override
	public List<Map<String, String>> selectPayList(int cPage, int numPerPage, Map<String, String> key) {
		return ld.selectPayList(cPage, numPerPage, key);
	}

	@Override
	public void successAdminPayCancel(long pno) {
		ld.successAdminPayCancel(pno);
	}

	@Override
	public List<Map<String, String>> searchAdminLectureList(int cPage, int numPerPage, Map<String, Object> map) {
		return ld.searchAdminLectureList(cPage, numPerPage, map);
	}

	@Override
	public int selectTotalAdminLectureCount(Map<String, Object> map) {
		return ld.selectTotalAdminLectureCount(map);
	}

	@Override
	public int peopleCnt(int sno) {
		return ld.peopleCnt(sno);
	}

	@Override
	public int recruitCnt(int sno) {
		return ld.recruitCnt(sno);
	}

}