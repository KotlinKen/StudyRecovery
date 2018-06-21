package com.pure.study.admin.controller;

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
	
	
	/* 관리자 페이지로 이동 */
	@RequestMapping("/admin/adminMain")
	public ModelAndView moveAdminPage() {
		ModelAndView mav = new ModelAndView();
		
		return mav;
	}
}
