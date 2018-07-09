package com.pure.study.adminSub.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class AdminSubDAOImpl implements AdminSubDAO {
	@Autowired
	SqlSessionTemplate sqlSession;

	@Override
	public int instructorSubEnd(Map<String, String> map) {
		return sqlSession.insert("adminSub.instructorSubEnd", map);
	}

	@Override
	public int deleteSubEnd(String subno) {
		return sqlSession.delete("adminSub.deleteSubEnd", subno);
	}

	@Override
	public int updateSubEnd(Map<String, String> map) {
		return sqlSession.update("adminSub.updateSubEnd", map);
	}

	@Override
	public int instructorKindEnd(Map<String, String> map) {
		return sqlSession.insert("adminSub.instructorKindEnd", map);
	}

	@Override
	public int deleteKindEnd(String kno) {
		return sqlSession.delete("adminSub.deleteKindEnd",kno);
	}

	@Override
	public int instructorTownEnd(Map<String, String> map) {
		return sqlSession.insert("adminSub.instructorTownEnd", map);
	}

	@Override
	public int updateTownEnd(Map<String, String> map) {
		return sqlSession.update("adminSub.updateTownEnd", map);
	}

	@Override
	public int deleteTowonEnd(String tno) {
		return sqlSession.delete("adminSub.deleteTowonEnd", tno);
	}

	@Override
	public int instructorLocalEnd(String local) {
		return sqlSession.insert("adminSub.instructorLocalEnd", local);
	}

	@Override
	public int deleteLocalEnd(String lno) {
		return sqlSession.delete("adminSub.deleteLocalEnd", lno);
	}
	

}
