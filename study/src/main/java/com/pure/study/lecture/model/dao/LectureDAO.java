package com.pure.study.lecture.model.dao;

import java.util.List;
import java.util.Map;

import com.pure.study.lecture.model.vo.Lecture;

public interface LectureDAO {

	List<Map<String, String>> selectLocList();

	List<Map<String, Object>> selectTownList(int localNo);

	List<Map<String, String>> selectKindList();

	List<Map<String, Object>> selectSubList(int kindNo);

	int insertLecture(Lecture lecture);

	List<Map<String, Object>> selectLectureList(int cPage, int numPerPage);

	List<Map<String, String>> selectDiffList();

	Map<String, String> selectLectureOne(int sno);

	int deleteLecture(int sno);

	int applyLecture(Map<String, Integer> map);

	int preinsertApply(Map<String, Integer> map);

	int selectTotalLectureCount();

	int selectTotalLectureCountBySearch(Map<String, Object> map);

	List<Map<String, Object>> selectLectureListBySearch(Map<String, Object> terms);

	List<Map<String, Object>> selectByDeadline(int cPage, int numPerPage);

	int lectureDeadlineCount();

	List<Map<String, Object>> selectByApply(int cPage, int numPerPage);

	int studyByApplyCount();

	int lectureWish(Map<String, Integer> map);

	int addWishLecture(Map<String, Integer> map);

	int insertPay(Map<String, Object> map);

	int lectureWishCancel(Map<String, Integer> map);

	List<Map<String, Object>> selectLectureListByMno(Map<String, Object> key);

	int confirmInstructor(int mno);

	int deleteLectures(Map<String, Object> map);

	Lecture selectLectureByMnoTypeLecture(int sno);

	List<Map<String, Object>> restTypeLister(Map<String, String> queryMap);

}