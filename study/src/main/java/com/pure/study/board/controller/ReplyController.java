package com.pure.study.board.controller;

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

import com.pure.study.board.model.service.ReplyService;


@Controller
public class ReplyController {

	@Autowired
	ReplyService replyService;
	
	Logger logger = LoggerFactory.getLogger(getClass());

	@RequestMapping(value="/{location}/replyList", method=RequestMethod.GET)
	@ResponseBody
	public ModelAndView replyList(@RequestParam (value="cPage", required=false, defaultValue="1") int cPage, 
								  @RequestParam Map<String, String> queryMap,
								  @PathVariable(value="location", required=false) String location) {
		System.out.println("cno"+ queryMap.get("cno"));
		ModelAndView mav = new ModelAndView("jsonView");
		
		if(location == null || !(location.equals("admin") || location.equals("board"))) {
			mav.addObject("msg", "잘못된 경로로 접근 하셨습니다.");
			mav.addObject("loc", "/");
			mav.setViewName("common/msg");
			return mav;
		}
		
		int numPerPage = 10; 
		List<Map<String, String>> list = replyService.replyList(cPage, numPerPage, queryMap);
		
		int count = replyService.replyCount(queryMap);
		mav.addObject("list", list);
		mav.addObject("numPerPage", numPerPage);
		mav.addObject("cPage",cPage);
		mav.addObject("total", count);
		
		return mav;
	}
	
	
	
}
