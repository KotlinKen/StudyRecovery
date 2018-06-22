package com.pure.study.lecture.controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.pure.study.lecture.model.service.LectureService;
import com.pure.study.lecture.model.vo.Lecture;

@Controller
public class LectureContoller {
	private Logger logger = LoggerFactory.getLogger(getClass());

	@Autowired
	private LectureService ls;

	/* 강의 등록으로 이동하는 맵핑 */
	@RequestMapping("/lecture/insertLecture.do")
	public ModelAndView insertLecture() {
		ModelAndView mav = new ModelAndView();

		// 지역리스트
		List<Map<String, String>> locList = ls.selectLocList();
		// 큰 분류 리스트
		List<Map<String, String>> kindList = ls.selectKindList();
		// 난이도 
		List<Map<String, String>> diffList = ls.selectDiff();

		mav.addObject("locList", locList);
		mav.addObject("kindList", kindList);
		mav.addObject("diffList", diffList);		

		mav.setViewName("lecture/insertLecture");

		return mav;
	}

	@RequestMapping("/lecture/selectTown.do")
	@ResponseBody
	public List<Map<String, Object>> selectTown(@RequestParam(value = "localNo") int localNo) {
		List<Map<String, Object>> townList = ls.selectTownList(localNo);

		return townList;
	}

	@RequestMapping("/lecture/selectSubject.do")
	@ResponseBody
	public List<Map<String, Object>> selectKind(@RequestParam(value = "kindNo") int kindNo) {
		List<Map<String, Object>> subList = ls.selectSubList(kindNo);

		return subList;
	}

	@RequestMapping("/lecture/lectureFormEnd.do")
	public ModelAndView insetLecture(Lecture lecture, 
			                         @RequestParam(value = "freqs") String[] freqs,
			                         @RequestParam(value="upFile") MultipartFile[] upFiles,
			                         HttpServletRequest request) {
		int result = 0;
		// 빈도 배열을 join해서 setter로 setting해줌
		String freq = String.join(",", freqs);
		lecture.setFreqs(freq);
		
		//1.파일업로드처리
		int i = 0;
		int last = upFiles.length;
		String img = "";
		String saveDirectory = request.getSession()
									  .getServletContext()
									  .getRealPath("/resources/upload/board");
		
		/****** MultipartFile을 이용한 파일 업로드 처리로직 시작 ******/
		for(MultipartFile f: upFiles) {
			i++;
			
			if(!f.isEmpty()) {
				//파일명 재생성
				String originalFileName = f.getOriginalFilename();
				String ext = originalFileName.substring(originalFileName.lastIndexOf(".")+1);
				SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmssSSS");
				int rndNum = (int)(Math.random()*1000);
				String renamedFileName = sdf.format(new Date(System.currentTimeMillis()))+"_"+rndNum+"."+ext;
				
				img += renamedFileName;
				
				if( i == last ) {
					lecture.setUpfile(img);
					result = ls.insertLecture(lecture);
					
					if( result > 0 ) {
						try {
							f.transferTo(new File(saveDirectory+"/"+renamedFileName));
						} catch (IllegalStateException e) {
							e.printStackTrace();
						} catch (IOException e) {
							e.printStackTrace();
						}						
					}					
				}				
			}
			else {
				lecture.setUpfile(img);
				result = ls.insertLecture(lecture);
			}
		}		

		ModelAndView mav = new ModelAndView();

		mav.setViewName("lecture/lectureList");

		return mav;
	}

	@RequestMapping("/lecture/lectureList.do")
	public ModelAndView lectureList(@RequestParam(value = "cPage", required = false, defaultValue = "1") int cPage) {
		ModelAndView mav = new ModelAndView();
		
		int numPerPage = 5;
		int total = ls.selectTotalLectureCount();
		
		int totalPage = (int)Math.ceil(total/numPerPage);
		
		List<Map<String, String>> lectureList = ls.selectLectureList(cPage, numPerPage);
		List<Map<String, String>> locList = ls.selectLocList();
		List<Map<String, String>> kindList = ls.selectKindList();
		List<Map<String, String>> diffList = ls.selectDiff();
		
		mav.addObject("lectureList", lectureList);
		mav.addObject("locList", locList);
		mav.addObject("kindList", kindList);
		mav.addObject("diffList", diffList);
		mav.addObject("cPage", cPage);
		mav.addObject("totalPage", totalPage);
		
		mav.setViewName("lecture/lectureListEnd");

		return mav;
	}
	
	@RequestMapping("/lecture/lectureView.do")
	public ModelAndView lectureView(@RequestParam int sno) {
		ModelAndView mav = new ModelAndView();		
		Map<String, String> lecture = ls.selectLectureOne(sno);
		
		mav.addObject("lecture", lecture);
		
		mav.setViewName("lecture/lectureView");
		
		return mav;
	}
	
	@RequestMapping("/lecture/deleteLecture.do")
	public ModelAndView deleteLecture(@RequestParam int sno) {
		ModelAndView mav = new ModelAndView();		
		int result = ls.deleteLecture(sno);
		
		mav.setViewName("/lecture/lectureList");
				
		return mav;
	}
	
	@RequestMapping("/lecture/findLecture.do")
	@ResponseBody
	public int findLecture(@RequestParam int sno, @RequestParam int mno) {
		int result = 0;
		Map<String, Integer> map = new HashMap<>();
		
		map.put("sno", sno);
		map.put("mno", mno);
		
		result = ls.preinsertApply(map);
		
		return result;
	}
	
	@RequestMapping("/lecture/applyLecture.do")
	@ResponseBody
	public int applyLecture(@RequestParam int sno, @RequestParam int mno) {
		int result = 0;
		
		Map<String, Integer> map = new HashMap<>();
		
		map.put("sno", sno);
		map.put("mno", mno);

		result = ls.applyLecture(map);
		
		return result;
	}
}