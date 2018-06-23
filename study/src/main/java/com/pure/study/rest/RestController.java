package com.pure.study.rest;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.pure.study.adversting.model.vo.Adversting;
import com.pure.study.lecture.model.service.LectureService;
import com.pure.study.study.model.service.StudyService;

@Controller
public class RestController {
	@Autowired
	private StudyService studyService;
	
	@Autowired
	private LectureService lectureService;
	Logger logger = LoggerFactory.getLogger(getClass());

	@RequestMapping(value="/rest/study/all/{count}", method=RequestMethod.GET)
	@ResponseBody
	public ModelAndView selectStudyCount(@PathVariable int count,  @RequestParam(value="filter", required=false) String filter) {

		Adversting adversting = new Adversting();
		Map<String, String> map = new HashMap<>();
		
		adversting.setContent("1234");
		
		map.put("adversting", adversting.getContent());
		
		ModelAndView mav = new ModelAndView("jsonView");
		List<Map<String, Object>> list = studyService.selectStudyList(1, count);
		mav.addObject("list", list);
		return mav;
	}
	
	@RequestMapping(value="/rest/study/one/{sno}", method=RequestMethod.GET)
	@ResponseBody
	public ModelAndView selectStudyOne(@PathVariable int sno,  @RequestParam(value="filter", required=false) String filter) {
		
		ModelAndView mav = new ModelAndView("jsonView");
		Map<String, Object> study= studyService.selectStudyOne(sno);
		mav.addObject("study", study);
		return mav;
	}
	
	
	@RequestMapping("/study/studyDetailView")
	public ModelAndView selectStudyOneView(@RequestParam(value="sno") int sno){
		ModelAndView mav = new ModelAndView();
		Map<String,Object> study = studyService.selectStudyOne(sno);
		mav.addObject("study", study);
		mav.setViewName("study/studyDetailView");
		return mav;
	}
	
	
	@RequestMapping(value="/rest/lecture/{count}", method=RequestMethod.GET)
	@ResponseBody
	public ModelAndView selectLectureCount(@PathVariable int count,  @RequestParam(value="filter", required=false) String filter) {
		
		
		ModelAndView mav = new ModelAndView("jsonView");
		List<Map<String,String>> list = lectureService.selectLectureList(1, count);
		mav.addObject("list", list);
		return mav;
	}
	
	
	
	
	
}
