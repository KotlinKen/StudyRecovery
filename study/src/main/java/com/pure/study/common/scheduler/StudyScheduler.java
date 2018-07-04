package com.pure.study.common.scheduler;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.pure.study.common.crontab.dao.SchedulerDAO;
import com.pure.study.member.model.service.MemberService;
import com.pure.study.study.model.service.StudyService;
import com.pure.study.study.model.vo.Study;

@Component
public class StudyScheduler {
	Logger logger = LoggerFactory.getLogger(getClass());
	
	@Autowired
	StudyService studyService;
	
	@Autowired
	private SchedulerDAO schedulerDAO;
	
	@Scheduled(cron = "0 0/60  * * * ? ")
	public void execute() {
		//체크
		
		//업데이트
		
		//성공실패 체크
		
		
		List<Map<String, Object>> map = studyService.selectStudyList(1, 5);
		
		
		
		logger.info("map"+map);
	}
	@Scheduled(cron = "0 0 0  * * * ")
	public void execute1() {
		System.out.println("스터디 종료시, 팀장 200점, 팀원 100점 ");
		//스터디 점수 추가
		//팀장에게 200, 팀원에게 100
		
		//1. 오늘 날짜에 종료되는 스터디의 팀원이 있는 스터디의 팀장 목록을 불러온다.
		List<Map<String, String>> leaderMno = schedulerDAO.studyFinishLeader();	
		
		int result=0;
		if(!leaderMno.isEmpty()) {
			//2. 팀장에게 스터디 점수 200을 준다.
			for(Map<String,String> m : leaderMno) {
				result = schedulerDAO.addExpLeader(m);			
				System.out.println(result);			
			}
		}
		
		//3. 오늘 날짜에 종료되는 스터디의 팀원 목록을 불러온다.
		List<Map<String, String>> memberMno = schedulerDAO.studyFinishMember();
		
		if(!memberMno.isEmpty()) {
			//4. 팀원에게 스터디 점수 100점을 준다.
			int memberResult=0;
			for(Map<String,String> m : memberMno) {
				System.out.println("???1");
				System.out.println(m);
				memberResult = schedulerDAO.addExpMember(m);			
				System.out.println(memberResult);			
			}
		}		
		logger.info("result="+result);
	}

}
