package com.pure.study.common.crontab;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.pure.study.common.crontab.dao.SchedulerDAO;

@Component
public class Scheduler {
	
	@Autowired
	private SchedulerDAO schedulerDAO;
	
	@Scheduled(cron = "0 07 5 * * *") 
	public void cronTest1(){ 
		System.out.println("오후 00:00:00에 호출이 됩니다 ");
		//스터디 점수 추가
		//팀장에게 200, 팀원에게 100
		
		//1. 오늘 날짜에 종료되는 스터디의 팀원이 있는 스터디의 팀장 목록을 불러온다.
		List<Map<String, Object>> leaderMno = schedulerDAO.studyFinishLeader();
		/*
		//2. 팀장에게 스터디 점수 200을 준다.
		int result = schedulerDAO.addExpLeader(leaderMno);
		*/
		//3. 오늘 날짜에 종료되는 스터디의 팀원 목록을 불러온다.
		List<Map<String, Object>> memberMno = schedulerDAO.studyFinishMember();
		
		//4. 팀원에게 스터디 점수 100점을 준다.
		int memberResult = schedulerDAO.addExpMember(memberMno);
		System.out.println(memberResult);
		
	} 
}
