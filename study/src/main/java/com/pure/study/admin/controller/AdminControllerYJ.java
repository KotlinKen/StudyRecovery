package com.pure.study.admin.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.pure.study.admin.model.service.AdminService;

@Controller
public class AdminControllerYJ {
	@Autowired
	private AdminService adminService;
}
