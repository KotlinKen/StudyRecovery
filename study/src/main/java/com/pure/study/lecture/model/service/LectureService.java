package com.pure.study.lecture.model.service;

import java.util.List;
import java.util.Map;

import com.pure.study.lecture.model.vo.Lecture;

public interface LectureService {

	List<Map<String, String>> selectLocList();

	List<Map<String, Object>> selectTownList(int localNo);

	List<Map<String, String>> selectKindList();

	List<Map<String, Object>> selectSubList(int kindNo);

	int insertLecture(Lecture lecture);

	List<Map<String, Object>> selectLectureList(int cPage, int numPerPage);

	List<Map<String, String>> selectDiff();

	Map<String, String> selectLectureOne(int sno);

	int deleteLecture(int sno);

	int applyLecture(Map<String, Integer> map);

	int preinsertApply(Map<String, Integer> map);

	int selectTotalLectureCount();

	int selectTotalLectureCountBySearch(Map<String, Object> terms);

	List<Map<String, Object>> selectLectureListBySearch(Map<String, Object> terms);

	List<Map<String, Object>> selectByDeadline(Map<String, Object> terms);

	int lectureDeadlineCount(Map<String, Object> terms);

	List<Map<String, Object>> selectByApply(Map<String, Object> terms);

	int studyByApplyCount(Map<String, Object> terms);

	int lectureWish(Map<String, Integer> map);

	int addWishLecture(Map<String, Integer> map);

	int insertPay(Map<String, Object> map);

	int lectureWishCancel(Map<String, Integer> map);

	List<Map<String, Object>> selectLectureListByMno(Map<String, Object> key);

	int confirmInstructor(int mno);

	int deleteLectures(Map<String, Object> map);

	Lecture selectLectureByMnoTypeLecture(int sno);

	List<Map<String, Object>> restTypeLister(Map<String, String> queryMap);

	int lectureCancel(Map<String, Integer> map);

	long selectPay(Map<String, Integer> map);

	void successPayCancel(long pno);

	List<Map<String, String>> selectPayList(int cPage, int numPerPage, Map<String, String> key);

	int selectTotalPayCount();

	void successAdminPayCancel(long pno);

	List<Map<String, String>> searchAdminLectureList(int cPage, int numPerPage, Map<String, Object> map);

	int selectTotalAdminLectureCount(Map<String, Object> map);

	int peopleCnt(int sno);

	int recruitCnt(int sno);

}