package com.pure.study.rest;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.pure.study.adversting.model.vo.Adversting;
import com.pure.study.study.model.service.StudyService;

@Controller
public class RestController {
	@Autowired
	private StudyService studyService;
	Logger logger = LoggerFactory.getLogger(getClass());

	@RequestMapping(value="/rest/study", method=RequestMethod.GET)
	@ResponseBody
	public List<Map<String,String>> selectAdverstingRest(@RequestParam(value="filter", required=false) String filter) {

		Adversting adversting = new Adversting();
		Map<String, String> map = new HashMap<>();
		
		adversting.setContent("1234");;
		
		map.put("adversting", adversting.getContent());
		
		List<Map<String,String>> list = new ArrayList<Map<String, String>>();
		
		list.add(map);
		//test
		
		return list;
	}
	
	
	
}
