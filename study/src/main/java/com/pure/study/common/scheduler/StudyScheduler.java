package com.pure.study.common.scheduler;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.pure.study.member.model.service.MemberService;
import com.pure.study.study.model.service.StudyService;
import com.pure.study.study.model.vo.Study;

@Component
public class StudyScheduler {
	Logger logger = LoggerFactory.getLogger(getClass());
	
	@Autowired
	StudyService studyService;
	
	@Scheduled(cron = "0 0/60  * * * ? ")
	public void execute() {
		//체크
		
		//업데이트
		
		//성공실패 체크
		
		
		List<Map<String, Object>> map = studyService.selectStudyList(1, 5);
		
		
		
		logger.info("map"+map);
	}

}
