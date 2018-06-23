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
	public List<Map<String, String>> selectLectureList(int cPage, int numPerPage) {
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
	public int selectTotalLectureCountBySearch(Map<String, Integer> map) {
		return ld.selectTotalLectureCountBySearch(map);
	}

	@Override
	public List<Map<String, String>> selectLectureListBySearch(int cPage, int numPerPage, Map<String, Integer> map) {
		return ld.selectLectureListBySearch(cPage, numPerPage, map);
	}

}