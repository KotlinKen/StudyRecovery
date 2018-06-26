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
	public List<Map<String, Object>> selectByDeadline(int cPage, int numPerPage) {
		// TODO Auto-generated method stub
		return ld.selectByDeadline(cPage,numPerPage);
	}

	@Override
	public int lectureDeadlineCount() {
		// TODO Auto-generated method stub
		return ld.lectureDeadlineCount();
	}

	@Override
	public List<Map<String, Object>> selectByApply(int cPage, int numPerPage) {
		// TODO Auto-generated method stub
		return ld.selectByApply(cPage,numPerPage);
	}

	@Override
	public int studyByApplyCount() {
		// TODO Auto-generated method stub
		return ld.studyByApplyCount();
	}

	@Override
	public int lectureWish(Map<String, Integer> map) {
		return ld.lectureWish(map);
	}

	@Override
	public int addWishLecture(Map<String, Integer> map) {
		return ld.addWishLecture(map);
	}

}