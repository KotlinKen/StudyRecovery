package com.pure.study.rest.model;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class RestDAOImpl implements RestDAO{
	
	@Autowired
	SqlSessionTemplate sqlSession;
	
	@Override
	public List<Map<String, String>> satistics(Map<String, String> queryMap) {
		return sqlSession.selectList("rest.satistics", queryMap);

	}
	

}
