package com.pure.study.study.model.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

//github.com/KotlinKen/study.git
import com.pure.study.study.model.vo.Study;



@Repository
public class StudyDAOImpl implements StudyDAO {
	
	@Autowired
	private SqlSessionTemplate sqlSession;

	@Override
	public List<Map<String, Object>> selectStudyList(int cPage, int numPerPage) {
		RowBounds rowBounds = new RowBounds((cPage-1)*numPerPage, numPerPage);
		return sqlSession.selectList("study.studyList",null,rowBounds);
	}

	@Override
	public int studyTotalCount() {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("study.studyTotalCount");
	}


	@Override
	public int insertStudy(Study study) {
		// TODO Auto-generated method stub
		return sqlSession.insert("study.insertStudy",study);
	}
	
	
	
	@Override
	public List<Map<String, Object>> selectSubject(int kno) {
		// TODO Auto-generated method stub
		return sqlSession.selectList("study.selectSubject",kno);
	}

	@Override
	public List<Map<String, Object>> selectKind() {
		// TODO Auto-generated method stub
		return sqlSession.selectList("study.selectKind");
	}

	@Override
	public List<Map<String, Object>> selectLocal() {
		// TODO Auto-generated method stub
		return sqlSession.selectList("study.selectLocal");
	}

	@Override
	public List<Map<String, Object>> selectTown(int lno) {
		// TODO Auto-generated method stub
		return sqlSession.selectList("study.selectTown", lno);
	}

	@Override
	public List<Map<String, Object>> selectLv() {
		// TODO Auto-generated method stub
		List<Map<String, Object>> list =sqlSession.selectList("study.selectLv");
		System.out.println("list="+list);
		return list;
	}

	@Override
	public int updateStudyImg(Study study) {
		// TODO Auto-generated method stub
		return sqlSession.update("study.updateStudyImg", study);
	}

	@Override
	public List<Map<String, Object>> selectStudyForSearch(Map<String, Object> terms) {
		RowBounds rowBounds = new RowBounds(((int)terms.get("cPage")-1)*(int)terms.get("numPerPage"), (int)terms.get("numPerPage"));
		return sqlSession.selectList("study.selectStudyForSearch",terms,rowBounds);
	}

	@Override
	public List<Map<String, Object>> selectStudyAdd(int cPage, int numPerPage) {
		RowBounds rowBounds = new RowBounds((cPage-1)*numPerPage, numPerPage);
		return sqlSession.selectList("study.selectStudyAdd",null,rowBounds);
	}

	@Override
	public Map<String, Object> selectStudyOne(int sno) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("study.selectStudyOne", sno);
	}

	@Override
	public int insertApplyStudy(Map<String, Integer> map) {
		// TODO Auto-generated method stub
		return sqlSession.insert("study.insertApplyStudy", map);
	}

	@Override
	public int insertWishStudy(Map<String, Integer> map) {
		// TODO Auto-generated method stub
		return sqlSession.insert("study.insertWishStudy", map);
	}

	@Override
	public int studySearchTotalCount(Map<String, Object> terms) {
		
		return sqlSession.selectOne("study.studySearchTotalCount",terms);
	
	}

	@Override
	public int updateStudy(Study study) {
		// TODO Auto-generated method stub
		return sqlSession.update("study.updateStudy",study);
	}

	@Override
	public int deleteStudy(int sno) {
		// TODO Auto-generated method stub
		return sqlSession.delete("study.deleteStudy", sno);
	}

	@Override
	public List<Map<String, Object>> selectByDeadline(Map<String,Object> terms) {
		RowBounds rowBounds = new RowBounds(((int)terms.get("cPage")-1)*(int)terms.get("numPerPage"), (int)terms.get("numPerPage"));
		return sqlSession.selectList("study.selectByDeadline",terms,rowBounds);
	}

	@Override
	public int studyDeadlineCount(Map<String,Object> terms) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("study.studyDeadlineCount",terms);
	}

	@Override
	public List<Map<String, Object>> selectByApply(Map<String,Object> terms) {
		RowBounds rowBounds = new RowBounds(((int)terms.get("cPage")-1)*(int)terms.get("numPerPage"), (int)terms.get("numPerPage"));
		return sqlSession.selectList("study.selectByApply",terms,rowBounds);
	}

	@Override
	public int studyByApplyCount(Map<String,Object> terms) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("study.studyByApplyCount",terms);
	}

	@Override
	public int preinsertApply(Map<String, Integer> map) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("study.preinsertApply", map);
	}

	@Override
	public int isWishStudy(Map<String, Integer> map) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("study.isWishStudy", map);
	}

	@Override
	public int deletewishStudy(Map<String, Integer> map) {
		// TODO Auto-generated method stub
		return sqlSession.delete("study.deletewishStudy", map);
	}

	@Override
	public List<Map<String, Object>> selectReview(int sno) {
		// TODO Auto-generated method stub
		return sqlSession.selectList("study.selectReview", sno);
	}

	@Override
	public int selectApplyCount(int sno) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("study.selectApplyCount", sno);
	}

	@Override
	public List<Map<String, Object>> selectOwnStudyList(int mno) {
		// TODO Auto-generated method stub
		return sqlSession.selectList("study.selectOwnStudyList", mno);
	}

	@Override
	public int deleteStudyArr(List<Integer> study_arr) {
		// TODO Auto-generated method stub
		Map<String,Object> map = new HashMap<>();
		map.put("study_arr", study_arr);
		return sqlSession.delete("study.deleteStudyArr", map);
	}

	@Override
	public List<Map<String, Object>> selectStudyListBySno(Map<String, Object> key) {
		// TODO Auto-generated method stub
		return sqlSession.selectList("study.selectStudyListBySno",key);
	}

	@Override
	public Study selectStudyByMnoTypeStudy(String sno) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("study.selectStudyByMnoTypeStudy",sno);
	}

	@Override
	public int deleteWish(Map<String, Integer> map) {
		// TODO Auto-generated method stub
		return sqlSession.delete("study.deleteWish", map);
	}




}