package com.pure.study.adminSub.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.pure.study.adminSub.model.service.AdminSubService;
import com.pure.study.lecture.model.service.LectureService;
import com.pure.study.study.model.service.StudyService;

@Controller
public class AdminSubController {
	
	@Autowired
	private StudyService studyService;
	
	@Autowired
	private AdminSubService adminSubService;
	
	@Autowired
	private LectureService ls;
	
	/************************************ 과목 변경 *************************************/
	@RequestMapping("adminSub/kindListView.do")
	private ModelAndView kindListView() {
		ModelAndView mav = new ModelAndView();
		
		List<Map<String, String>> kindList = ls.selectKindList();
		mav.addObject("kindList", kindList);
		
		return mav;
	}
	@RequestMapping("/adminSub/selectSubject.do")
	@ResponseBody
	public List<Map<String,Object>> selectSubject(@RequestParam(value="kindNo", required=true) int kindNo){
		List<Map<String, Object>> subList = ls.selectSubList(kindNo);
		return subList;
	}
	@RequestMapping("/adminSub/instructorSubEnd.do")
	public ModelAndView instructorSubEnd(@RequestParam(value="subjectname", required=false ,  defaultValue="-1" ) String[] subjectname,
										 @RequestParam(value="snameename", required=false,  defaultValue="-1" ) String[] snameename,
										 @RequestParam(value="subno", required=false,  defaultValue="-1" ) String subno){
		
		ModelAndView mav = new ModelAndView();
		System.out.println("subjectname : "+subjectname[0]);
		if(subjectname[0].equals("-1")) {
			mav.setViewName("redirect:/adminSub/kindListView.do");
			return mav;
		}
		System.out.println("snameename : "+snameename[0]);
		if(snameename[0].equals("-1")) {
			mav.setViewName("redirect:/adminSub/kindListView.do");
			return mav;
		}
		System.out.println("subno : "+subno);
		if(subno.equals("-1")) {
			mav.setViewName("redirect:/adminSub/kindListView.do");
			return mav;
		}
		int result =0;
		System.out.println("subjectname.length : "+subjectname.length);
		for(int i = 0 ; i <subjectname.length; i++) {
			Map<String,String> map = new HashMap<>();
			System.out.println("snameename : "+snameename[i]);
			System.out.println("subjectname : "+subjectname[i]);
			map.put("subno", subno);
			map.put("snameename", snameename[i]);
			map.put("subjectname", subjectname[i]);
			result += adminSubService.instructorSubEnd(map);
			
		}
		System.out.println("result : "+result);
		System.out.println("subjectname.length : "+subjectname.length);
		if(result != subjectname.length) {
			mav.addObject("msg", "서버 검사를 바랍니다.");
			mav.addObject("loc","/");
			mav.setViewName("common/msg");
		}
		mav.setViewName("redirect:/adminSub/kindListView.do");
		return mav;
	}
	@RequestMapping("adminSub/deleteSubEnd.do")
	public ModelAndView deleteSubEnd ( @RequestParam(value="subno", required=false) String subno) {
		ModelAndView mav = new ModelAndView();
		int resert = adminSubService.deleteSubEnd(subno);
		mav.setViewName("redirect:/adminSub/kindListView.do");
		return mav; 
	}
	
	@RequestMapping("adminSub/updateSubEnd.do")
	public ModelAndView updateSubEnd (@RequestParam(value="subjectname", required=false) String subjectname,
										 @RequestParam(value="snameename", required=false) String snameename,
										 @RequestParam(value="subno", required=false) String subno){
		ModelAndView mav = new ModelAndView();
		System.out.println("snameename="+snameename);
		System.out.println("snameename="+snameename);
		System.out.println("subno="+subno);
		Map<String,String> map = new HashMap<>();
		map.put("subno", subno);
		map.put("snameename", snameename);
		map.put("subjectname", subjectname);
		int result = adminSubService.updateSubEnd(map);
		
		mav.setViewName("redirect:/adminSub/kindListView.do");
		return mav; 
	}
	
