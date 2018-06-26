package com.pure.study.admin.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.pure.study.admin.model.service.AdminService;

@Controller
public class AdminController {
	@Autowired
	private AdminService adminService;

	
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
	

	
	
}
