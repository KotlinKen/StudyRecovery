package com.pure.study.board.controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.pure.study.board.model.excption.BoardException;
import com.pure.study.board.model.service.ReplyService;
import com.pure.study.board.model.vo.Attachment;
import com.pure.study.board.model.vo.Board;


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
	
	
	@RequestMapping("/{location}/replyWrite")
	public ModelAndView replyWrite(Board board, HttpServletRequest request,
									@RequestParam Map<String, String> queryMap,
									@RequestParam(value="parentno", required=false, defaultValue="0") String parentNo,
									@RequestParam(value="lev", required=false, defaultValue="1") String lev,
									@PathVariable(value="location", required=false) String location) {
		
		ModelAndView mav = new ModelAndView();
		
		queryMap.put("lev", lev);
		queryMap.put("parentno", parentNo);
		
		if(location == null || !(location.equals("admin") || location.equals("board")) ) {
			mav.addObject("msg", "잘못된 경로로 접근 하셨습니다.");
			mav.addObject("loc", "/");
			mav.setViewName("common/msg");
			return mav;
		}
		
		System.out.println(queryMap);
		
			int result = replyService.replyWrite(queryMap);
			
			
			String loc = "/";
			String msg = "";
			
			if(result>0) {
				msg = "게시물 등록 성공";
				loc = "/"+location+"/boardList";

			}else {
				msg = "게시물 등록 실패";
			}
			
			mav.addObject("msg", msg);
			mav.addObject("loc", loc);
			mav.setViewName("common/msg");
		return mav;
	}
	
}
