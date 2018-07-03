package com.pure.study.common.crontab.dao;

import java.util.List;
import java.util.Map;

public interface SchedulerDAO {
	
	List<Map<String, String>> studyFinishLeader();

	int addExpLeader(Map<String, String> m);

	List<Map<String, String>> studyFinishMember();

	int addExpMember(Map<String, String> m);

}