	@RequestMapping("adminSub/instructorKindEnd.do")
	public ModelAndView instructorKindEnd (@RequestParam(value="kindname", required=false) String kindname,
			@RequestParam(value="knameename", required=false) String knameename){
		ModelAndView mav = new ModelAndView();
		System.out.println("kindname="+kindname);
		System.out.println("knameename="+knameename);
		Map<String,String> map = new HashMap<>();
		map.put("kindname", kindname);
		map.put("knameename", knameename);
		int result = adminSubService.instructorKindEnd(map);
		
		mav.setViewName("redirect:/adminSub/kindListView.do");
		return mav; 
	}
	@RequestMapping("adminSub/deleteKindEnd.do")
	public ModelAndView deleteKindEnd (@RequestParam(value="kno", required=false) String kno){
		ModelAndView mav = new ModelAndView();
		System.out.println("kno="+kno);
		
		int result = adminSubService.deleteKindEnd(kno);
		
		mav.setViewName("redirect:/adminSub/kindListView.do");
		return mav; 
	}
	
	/********************************* 지역 변경 ******************************************/
	
	@RequestMapping("adminSub/loadListView.do")
	private ModelAndView loadListView() {
		ModelAndView mav = new ModelAndView();
		
		List<Map<String,Object>> list = studyService.selectLocal();
		mav.addObject("list", list);
		
		return mav;
	}
	
	@RequestMapping("adminSub/selectTown.do")
	@ResponseBody
	public List<Map<String,Object>> selectTown(@RequestParam(value="lno", required=true) int lno){
		
		List<Map<String,Object>> list = studyService.selectTown(lno);
		
		return list;
	}	
	@RequestMapping("/adminSub/instructorTownEnd.do")
	public ModelAndView instructorTownEnd(@RequestParam(value="townname", required=false ,  defaultValue="-1" ) String[] townname,
											@RequestParam(value="lno", required=false ,  defaultValue="-1" ) String lno){
		
		ModelAndView mav = new ModelAndView();
		System.out.println("subjectname : "+townname[0]);
		if(townname[0].equals("-1")) {
			mav.setViewName("redirect:/adminSub/loadListView.do");
			return mav;
		}
		
		int result =0;
		System.out.println("subjectname.length : "+townname.length);
		for(int i = 0 ; i <townname.length; i++) {
			Map<String,String> map = new HashMap<>();
			System.out.println("townname : "+townname[i]);
			map.put("lno", lno);
			map.put("townname", townname[i]);
			result += adminSubService.instructorTownEnd(map);
			
		}
		System.out.println("result : "+result);
		System.out.println("subjectname.length : "+townname.length);
		if(result != townname.length) {
			mav.addObject("msg", "서버 검사를 바랍니다.");
			mav.addObject("loc","/");
			mav.setViewName("common/msg");
		}
		mav.setViewName("redirect:/adminSub/loadListView.do");
		return mav;
	}
	@RequestMapping("adminSub/updateTownEnd.do")
	public ModelAndView updateTownEnd (@RequestParam(value="tno", required=false) String tno,
										 @RequestParam(value="townname", required=false) String townname){
		ModelAndView mav = new ModelAndView();
		System.out.println("townname="+townname);
		System.out.println("tno="+tno);
		Map<String,String> map = new HashMap<>();
		map.put("tno", tno);
		map.put("townname", townname);
		int result = adminSubService.updateTownEnd(map);
		
		mav.setViewName("redirect:/adminSub/loadListView.do");
		return mav; 
	}
	
	@RequestMapping("adminSub/deleteTownEnd.do")
	public ModelAndView deleteTownEnd ( @RequestParam(value="tno", required=false) String tno) {
		ModelAndView mav = new ModelAndView();
		int resert = adminSubService.deleteTowonEnd(tno);
		mav.setViewName("redirect:/adminSub/loadListView.do");
		return mav; 
	}
	@RequestMapping("adminSub/instructorLocalEnd.do")
	public ModelAndView instructorLocalEnd (@RequestParam(value="local", required=false) String local){
		ModelAndView mav = new ModelAndView();
		System.out.println("local="+local);
	
		int result = adminSubService.instructorLocalEnd(local);
		
		mav.setViewName("redirect:/adminSub/loadListView.do");
		return mav; 
	}
	@RequestMapping("adminSub/deleteLocalEnd.do")
	public ModelAndView deleteLocalEnd (@RequestParam(value="lno", required=false) String lno){
		ModelAndView mav = new ModelAndView();
		System.out.println("lno="+lno);
		
		int result = adminSubService.deleteLocalEnd(lno);
		
		mav.setViewName("redirect:/adminSub/loadListView.do");
		return mav; 
	}
}
