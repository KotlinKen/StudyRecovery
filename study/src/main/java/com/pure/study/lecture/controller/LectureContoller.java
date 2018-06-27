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

	private int numPerPage = 6;

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

	@RequestMapping("/lecture/lectureFormEnd.do")
	public ModelAndView insetLecture(Lecture lecture,
			@RequestParam(value = "cPage", required = false, defaultValue = "1") int cPage,
			@RequestParam(value = "freqs") String[] freqs, @RequestParam(value = "upFile") MultipartFile[] upFiles,
			HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();

		int result = 0;

		List<Map<String, String>> locList = ls.selectLocList();
		List<Map<String, String>> kindList = ls.selectKindList();
		List<Map<String, String>> diffList = ls.selectDiff();

		mav.addObject("locList", locList);
		mav.addObject("kindList", kindList);
		mav.addObject("diffList", diffList);

		// 빈도 배열을 join해서 setter로 setting해줌
		String freq = String.join(",", freqs);
		lecture.setFreqs(freq);

		// 1.파일업로드처리
		int i = 0;
		int last = upFiles.length;
		String img = "";
		String saveDirectory = request.getSession().getServletContext().getRealPath("/resources/upload/board");

		/****** MultipartFile을 이용한 파일 업로드 처리로직 시작 ******/
		for (MultipartFile f : upFiles) {
			i++;

			if (!f.isEmpty()) {
				// 파일명 재생성
				String originalFileName = f.getOriginalFilename();
				String ext = originalFileName.substring(originalFileName.lastIndexOf(".") + 1);
				SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmssSSS");
				int rndNum = (int) (Math.random() * 1000);
				String renamedFileName = sdf.format(new Date(System.currentTimeMillis())) + "_" + rndNum + "." + ext;

				if (i != last)
					img += renamedFileName + ", ";

				if (i == last) {
					img += renamedFileName;

					lecture.setUpfile(img);
					result = ls.insertLecture(lecture);

					if (result > 0) {
						try {
							f.transferTo(new File(saveDirectory + "/" + renamedFileName));
						} catch (IllegalStateException e) {
							e.printStackTrace();
						} catch (IOException e) {
							e.printStackTrace();
						}
					}
				}
			} else {
				lecture.setUpfile(img);
				result = ls.insertLecture(lecture);
			}
		}

		mav.setViewName("lecture/lectureList");

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

	@RequestMapping("/lecture/lectureList.do")
	public ModelAndView lectureList(@RequestParam(value = "cPage", required = false, defaultValue = "1") int cPage) {
		ModelAndView mav = new ModelAndView();

		List<Map<String, String>> locList = ls.selectLocList();
		List<Map<String, String>> kindList = ls.selectKindList();
		List<Map<String, String>> diffList = ls.selectDiff();

		mav.addObject("locList", locList);
		mav.addObject("kindList", kindList);
		mav.addObject("diffList", diffList);
		mav.addObject("cPage", cPage);
		mav.setViewName("lecture/lectureList");

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

	// 아무 조건 없이 강의 리스트 첫 페이징 처리.
	@RequestMapping("/lecture/selectLectureList.do")
	public ModelAndView selectLectureList() {
		ModelAndView mav = new ModelAndView("jsonView");

		int cPage = 1;

		List<Map<String, Object>> list = ls.selectLectureList(cPage, numPerPage);

		int total = ls.selectTotalLectureCount();

		mav.addObject("list", list);
		mav.addObject("numPerPage", numPerPage);
		mav.addObject("cPage", cPage + 1);
		mav.addObject("total", total);

		return mav;

	}

	// 스크롤 페이징 처리 - 조건 없음
	@RequestMapping("/lecture/lectureListAdd.do")
	public ModelAndView lectureListAdd(@RequestParam(value = "cPage", defaultValue = "1") int cPage) {
		ModelAndView mav = new ModelAndView("jsonView");
		List<Map<String, Object>> lectureList = ls.selectLectureList(cPage, numPerPage);
		mav.addObject("list", lectureList);
		mav.addObject("cPage", cPage + 1);

		return mav;
	}

	// 검색 첫 페이징 처리
	@RequestMapping("/lecture/searchLecture.do")
	public ModelAndView searchLecture(@RequestParam(value = "lno") int lno,
			@RequestParam(value = "tno", defaultValue = "null") int tno, @RequestParam(value = "subno") int subno,
			@RequestParam(value = "kno") int kno, @RequestParam(value = "dno") int dno,
			@RequestParam(value = "leadername") String leadername,
			@RequestParam(value = "cPage", required = false, defaultValue = "1") int cPage) {
		ModelAndView mav = new ModelAndView("jsonView");

		if (leadername.trim().length() < 1)
			leadername = null;

		/* 쿼리에 넘길 조건들 Map */
		Map<String, Object> terms = new HashMap<>();
		terms.put("lno", lno);
		terms.put("tno", tno);
		terms.put("subno", subno);
		terms.put("kno", kno);
		terms.put("dno", dno);
		terms.put("leadername", leadername);
		terms.put("cPage", cPage + 1);
		terms.put("numPerPage", numPerPage);

		// 검색 조건에 따른 총 스터기 갯수
		int total = ls.selectTotalLectureCountBySearch(terms);

		// 페이징 처리해서 가져온 리스트
		List<Map<String, Object>> lectureList = ls.selectLectureListBySearch(terms);
		mav.addObject("list", lectureList);
		mav.addObject("total", total);
		mav.addObject("cPage", cPage);

		return mav;
	}

	// 스크롤 페이징 처리 - 검색
	@RequestMapping("/lecture/lectureSearchAdd.do")
	public ModelAndView lectureSearchAdd(@RequestParam(value = "lno") int lno,
			@RequestParam(value = "tno", defaultValue = "null") int tno, @RequestParam(value = "subno") int subno,
			@RequestParam(value = "kno") int kno, @RequestParam(value = "dno") int dno,
			@RequestParam(value = "leadername") String leadername,
			@RequestParam(value = "cPage", required = false) int cPage) {
		ModelAndView mav = new ModelAndView("jsonView");

		if (leadername.trim().length() < 1)
			leadername = null;

		/* 쿼리에 넘길 조건들 Map */
		Map<String, Object> terms = new HashMap<>();
		terms.put("lno", lno);
		terms.put("tno", tno);
		terms.put("subno", subno);
		terms.put("kno", kno);
		terms.put("dno", dno);
		terms.put("leadername", leadername);
		terms.put("cPage", cPage);
		terms.put("numPerPage", numPerPage);

		List<Map<String, Object>> list = ls.selectLectureListBySearch(terms);
		mav.addObject("list", list);
		mav.addObject("cPage", cPage + 1);

		return mav;
	}

	// 마감입박순 첫 페이징 처리
	@RequestMapping("/lecture/selectByDeadline.do")
	public ModelAndView selectByDeadline() {
		ModelAndView mav = new ModelAndView("jsonView");

		int cPage = 1;

		List<Map<String, Object>> list = ls.selectByDeadline(cPage, numPerPage);

		int total = ls.lectureDeadlineCount();

		mav.addObject("list", list);
		mav.addObject("cPage", cPage + 1);
		mav.addObject("total", total);

		return mav;
	}

	// 스크롤 페이징 처리 - 마감임박순
	@RequestMapping("/lecture/lectureDeadlinAdd.do")
	public ModelAndView lectureDeadlinAdd(@RequestParam(value = "cPage", defaultValue = "1") int cPage) {
		ModelAndView mav = new ModelAndView("jsonView");
		List<Map<String, Object>> lectureList = ls.selectByDeadline(cPage, numPerPage);

		mav.addObject("list", lectureList);
		mav.addObject("cPage", cPage + 1);

		return mav;
	}

	// 신청자순 첫 페이징 처리
	@RequestMapping("/lecture/selectByApply.do")
	public ModelAndView selectByApply() {
		ModelAndView mav = new ModelAndView("jsonView");

		int cPage = 1;

		List<Map<String, Object>> list = ls.selectByApply(cPage, numPerPage);

		int total = ls.studyByApplyCount();

		mav.addObject("list", list);
		mav.addObject("cPage", cPage + 1);
		mav.addObject("total", total);

		return mav;
	}

	// 스크롤 페이징 처리 - 신청자순
	@RequestMapping("/lecture/lectureApplyAdd.do")
	public ModelAndView lectureApplyAdd(@RequestParam(value = "cPage", defaultValue = "1") int cPage) {
		ModelAndView mav = new ModelAndView("jsonView");
		List<Map<String, Object>> lectureList = ls.selectByApply(cPage, numPerPage);
		mav.addObject("list", lectureList);
		mav.addObject("cPage", cPage + 1);

		return mav;
	}

	@RequestMapping(value = "/lecture/lectureWish.do", produces = "application/text; charset=utf8")
	@ResponseBody
	public String lectureWish(@RequestParam int sno, @RequestParam int mno) {
		ModelAndView mav = new ModelAndView();
		Map<String, Integer> map = new HashMap<>();

		map.put("sno", sno);
		map.put("mno", mno);

		int confirm = ls.lectureWish(map);

		String msg = "";

		if (confirm > 0)
			msg = "이미 찜한 강의입니다.";
		else {
			int result = ls.addWishLecture(map);

			if (result > 0)
				msg = "강의를 찜했습니다.";
		}

		return msg;
	}

	@RequestMapping("/lecture/updateLecture.do")
	public ModelAndView updateLecture(@RequestParam int sno) {
		ModelAndView mav = new ModelAndView();

		// 강의
		Map<String, String> lecture = ls.selectLectureOne(sno);

		// 지역리스트
		List<Map<String, String>> locList = ls.selectLocList();

		// 큰 분류 리스트
		List<Map<String, String>> kindList = ls.selectKindList();

		// 난이도
		List<Map<String, String>> diffList = ls.selectDiff();

		mav.addObject("lecture", lecture);
		mav.addObject("locList", locList);

		mav.addObject("kindList", kindList);
		mav.addObject("diffList", diffList);

		mav.setViewName("lecture/updateLecture");

		return mav;
	}

	@RequestMapping("/lecture/successPay.do")
	public ModelAndView seccessPay(@RequestParam int mno, @RequestParam int sno, @RequestParam(required=true) long pno, @RequestParam int price) {
		ModelAndView mav = new ModelAndView();
		
		Map<String, Object> map = new HashMap<>();
		
		map.put("pno", pno);
		map.put("sno", sno);
		map.put("mno", mno);
		map.put("price", price);
		map.put("status", 1);
		
		int result = ls.insertPay(map);
		
		String loc = "/lecture/lectureView.do?sno=" + sno;
		
		mav.addObject("loc", loc);
		mav.setViewName("/common/msg");
		
		return mav;
	}
	
	@RequestMapping("/lecture/failedPay.do")
	public ModelAndView failedPay(@RequestParam int mno, @RequestParam int sno, @RequestParam(required=true) long pno, @RequestParam int price) {
		ModelAndView mav = new ModelAndView();
		
		Map<String, Object> map = new HashMap<>();
		
		map.put("pno", pno);
		map.put("sno", sno);
		map.put("mno", mno);
		map.put("price", price);
		map.put("status", 0);
		
		int result = ls.insertPay(map);
		
		String loc = "/lecture/lectureView.do?sno=" + sno;
		
		mav.addObject("loc", loc);
		mav.setViewName("/common/msg");
		
		return mav;
	}
}