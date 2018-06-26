package com.pure.study.board.model.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ReplyDAOImpl implements ReplyDAO{
	@Autowired
	SqlSessionTemplate sqlSession;
	
	@Override
	public int replyCount(Map<String, String> queryMap) {
		return sqlSession.selectOne("reply.replyCount", queryMap); 
	}

	@Override
	public List<Map<String, String>> replyList(int cPage, int numPerPage, Map<String, String> queryMap) {
		return sqlSession.selectList("reply.replyList", queryMap, new RowBounds((cPage-1)*numPerPage, numPerPage));
	}

	@Override
	public int replyWrite(Map<String, String> queryMap) {
		return sqlSession.insert("reply.replyWrite", queryMap);
	}
}
