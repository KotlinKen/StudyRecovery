package com.pure.study.common.etc;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class EtcController {

	@RequestMapping("/etc/{location}")
	public ModelAndView boardWrite(@PathVariable(value="location", required=false) String location, 
								   @RequestParam(required=false) Map<String, String> queryMap,
								   HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		
		
		switch(location) {
		case "team":
			mav.setViewName("etc/team");
		break;
		case "locations": 
			mav.setViewName("etc/locations");
		break;
		case "privacy": 
			mav.setViewName("etc/privacy");
		break;
		case "terms": 
			mav.setViewName("etc/terms");
		break;
		case "study": 
			mav.setViewName("etc/study");
			break;
		case "lecture": 
			mav.setViewName("etc/lecture");
			break;
		case "board": 
			mav.setViewName("board/boardList?type=일반");
			break;
		case "one": 
			mav.setViewName("board/boardList?type=one");
			break;
		}
		
		
		return mav;
	}
	
	
	
}
