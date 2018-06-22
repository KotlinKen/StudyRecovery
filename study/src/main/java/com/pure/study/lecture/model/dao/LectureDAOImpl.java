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
	public List<Map<String, String>> selectLectureList(int cPage, int numPerPage) {
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
	public int selectTotalLectureCountBySearch(Map<String, Integer> map) {
		return session.selectOne("lecture.selectTotalLectureCountBySearch", map);
	}

	@Override
	public List<Map<String, String>> selectLectureListBySearch(int cPage, int numPerPage, Map<String, Integer> map) {
		RowBounds rowBounds = new RowBounds((cPage-1)*numPerPage, numPerPage);
		return session.selectList("lecture.selectLectureListBySearch", map, rowBounds);
	}

}