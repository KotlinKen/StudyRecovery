package com.pure.study.study.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.pure.study.study.model.dao.StudyDAO;
import com.pure.study.study.model.vo.Study;



@Service
public class StudyServiceImpl implements StudyService {
	
	@Autowired
	private StudyDAO studyDAO;

	@Override
	public List<Map<String, Object>> selectStudyList(int cPage, int numPerPage) {
		// TODO Auto-generated method stub
		return studyDAO.selectStudyList(cPage,numPerPage);
	}

	@Override
	public int studyTotalCount() {
		// TODO Auto-generated method stub
		return studyDAO.studyTotalCount();
	}

	@Override
	public List<Map<String, Object>> selectSubject(int kno) {
		// TODO Auto-generated method stub
		return studyDAO.selectSubject(kno);
	}

	@Override
	public List<Map<String, Object>> selectKind() {
		// TODO Auto-generated method stub
		return studyDAO.selectKind();
	}

	@Override
	public List<Map<String, Object>> selectLocal() {
		// TODO Auto-generated method stub
		return studyDAO.selectLocal();
	}

	@Override
	public List<Map<String, Object>> selectTown(int lno) {
		// TODO Auto-generated method stub
		return studyDAO.selectTown(lno);
	}

	@Override
	public List<Map<String, Object>> selectLv() {
		// TODO Auto-generated method stub
		return studyDAO.selectLv();
	}

	@Override
	public int insertStudy(Study study) {
		// TODO Auto-generated method stub
		return studyDAO.insertStudy(study);
	}

	@Override
	public int updateStudyImg(Study study) {
		// TODO Auto-generated method stub
		return studyDAO.updateStudyImg(study);
	}

	@Override
	public List<Map<String, Object>> selectStudyForSearch(Map<String, Object> terms) {
		// TODO Auto-generated method stub
		return studyDAO.selectStudyForSearch(terms);
	}

	@Override
	public List<Map<String, Object>> selectStudyAdd(int cPage, int numPerPage) {
		// TODO Auto-generated method stub
		return studyDAO.selectStudyAdd(cPage,numPerPage);
	}

	@Override
	public Map<String, Object> selectStudyOne(int sno) {
		// TODO Auto-generated method stub
		return studyDAO.selectStudyOne(sno);
	}

	@Override
	public int insertApplyStudy(Map<String, Integer> map) {
		// TODO Auto-generated method stub
		return studyDAO.insertApplyStudy(map);
	}

	@Override
	public int insertWishStudy(Map<String, Integer> map) {
		// TODO Auto-generated method stub
		return studyDAO.insertWishStudy(map);
	}


	@Override
	public int studySearchTotalCount(Map<String, Object> terms) {
		// TODO Auto-generated method stub
		return studyDAO.studySearchTotalCount(terms);
	}

	@Override
	public int updateStudy(Study study) {
		// TODO Auto-generated method stub
		return studyDAO.updateStudy(study);
	}

	@Override
	public int deleteStudy(int sno) {
		// TODO Auto-generated method stub
		return studyDAO.deleteStudy(sno);
	}

	@Override
	public List<Map<String, Object>> selectByDeadline(int cPage, int numPerPage) {
		// TODO Auto-generated method stub
		return studyDAO.selectByDeadline(cPage,numPerPage);
	}

	@Override
	public int studyDeadlineCount() {
		// TODO Auto-generated method stub
		return studyDAO.studyDeadlineCount();
	}

	@Override
	public List<Map<String, Object>> selectByApply(int cPage, int numPerPage) {
		// TODO Auto-generated method stub
		return studyDAO.selectByApply(cPage,numPerPage);
	}

	@Override
	public int studyByApplyCount() {
		// TODO Auto-generated method stub
		return studyDAO.studyByApplyCount();
	}

	@Override
	public int preinsertApply(Map<String, Integer> map) {
		// TODO Auto-generated method stub
		return studyDAO.preinsertApply(map);
	}

	@Override
	public int isWishStudy(Map<String, Integer> map) {
		// TODO Auto-generated method stub
		return studyDAO.isWishStudy(map);
	}

	@Override
	public int deletewishStudy(Map<String, Integer> map) {
		// TODO Auto-generated method stub
		return studyDAO.deletewishStudy(map);
	}

	@Override
	public List<Map<String, Object>> selectReview(int sno) {
		// TODO Auto-generated method stub
		return studyDAO.selectReview(sno);
	}

	@Override
	public int selectApplyCount(int sno) {
		return studyDAO.selectApplyCount(sno);
	}

	@Override
	public List<Map<String, Object>> selectOwnStudyList(int mno) {
		// TODO Auto-generated method stub
		return studyDAO.selectOwnStudyList(mno);
	}

	@Override
	public int deleteStudyArr(List<Integer> study_arr) {
		// TODO Auto-generated method stub
		return studyDAO.deleteStudyArr(study_arr);
	}

	@Override
	public List<Map<String, Object>> selectStudyListBySno(Map<String, Object> key) {
		// TODO Auto-generated method stub
		return studyDAO.selectStudyListBySno(key);
	}

	@Override
	public Study selectStudyByMnoTypeStudy(String sno) {
		// TODO Auto-generated method stub
		return studyDAO.selectStudyByMnoTypeStudy(sno);
	}

	@Override
	public int deleteWish(Map<String, Integer> map) {
		// TODO Auto-generated method stub
		return studyDAO.deleteWish(map);
	}

	


}