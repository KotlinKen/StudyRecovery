package com.pure.study.common.crontab.dao;

import java.util.List;
import java.util.Map;

public interface SchedulerDAO {
	
	List<Map<String, Object>> studyFinishLeader();

	int addExpLeader(List<Map<String, Object>> leaderMno);

	List<Map<String, Object>> studyFinishMember();

	int addExpMember(List<Map<String, Object>> memberMno);

}
