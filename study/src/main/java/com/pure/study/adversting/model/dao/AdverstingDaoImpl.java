package com.pure.study.adversting.model.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.pure.study.adversting.model.vo.Adversting;
@Repository
public class AdverstingDaoImpl implements AdverstingDao {

	@Autowired
	SqlSessionTemplate sqlSession;

	@Override
	public List<Map<String, String>> adverstingListPaging(int cPage, int numPerPage, Map<String, String> queryMap) {
		return sqlSession.selectList("adversting.adverstingListPaging", queryMap, new RowBounds((cPage-1)*numPerPage, numPerPage));
	}

	@Override
	public int insertAdversting(Adversting adversting) {
		return sqlSession.insert("adversting.insertAdversting", adversting);
	}

	@Override
	public int adverstingTotalCount( Map<String, String> queryMap) {
		return sqlSession.selectOne("adversting.adverstingTotalCount", queryMap);
	}

	@Override
	public Map<String, String> selectAdverstingOne(int ano) {
		return sqlSession.selectOne("adversting.selectAdverstingOne", ano);
	}

	@Override
	public int updateAdversting(Adversting adversting) {
		return sqlSession.update("adversting.updateAdversting", adversting);
	}

	@Override
	public Map<String, String> adverstingCall(String type) {
		return sqlSession.selectOne("adversting.adverstingCall", type);
	}

	@Override
	public int adverstingDelete(int ano) {
		return sqlSession.delete("adversting.adverstingDelete", ano);
	}

}
