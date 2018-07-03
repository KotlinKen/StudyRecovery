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
	public List<Map<String, String>> studyFinishLeader() {
		return sqlSession.selectList("scheduler.studyFinishLeader");
	}

	@Override
	public int addExpLeader(Map<String, String> leaderMno) {
		return sqlSession.update("scheduler.addExpLeader", leaderMno);
	}

	@Override
	public List<Map<String, String>> studyFinishMember() {
		return sqlSession.selectList("scheduler.studyFinishMember");
	}

	@Override
	public int addExpMember(Map<String, String> memberMno) {
		return sqlSession.update("scheduler.addExpMember", memberMno);
	}


}
