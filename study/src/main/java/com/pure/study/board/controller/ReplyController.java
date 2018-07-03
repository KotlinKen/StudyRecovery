package com.pure.study.board.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
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
import com.pure.study.board.model.vo.Board;
import com.pure.study.member.model.service.MemberService;



@Controller
public class ReplyController {
	
	@Autowired
	private MemberService memberService;

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
									@RequestParam Map<String, Object> queryMapObject,
									@RequestParam(value="bno", required=true, defaultValue="") int bno,
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
			
			if(result > 0 ) {
				queryMapObject.put("npoint", 100);
				memberService.updateNpoint(queryMapObject);
			}
			
			String loc = "/";
			String msg = "";
			
			
			if(result>0) {
				msg = "리플 등록 성공";
				loc = "/"+location+"/boardView?bno="+bno;

			}else {
				msg = "리플 등록 실패";
			}
			
			mav.addObject("msg", msg);
			mav.addObject("loc", loc);
			mav.setViewName("common/msg");
		return mav;
	}
	
	
	@RequestMapping("/{location}/replyModify")
	public ModelAndView replyModify(Board board, HttpServletRequest request,
									@RequestParam Map<String, String> queryMap,
									@RequestParam(value="bno", required=true, defaultValue="") int bno,
									@RequestParam(value="rno", required=true, defaultValue="") String rno,
									@RequestParam(value="mno", required=true, defaultValue="") String mno,
									@PathVariable(value="location", required=false) String location) {
		
		ModelAndView mav = new ModelAndView();
		if(StringUtils.isEmpty(rno) || StringUtils.isEmpty(mno)) {
			mav.addObject("msg", "잘못된 경로 접근 시도 입니다.");
			mav.addObject("loc", "/");
			mav.setViewName("common/msg");
			return mav;
		}
		
		
		if(location == null || !(location.equals("admin") || location.equals("board")) ) {
			mav.addObject("msg", "잘못된 경로로 접근 하셨습니다.");
			mav.addObject("loc", "/");
			mav.setViewName("common/msg");
			return mav;
		}
		
		int result = 0;
		if(mno != null) {
			Map<String, String> reply = replyService.replyOne(queryMap);
			String oldMno = String.valueOf(reply.get("MNO"));
			if(oldMno.equals(mno)) {
				result = replyService.replyModify(queryMap);
			}
		}
		
			
			
			String loc = "/";
			String msg = "";
			
			if(result>0) {
				msg = "리플 수정 성공";
				loc = "/"+location+"/boardView?bno="+bno;

			}else {
				msg = "리플 수정 실패";
			}
			
			mav.addObject("msg", msg);
			mav.addObject("loc", loc);
			mav.setViewName("common/msg");
		return mav;
	}
	
	
	@RequestMapping("/{location}/replyDelete")
	public ModelAndView replyDelete(Board board, HttpServletRequest request,
									@RequestParam Map<String, String> queryMap,
									@RequestParam(value="rno", required=true, defaultValue="") String rno,
									@RequestParam(value="mno", required=true, defaultValue="") String mno,
									@PathVariable(value="location", required=false) String location) {
		
		ModelAndView mav = new ModelAndView();
		
		if(StringUtils.isEmpty(rno) || StringUtils.isEmpty(mno)) {
			mav.addObject("msg", "잘못된 경로 접근 시도 입니다.");
			mav.addObject("loc", "/");
			mav.setViewName("common/msg");
			return mav;
		}
		
		System.out.println(request.getHeader("Referer"));
		
		 
		if(location == null || !(location.equals("admin") || location.equals("board")) ) {
			mav.addObject("msg", "잘못된 경로로 접근 하셨습니다.");
			mav.addObject("loc", "/");
			mav.setViewName("common/msg");
			return mav;
		}
		
		
		
		int result = 0;
		if(mno != null) {
			Map<String, String> reply = replyService.replyOne(queryMap);
			String oldMno = String.valueOf(reply.get("MNO"));
			if(oldMno.equals(mno)) {
				result = replyService.replyDelete(queryMap);
			}
		}
		
			
			
			String loc = "/";
			String msg = "";
			
			if(result>0) {
				msg = "리플 삭제 성공";
				loc = "/"+location+"/boardView?bno="+queryMap.get("bno");

			}else {
				msg = "리플 삭제 실패";
			}
			
			mav.addObject("msg", msg);
			mav.addObject("loc", loc);
			mav.setViewName("common/msg");
		return mav;
	}
	
	
}
