package com.pure.study.common.crontab.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

@Service
@Repository
public class SchedulerDAOImpl implements SchedulerDAO {
	@Autowired
	SqlSessionTemplate sqlSession;

	@Override
	public List<Map<String, Object>> studyFinishLeader() {
		return sqlSession.selectList("scheduler.studyFinishLeader");
	}

	@Override
	public int addExpLeader(List<Map<String, Object>> leaderMno) {
		return sqlSession.update("scheduler.addExpLeader");
	}

	@Override
	public List<Map<String, Object>> studyFinishMember() {
		return sqlSession.selectList("scheduler.studyFinishMember");
	}

	@Override
	public int addExpMember(List<Map<String, Object>> memberMno) {
		return sqlSession.update("scheduler.addExpMember");
	}

}
