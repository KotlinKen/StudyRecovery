package com.pure.study.lecture.controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

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

import com.pure.study.lecture.model.service.LectureService;
import com.pure.study.lecture.model.vo.Lecture;
import com.pure.study.member.model.vo.Member;
import com.siot.IamportRestClient.IamportClient;
import com.siot.IamportRestClient.request.CancelData;
import com.siot.IamportRestClient.response.IamportResponse;
import com.siot.IamportRestClient.response.Payment;

@Controller
public class LectureContoller {
	private Logger logger = LoggerFactory.getLogger(getClass());

	@Autowired
	private LectureService ls;

	private int numPerPage = 6;

	/* 강의 등록으로 이동하는 맵핑 */
	@RequestMapping("/lecture/insertLecture.do")
	public ModelAndView insertLecture(@RequestParam int mno, HttpSession session) {
		ModelAndView mav = new ModelAndView();

		Member m = (Member) session.getAttribute("memberLoggedIn");
		int realMNo = m.getMno();

		String msg = "";
		String loc = "";

		if (mno != realMNo) {
			msg = "잘못된 경로로 접근했다.";
			loc = "/lecture/lectureList.do";

			mav.addObject("msg", msg);
			mav.addObject("loc", loc);

			mav.setViewName("/common/msg");
		} else {
			int confirm = 0;

			if (mno > 0) {
				confirm = ls.confirmInstructor(mno);
			}

			if (confirm > 0) {
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
			} else {
				msg = "강사만 강의 신청이 가능합니다.";
				loc = "/lecture/lectureList.do";

				mav.addObject("msg", msg);
				mav.addObject("loc", loc);

				mav.setViewName("/common/msg");
			}
		}

		return mav;
	}

