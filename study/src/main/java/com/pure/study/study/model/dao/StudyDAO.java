package com.pure.study.study.model.dao;

import java.util.List;
import java.util.Map;

import com.pure.study.study.model.vo.Study;



public interface StudyDAO {

	List<Map<String, Object>> selectStudyList(int cPage, int numPerPage);

	int studyTotalCount();

	List<Map<String, Object>> selectSubject(int kno);

	List<Map<String, Object>> selectKind();

	List<Map<String, Object>> selectLocal();

	List<Map<String, Object>> selectTown(int lno);

	List<Map<String, Object>> selectLv();

	int insertStudy(Study study);

	int updateStudyImg(Study study);

	List<Map<String, Object>> selectStudyForSearch(Map<String, Object> terms);

	List<Map<String, Object>> selectStudyAdd(int cPage, int numPerPage);

	Map<String, Object> selectStudyOne(int sno);

	int insertApplyStudy(Map<String, Integer> map);

	int insertWishStudy(Map<String, Integer> map);

	int studySearchTotalCount(Map<String, Object> terms);

	int updateStudy(Study study);

	int deleteStudy(int sno);

	List<Map<String, Object>> selectByDeadline(int cPage, int numPerPage);

	int studyDeadlineCount();

	List<Map<String, Object>> selectByApply(int cPage, int numPerPage);

	int studyByApplyCount();

	int preinsertApply(Map<String, Integer> map);

	int isWishStudy(Map<String, Integer> map);

	int deletewishStudy(Map<String, Integer> map);

	List<Map<String, Object>> selectReview(int sno);

	int selectApplyCount(int sno);

	List<Map<String,Object>> selectOwnStudyList(int mno);

	

}