package com.pure.study.admin.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.pure.study.lecture.model.service.LectureService;

@Controller
public class AdminControllerYJ {
	@Autowired
	private LectureService ls;
	
	// 결제관리로 이동~
	@RequestMapping("/admin/adminPayment")
	public ModelAndView adminPayment() {
		ModelAndView mav = new ModelAndView();
		
		return mav;
	}
}
