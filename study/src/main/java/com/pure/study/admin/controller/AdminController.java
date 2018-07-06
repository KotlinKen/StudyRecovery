package com.pure.study.admin.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.pure.study.admin.model.service.AdminService;
import com.pure.study.lecture.model.service.LectureService;

@Controller
public class AdminController {
	@Autowired
	private AdminService adminService;
	
	@Autowired
	private LectureService lectureService;
	
	@RequestMapping("/admin/adminLogin")
	public void adminLogin() {
		
	}	
	
	/* 메인페이지 */
	@RequestMapping("/admin/adminMain")
	public ModelAndView moveAdminPage() {
		ModelAndView mav = new ModelAndView();
		return mav;
	}
	/* 스터디  */
	@RequestMapping("/admin/adminStudy")
	public ModelAndView adminStudy(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		return mav;
	}
	/* 강의 */
	@RequestMapping("/admin/adminLecture")
	public ModelAndView adminLecture() {
		ModelAndView mav = new ModelAndView();
		
		List<Map<String, String>> locList = lectureService.selectLocList();
		List<Map<String, String>> kindList = lectureService.selectKindList();
		
		mav.addObject("locList", locList);
		mav.addObject("kindList", kindList);
		
		return mav;
	}
	
	/* 회원 관리페이지 */
	@RequestMapping("/admin/adminMember")
	public ModelAndView adminMember() {
		ModelAndView mav = new ModelAndView();
		return mav;
	}
	
	/* 강사 관리페이지 */
	@RequestMapping("/admin/adminInstructor")
	public ModelAndView adminInstructor() {
		ModelAndView mav = new ModelAndView();
		return mav;
	}
	
	/* 게시판 관리페이지 */
	@RequestMapping("/admin/adminBoard")
	public ModelAndView adminBoard() {
		ModelAndView mav = new ModelAndView();
		return mav;
	}
	
	/* 게시판 관리페이지 */
	@RequestMapping("/admin/restSessions")
	public ModelAndView restMember() {
		ModelAndView mav = new ModelAndView();
		return mav;
	}
	
	/*결제 관리페이지*/
	@RequestMapping("/admin/adminPayment.do")
	public ModelAndView adminPayment() {
		ModelAndView mav = new ModelAndView();		
		return mav;
	}
	
	/*통계  페이지*/
	@RequestMapping("/admin/adminStatistics")
	public ModelAndView adminStatistics() {
		ModelAndView mav = new ModelAndView();
		return mav;
	}
	
}