	@RequestMapping("/lecture/lectureFormEnd.do")
	public ModelAndView insertLecture(Lecture lecture,
			@RequestParam(value = "cPage", required = false, defaultValue = "1") int cPage,
			@RequestParam(value = "freqs") String[] freqs, @RequestParam(value = "upFile") MultipartFile[] upFiles,
			HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();

		Map<String, Object> key = new HashMap<>();
		key.put("mno", lecture.getMno());
		key.put("key", "study");

		int result = 0;
		String msg = "";
		String loc = "/lecture/lectureList.do";

		List<Map<String, String>> locList = ls.selectLocList();
		List<Map<String, String>> kindList = ls.selectKindList();
		List<Map<String, String>> diffList = ls.selectDiff();

		mav.addObject("locList", locList);
		mav.addObject("kindList", kindList);
		mav.addObject("diffList", diffList);

		// 빈도 배열을 join해서 setter로 setting해줌
		String freq = String.join(",", freqs);
		lecture.setFreqs(freq);

		// 같은 날짜, 요일, 시간에 있는지를 검사해봅시다..
		List<Map<String, Object>> list = ls.selectLectureListByMno(key);

		int cnt = checkDate(lecture, list, freqs);

		if (cnt == 0) {
			// 1.파일업로드처리
			int l = 1;
			int last = upFiles.length;

			String img = "";
			String saveDirectory = request.getSession().getServletContext().getRealPath("/resources/upload/lecture");

			/****** MultipartFile을 이용한 파일 업로드 처리로직 시작 ******/
			for (MultipartFile f : upFiles) {
				if (!f.isEmpty()) {
					// 파일명 재생성
					String originalFileName = f.getOriginalFilename();
					String ext = originalFileName.substring(originalFileName.lastIndexOf(".") + 1);
					SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmssSSS");
					int rndNum = (int) (Math.random() * 1000);
					String renamedFileName = sdf.format(new Date(System.currentTimeMillis())) + "_" + rndNum + "."
							+ ext;

					if (l != last) {
						try {
							f.transferTo(new File(saveDirectory + "/" + renamedFileName));
						} catch (IllegalStateException e) {
							e.printStackTrace();
						} catch (IOException e) {
							e.printStackTrace();
						}

						img += renamedFileName + ",";
					}

					if (l == last) {
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

					l++;

				} else {
					lecture.setUpfile(img);
					result = ls.insertLecture(lecture);
				}
			}

			msg = "강의가 등록되었습니다.";
		} else {
			msg = "등록하시려는 시간대와 겹치는 강의 또는 스터디가 존재합니다.";
		}

		mav.addObject("msg", msg);
		mav.addObject("loc", loc);

		mav.setViewName("/common/msg");

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
	public ModelAndView lectureView(@RequestParam int sno, @RequestParam(required = false, defaultValue = "0") int mno,
			HttpSession session) {
		ModelAndView mav = new ModelAndView();

		Member m = (Member) session.getAttribute("memberLoggedIn");
		int realMNo = 0;

		int insert = 0;
		int wish = 0;

		try {
			realMNo = m.getMno();
		} catch (NullPointerException e) {
			realMNo = 0;
		}

		if (mno != 0 && mno != realMNo) {
			String msg = "잘못된 경로로 접근했다.";
			String loc = "/lecture/lectureList.do";

	         mav.addObject("msg", msg);
	         mav.addObject("loc", loc);

			mav.setViewName("/common/msg");
		} else {
			Map<String, Integer> map = new HashMap<>();
			map.put("sno", sno);

			// 이미 찜이 들어가 있는지, 신청을 했는지 확인.
			if (mno > 0) {
				map.put("mno", mno);

				wish = ls.lectureWish(map);
				insert = ls.preinsertApply(map);
			}

			Map<String, String> lecture = ls.selectLectureOne(sno);

			mav.addObject("lecture", lecture);

			mav.setViewName("lecture/lectureView");
		}

		mav.addObject("wish", wish);
		mav.addObject("insert", insert);

		return mav;
	}

	@RequestMapping("/lecture/deleteLecture.do")
	public ModelAndView deleteLecture(@RequestParam int sno) {
		ModelAndView mav = new ModelAndView();
		int result = ls.deleteLecture(sno);

		String msg = "강의를 삭제했습니다.";
		String loc = "/lecture/lectureList.do";

		mav.addObject("msg", msg);
		mav.addObject("loc", loc);

		mav.setViewName("/common/msg");

		return mav;
	}

	@RequestMapping("/lecture/deleteLectures")
	@ResponseBody
	public int deleteLectures(@RequestParam(value = "lectures[]") List<Integer> lectures) {
		Map<String, Object> map = new HashMap<>();

		map.put("lectures", lectures);

		int result = ls.deleteLectures(map);

		return result;
	}

	@RequestMapping(value = "/lecture/findLecture.do", produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String findLecture(@RequestParam int sno, @RequestParam int mno) {
		int result = 0;
		String msg = "";

		Map<String, Integer> preCheck = new HashMap<>();

		preCheck.put("sno", sno);
		preCheck.put("mno", mno);

		// 이미 강의가 들어가 있는지 확인.
		result = ls.preinsertApply(preCheck);

		// 강의에 남은 자릿수 확인.
		// 들어간 인원 확인.
		int peopleCnt = ls.peopleCnt(sno);
		int recruitCnt = ls.recruitCnt(sno);

		if (peopleCnt < recruitCnt) {
			if (result == 0) {
				Map<String, Object> key = new HashMap<>();

				key.put("mno", mno);
				key.put("key", "crew");

				// mno로 crew쪽 맵 뽑아오기.
				List<Map<String, Object>> list = ls.selectLectureListByMno(key);
				Lecture lecture = ls.selectLectureByMnoTypeLecture(sno);

				try {
					String[] freqs = lecture.getFreqs().split(",");
					int cnt = checkDate(lecture, list, freqs);

					if (cnt != 0)
						msg = "날짜나 요일, 시간이 겹치는 강의 또는 스터디가 존재합니다.";
				} catch (NullPointerException e) {
					msg = "";
				}
			} else {
				msg = "이미 신청한 강의입니다.";
			}
		} else {
			msg = "신청자 수가 초과했습니다.";
		}

		return msg;
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
			@RequestParam(value = "tno", defaultValue = "0") int tno, @RequestParam(value = "kno") int kno,
			@RequestParam(value = "subno", defaultValue = "0") int subno, @RequestParam(value = "dno") int dno,
			@RequestParam(value = "leadername") String leadername,
			@RequestParam(value = "cPage", required = false, defaultValue = "1") int cPage,
			@RequestParam(value = "searchCase") String searchCase) {
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
		terms.put("searchCase", searchCase);
		// 검색 조건에 따른 총 스터기 갯수

		int total = 0;
		List<Map<String, Object>> lectureList = null;
		if (searchCase.equals("deadline")) {
			total = ls.lectureDeadlineCount(terms);
			lectureList = ls.selectByDeadline(terms);
		} else if (searchCase.equals("search")) {
			System.out.println("서치에용ㅇ");
			total = ls.selectTotalLectureCountBySearch(terms);
			lectureList = ls.selectLectureListBySearch(terms);

		} else {// 신청자순
			System.out.println("신청자순이에용");
			total = ls.studyByApplyCount(terms);
			lectureList = ls.selectByApply(terms);
		}

		// 페이징 처리해서 가져온 리스트
		mav.addObject("list", lectureList);
		mav.addObject("total", total);
		mav.addObject("cPage", cPage + 1);

		return mav;
	}

	// 스크롤 페이징 처리 - 검색
	@RequestMapping("/lecture/lectureSearchAdd.do")
	public ModelAndView lectureSearchAdd(@RequestParam(value = "lno") int lno,
			@RequestParam(value = "tno", defaultValue = "0") int tno, @RequestParam(value = "kno") int kno,
			@RequestParam(value = "subno", defaultValue = "0") int subno, @RequestParam(value = "dno") int dno,
			@RequestParam(value = "leadername") String leadername,
			@RequestParam(value = "cPage", required = false) int cPage,
			@RequestParam(value = "searchCase") String searchCase) {
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
		terms.put("searchCase", searchCase);

		int total = 0;
		List<Map<String, Object>> lectureList = null;
		if (searchCase.equals("deadline")) {
			lectureList = ls.selectByDeadline(terms);
		} else if (searchCase.equals("search")) {
			System.out.println("서치에용ㅇ");
			lectureList = ls.selectLectureListBySearch(terms);

		} else {// 신청자순
			System.out.println("신청자순이에용");
			lectureList = ls.selectByApply(terms);
		}

		mav.addObject("list", lectureList);
		mav.addObject("cPage", cPage + 1);

		return mav;
	}

	@RequestMapping("/lecture/lectureWish.do")
	public String lectureWish(@RequestParam int sno, @RequestParam int mno) {
		ModelAndView mav = new ModelAndView();
		Map<String, Integer> map = new HashMap<>();

		map.put("sno", sno);
		map.put("mno", mno);

		int confirm = ls.lectureWish(map);

		if (confirm == 0)
			ls.addWishLecture(map);

		return "redirect:/lecture/lectureView.do?sno=" + sno + "&mno=" + mno;
	}

	@RequestMapping("/lecture/lectureWishCancel.do")
	public String lectureWishCancel(@RequestParam int sno, @RequestParam int mno) {
		Map<String, Integer> map = new HashMap<>();
		ModelAndView mav = new ModelAndView();

		map.put("sno", sno);
		map.put("mno", mno);

		ls.lectureWishCancel(map);

		return "redirect:/lecture/lectureView.do?sno=" + sno + "&mno=" + mno;
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
	public String seccessPay(@RequestParam int mno, @RequestParam int sno, @RequestParam(required = true) long pno,
			@RequestParam int price) {
		// 결제 테이블에 넣기.
		Map<String, Object> map = new HashMap<>();

		map.put("pno", pno);
		map.put("sno", sno);
		map.put("mno", mno);
		map.put("price", price);
		map.put("status", 1);

		ls.insertPay(map);

		// 장바구니 삭제
		Map<String, Integer> cancelMap = new HashMap<>();

		cancelMap.put("mno", mno);
		cancelMap.put("sno", sno);

		ls.lectureWishCancel(cancelMap);

		return "redirect:/lecture/lectureView.do?sno=" + sno + "&mno=" + mno;
	}

	@RequestMapping("/lecture/failedPay.do")
	public String failedPay(@RequestParam int mno, @RequestParam int sno, @RequestParam(required = true) long pno,
			@RequestParam int price) {
		Map<String, Object> map = new HashMap<>();

		map.put("pno", pno);
		map.put("sno", sno);
		map.put("mno", mno);
		map.put("price", price);
		map.put("status", 0);

		int result = ls.insertPay(map);

		return "redirect:/lecture/lectureView.do?sno=" + sno + "&mno=" + mno;
	}

	@RequestMapping("/lecture/selectPay.do")
	@ResponseBody
	public long selectPay(@RequestParam int sno, @RequestParam int mno) {

		Map<String, Integer> map = new HashMap<>();

		map.put("mno", mno);
		map.put("sno", sno);

		long impNo = ls.selectPay(map);

		return impNo;
	}

	@RequestMapping("/lecture/lectureCancel.do")
	@ResponseBody
	public String lectureCancel(@RequestParam int mno, @RequestParam int sno, @RequestParam long pno,
			@RequestParam int price) {
		Map<String, Integer> map = new HashMap<>();

		map.put("mno", mno);
		map.put("sno", sno);

		int result = 0;
		result = ls.lectureCancel(map);

		// 토큰 얻어오기.
		String originNo = "imp_" + String.valueOf(pno);
		String api_key = "6308212829698507";
		String api_secret = "UM9NCLWi3ZclaqermTlctrUKXiMQ80q2NzPpkMIoMUKWlYoHSKUmbO697SZfTpiGZ86kUOJGJtD4r2Mj";

		IamportClient imp = new IamportClient(api_key, api_secret);
		imp.getAuth();

		IamportResponse<Payment> p = imp.cancelPaymentByImpUid(new CancelData(originNo, true));

		int success = p.getCode();
		String msg = "";

		// 아임포트에서 결제취소가 성공한 경우.
		if (success == 1 || success == 0) {
			msg = "결제취소";

			ls.successPayCancel(pno);
		}
		// 실패한 경우
		else {
			msg = "결제 취소가 실패했습니다. 관리자에게 문의하세요.";
		}

		return msg;
	}

	@RequestMapping("/lecture/lectureAdminCancel.do")
	@ResponseBody
	public String lectureAdminCancel(@RequestParam int mno, @RequestParam int sno, @RequestParam long pno,
			@RequestParam int price) {
		Map<String, Integer> map = new HashMap<>();

		map.put("mno", mno);
		map.put("sno", sno);

		int result = 0;
		result = ls.lectureCancel(map);

		String originNo = "imp_" + String.valueOf(pno);
		String api_key = "6308212829698507";
		String api_secret = "UM9NCLWi3ZclaqermTlctrUKXiMQ80q2NzPpkMIoMUKWlYoHSKUmbO697SZfTpiGZ86kUOJGJtD4r2Mj";

		// 토큰 얻어오기.
		IamportClient imp = new IamportClient(api_key, api_secret);
		imp.getAuth();

		IamportResponse<Payment> p = imp.cancelPaymentByImpUid(new CancelData(originNo, true));

		int success = p.getCode();
		String msg = "";

		// 아임포트에서 결제취소가 성공한 경우.
		if (success == 1 || success == 0) {
			msg = "결제취소";

			ls.successAdminPayCancel(pno);
		}
		// 실패한 경우
		else {
			msg = "결제 취소가 실패했습니다. 관리자에게 문의하세요.";
		}

		return msg;
	}

	// 관리자 강의페이지 - 률멘 방식
	@RequestMapping(value = "/lecture/all/{cPage}/{count}", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView selectLecturePageCount(@PathVariable(value = "count", required = false) int count,
			@PathVariable(value = "cPage", required = false) int cPage) {

		ModelAndView mav = new ModelAndView("jsonView");
		List<Map<String, Object>> list = ls.selectLectureList(cPage, count);
		int total = ls.selectTotalLectureCount();

		mav.addObject("list", list);
		mav.addObject("numPerPage", count);
		mav.addObject("cPage", cPage);
		mav.addObject("total", total);
		return mav;
	}

	@RequestMapping(value = "/lecture/searchAdminLecture/{cPage}/{count}", method = RequestMethod.GET)
	public ModelAndView searhAdminLecture(@PathVariable(value = "count", required = false) int count,
			@PathVariable(value = "cPage", required = false) int cPage, @RequestParam(required = false) int lno,
			@RequestParam(required = false) int tno, @RequestParam(required = false) int subno,
			@RequestParam(required = false) int kno, @RequestParam(required = false, defaultValue = "전체") String leader,
			@RequestParam(required = false, defaultValue = "전체") String title,
			@RequestParam(required = false) String year, @RequestParam(required = false) String month,
			@RequestParam(required = false, defaultValue = "전체") String status) {
		ModelAndView mav = new ModelAndView("jsonView");

		Map<String, Object> map = new HashMap<>();

		map.put("lno", lno);
		map.put("tno", tno);
		map.put("subno", subno);
		map.put("kno", kno);
		map.put("leader", leader);
		map.put("title", title);
		map.put("year", year);
		map.put("month", month);
		map.put("status", status);

		System.out.println(map);

		int total = ls.selectTotalAdminLectureCount(map);

		List<Map<String, String>> list = ls.searchAdminLectureList(cPage, count, map);

		mav.addObject("list", list);
		mav.addObject("cPage", cPage);
		mav.addObject("total", total);
		mav.addObject("numPerPage", count);

		return mav;
	}

	@RequestMapping(value = "/lecture/pay/{cPage}/{count}", method = RequestMethod.GET)
	@ResponseBody
	public ModelAndView adminPayment(@PathVariable(value = "count", required = false) int count,
			@PathVariable(value = "cPage", required = false) int cPage,
			@RequestParam(required = false, defaultValue = "") String member,
			@RequestParam(required = false, defaultValue = "0") int price, 
			@RequestParam(required = false) String year,
			@RequestParam(required = false, defaultValue="전체") String month, @RequestParam(required = false) String status) {
		ModelAndView mav = new ModelAndView("jsonView");

		Map<String, Object> key = new HashMap<>();

		key.put("member", member);
		key.put("price", price);
		key.put("year", year);
		key.put("month", month);
		key.put("status", status);

		int total = ls.selectTotalPayCount();
		int numPerPage = 10;

		List<Map<String, String>> list = ls.selectPayList(cPage, numPerPage, key);

		System.out.println(list);

		mav.addObject("list", list);
		mav.addObject("cPage", cPage);
		mav.addObject("total", total);
		mav.addObject("numPerPage", numPerPage);

		return mav;
	}

	public int checkDate(Lecture lecture, List<Map<String, Object>> list, String[] freqs) {
		int cnt = 0;

		if (!list.isEmpty()) {
			// 시간 뽑기
			// 등록 될 시간들.
			long lectureSdate = lecture.getSdate().getTime();
			long lectureEdate = lecture.getEdate().getTime();

			// 뽑아올 시간들.
			String[] times = lecture.getTime().split("~");

			int sHour = Integer.parseInt(times[0].split(":")[0]);
			int eHour = Integer.parseInt(times[1].split(":")[0]);

			for (int i = 0; i < list.size(); i++) {
				Date sdate = (Date) list.get(i).get("SDATE");
				Date edate = (Date) list.get(i).get("EDATE");

				// 등록된 날짜들에 포함되지 않는 경우
				if (lectureEdate < sdate.getTime() || lectureSdate > edate.getTime()) {
					System.out.println("날짜가 안겹쳐서 들어감");
				}
				// 포함되는 경우
				else if (lectureSdate >= sdate.getTime() || lectureEdate <= edate.getTime()) {
					// 요일을 검사해보자...
					for (int j = 0; j < freqs.length; j++) {
						if (list.get(i).containsValue(freqs[j])) {
							// 등록이 가능한 경우.
							if (sHour > Integer.parseInt(list.get(j).get("ETIME").toString())
									|| eHour < Integer.parseInt(list.get(j).get("STIME").toString())) {
								System.out.println("시간이 안겹쳐서 들어감");
							}
							// 불가능한 경우.
							else {
								cnt++;
							}
						} else {
							System.out.println("요일이 안겹쳐서 들어감");
						}
					}
				}
			}
		}

		return cnt;
	}

	@RequestMapping("/lecture/uploadImage.do")
	@ResponseBody
	public Map<String, String> uploadImage(@RequestParam("file") MultipartFile f, HttpServletRequest request) {

		String renamedFileName = "";
		String saveDirectory = "";
		Map<String, String> map = new HashMap<>();

		try {
			// 1. 파일업로드처리
			saveDirectory = request.getSession().getServletContext().getRealPath("/resources/upload/lecture");
			if (!f.isEmpty()) {
				// 파일명재생성
				String originalFileName = f.getOriginalFilename();
				String ext = originalFileName.substring(originalFileName.lastIndexOf(".") + 1);
				SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmssSSS");
				int rndNum = (int) (Math.random() * 1000); // 0~9999
				renamedFileName = sdf.format(new Date(System.currentTimeMillis())) + "_" + rndNum + "." + ext;

				try {
					f.transferTo(new File(saveDirectory + "/" + renamedFileName)); // 실제저장하는코드.
				} catch (IllegalStateException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		} catch (Exception e) {
			throw new RuntimeException("이미지등록오류");
		}

		map.put("url", renamedFileName);
		return map;
	}
}