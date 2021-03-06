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

	List<Map<String, Object>> selectByDeadline(Map<String,Object> terms);

	int studyDeadlineCount(Map<String,Object> terms);

	List<Map<String, Object>> selectByApply(Map<String,Object> terms);

	int studyByApplyCount(Map<String,Object> terms);

	int preinsertApply(Map<String, Integer> map);

	int isWishStudy(Map<String, Integer> map);

	int deletewishStudy(Map<String, Integer> map);

	List<Map<String, Object>> selectReview(int sno);

	int selectApplyCount(int sno);

	List<Map<String,Object>> selectOwnStudyList(int mno);

	int deleteStudyArr(List<Integer> study_arr);

	List<Map<String, Object>> selectStudyListBySno(Map<String, Object> key);

	Study selectStudyByMnoTypeStudy(String sno);

	int deleteWish(Map<String, Integer> map);

	Map<String, Object> selectMemberAvg();

	int isCrewStudy(Map<String, Integer> map);

	int isApplyStudy(Map<String, Integer> map);

	int applyStudyDelete(Map<String, Object> map);

	List<Map<String, Object>> selectRankList();

	int preinsertApplyCrew(Map<String, Integer> map);

	int crewStudyDelete(Map<String, Object> map);

	

}