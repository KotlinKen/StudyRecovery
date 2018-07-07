package com.pure.study.message.model.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class MessageDAOImpl implements MessageDAO{

	@Autowired
	SqlSessionTemplate sqlSession;
	
	@Override
	public List<Map<String, String>> messageList() {
		return sqlSession.selectList("message.messageList");
	}

	@Override
	public List<Map<String, String>> messageList(Map<String, String> queryMap) {
		return sqlSession.selectList("message.messageList", queryMap);
	}
	
	@Override
	public List<Map<String, String>> messageList(int cPage, int numPerPage, Map<String, String> queryMap) {
		return sqlSession.selectList("message.messageList", queryMap, new RowBounds((cPage-1)*numPerPage, numPerPage));
	}

	@Override
	public int messageWrite(Map<String, String> queryMap) {
		return sqlSession.insert("message.messageWrite", queryMap);
	}

	@Override
	public int messageCount(Map<String, String> queryMap) {
		return sqlSession.selectOne("message.messageCount", queryMap);
	}

}
