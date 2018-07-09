package com.pure.study.lecture.model.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.pure.study.lecture.model.vo.Lecture;

@Repository
public class LectureDAOImpl implements LectureDAO {
	@Autowired
	private SqlSessionTemplate session;

	@Override
	public List<Map<String, String>> selectLocList() {
		return session.selectList("lecture.selectLocList");
	}

	@Override
	public List<Map<String, Object>> selectTownList(int localNo) {
		return session.selectList("lecture.selectTownList", localNo);
	}

	@Override
	public List<Map<String, String>> selectKindList() {
		return session.selectList("lecture.selectKindList");
	}

	@Override
	public List<Map<String, String>> selectDiffList() {
		return session.selectList("lecture.selectDiffList");
	}	

	@Override
	public List<Map<String, Object>> selectSubList(int kindNo) {
		return session.selectList("lecture.selectSubList", kindNo);
	}

	@Override
	public int insertLecture(Lecture lecture) {
		return session.insert("lecture.insertLecture", lecture);
	}

	@Override
	public List<Map<String, Object>> selectLectureList(int cPage, int numPerPage) {
		RowBounds rowBounds = new RowBounds((cPage-1)*numPerPage, numPerPage);
		return session.selectList("lecture.selectLectureList", null, rowBounds);
	}

	@Override
	public Map<String, String> selectLectureOne(int sno) {
		return session.selectOne("lecture.selectLectureOne", sno);
	}

	@Override
	public int deleteLecture(int sno) {
		return session.delete("lecture.deleteLecture", sno);
	}

	@Override
	public int applyLecture(Map<String, Integer> map) {
		return session.insert("lecture.applyLecture", map);
	}

	@Override
	public int preinsertApply(Map<String, Integer> map) {
		return session.selectOne("lecture.preinsertApply", map);
	}

	@Override
	public int selectTotalLectureCount() {
		return session.selectOne("lecture.selectTotalLectureCount");
	}

	@Override
	public int selectTotalLectureCountBySearch(Map<String, Object> map) {
		return session.selectOne("lecture.selectTotalLectureCountBySearch", map);
	}

	@Override
	public List<Map<String, Object>> selectLectureListBySearch(Map<String, Object> terms) {
		RowBounds rowBounds = new RowBounds(((int)terms.get("cPage")-1)*(int)terms.get("numPerPage"), (int)terms.get("numPerPage"));
		return session.selectList("lecture.selectLectureListBySearch", terms, rowBounds);
	}

	@Override
	public List<Map<String, Object>> selectByDeadline(Map<String, Object> terms) {
		// TODO Auto-generated method stub
		RowBounds rowBounds = new RowBounds(((int)terms.get("cPage")-1)*(int)terms.get("numPerPage"), (int)terms.get("numPerPage"));
		return session.selectList("lecture.selectByDeadline",terms,rowBounds);
	}

	@Override
	public int lectureDeadlineCount(Map<String, Object> terms) {
		// TODO Auto-generated method stub
		return session.selectOne("lecture.lectureDeadlineCount",terms);
	}

	@Override
	public List<Map<String, Object>> selectByApply(Map<String, Object> terms) {
		RowBounds rowBounds = new RowBounds(((int)terms.get("cPage")-1)*(int)terms.get("numPerPage"), (int)terms.get("numPerPage"));
		return session.selectList("lecture.selectByApply",terms,rowBounds);
	}

	@Override
	public int studyByApplyCount(Map<String, Object> terms) {
		// TODO Auto-generated method stub
		return session.selectOne("lecture.studyByApplyCount",terms);
	}

	@Override
	public int lectureWish(Map<String, Integer> map) {
		return session.selectOne("lecture.lectureWish", map);
	}

	@Override
	public int addWishLecture(Map<String, Integer> map) {
		return session.insert("lecture.addWishLecture", map);
	}

	@Override
	public int insertPay(Map<String, Object> map) {
		return session.insert("lecture.insertPay", map);
	}

	@Override
	public int lectureWishCancel(Map<String, Integer> map) {
		return session.delete("lecture.lectureWishCancel", map);
	}

	@Override
	public List<Map<String, Object>> selectLectureListByMno(Map<String, Object> key) {
		return session.selectList("lecture.selectLectureListByMno", key);
	}

	@Override
	public int confirmInstructor(int mno) {
		return session.selectOne("lecture.confirmInstructor", mno);
	}

	@Override
	public int deleteLectures(Map<String, Object> map) {
		return session.delete("lecture.deleteLectures", map);
	}

	@Override
	public Lecture selectLectureByMnoTypeLecture(int sno) {
		return session.selectOne("lecture.selectLectureByMnoTypeLecture", sno);
	}

	@Override
	public List<Map<String, Object>> restTypeLister(Map<String, String> queryMap) {
		return session.selectList("lecture.restTypeLister", queryMap);
	}

	@Override
	public int lectureCancel(Map<String, Integer> map) {
		return session.delete("lecture.lectureCancel", map);
	}

	@Override
	public long selectPay(Map<String, Integer> map) {
		return session.selectOne("lecture.selectPay", map);
	}

	@Override
	public void successPayCancel(long pno) {
		session.insert("lecture.succesPayCancel", pno);
	}


	@Override
	public int selectTotalPayCount() {
		return session.selectOne("lecture.selectTotalPayCount");
	}

	@Override
	public List<Map<String, String>> selectPayList(int cPage, int numPerPage, Map<String, Object> key) {
		RowBounds rowBounds = new RowBounds((cPage-1)*numPerPage, numPerPage);
		return session.selectList("lecture.selectPayList", key, rowBounds);
	}

	@Override
	public void successAdminPayCancel(long pno) {
		session.update("lecture.successAdminPayCancel", pno);
	}

	@Override
	public List<Map<String, String>> searchAdminLectureList(int cPage, int numPerPage, Map<String, Object> map) {
		RowBounds rowBounds = new RowBounds((cPage-1)*numPerPage, numPerPage);
		return session.selectList("lecture.searchAdminLectureList", map, rowBounds);
	}

	@Override
	public int selectTotalAdminLectureCount(Map<String, Object> map) {
		return session.selectOne("lecture.selectTotalAdminLectureCount",map);
	}

	@Override
	public int peopleCnt(int sno) {
		return session.selectOne("lecture.peopleCnt", sno);
	}

	@Override
	public int recruitCnt(int sno) {
		return session.selectOne("lecture.recruitCnt", sno);
	}

	@Override
	public List<Map<String, Object>> selectReviewList(int sno) {
		return session.selectList("lecture.selectReviewList", sno);
	}
}