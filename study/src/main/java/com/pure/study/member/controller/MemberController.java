package com.pure.study.member.controller;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.mail.internet.MimeMessage;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.socket.TextMessage;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.pure.study.board.model.service.BoardService;
import com.pure.study.board.model.service.ReplyService;
import com.pure.study.common.crontab.dao.SchedulerDAO;
import com.pure.study.common.websocket.EchoHandler;
import com.pure.study.lecture.model.service.LectureService;
import com.pure.study.member.model.exception.MemberException;
import com.pure.study.member.model.service.MemberService;
import com.pure.study.member.model.vo.Instructor;
import com.pure.study.member.model.vo.Member;
import com.pure.study.member.model.vo.Review;
import com.pure.study.message.model.service.MessageService;
import com.pure.study.message.model.vo.Message;
import com.pure.study.rest.RestMemberService;
import com.pure.study.study.model.service.StudyService;
import com.pure.study.study.model.vo.Study;
import com.siot.IamportRestClient.IamportClient;
import com.siot.IamportRestClient.request.CancelData;
import com.siot.IamportRestClient.response.IamportResponse;
import com.siot.IamportRestClient.response.Payment;

@SessionAttributes({ "memberLoggedIn" })
@Controller
public class MemberController {

	// private Logger logger = LoggerFactory.getLogger(getClass());

	@Autowired
	private MemberService memberService;

	@Autowired
	private StudyService studyService;

	@Autowired
	private LectureService ls;
	
	@Autowired
	private BCryptPasswordEncoder bcryptPasswordEncoder;

	@Autowired
	private JavaMailSender mailSender;
	
	@Autowired
	private ReplyService replyService;
	
	@Autowired
	private BoardService boardService;
	
	@Autowired
	private RestMemberService rs;
	

	@Autowired
	private SchedulerDAO schedulerDAO;
	
	/*김률민 추가 20180708 메시징 추가  *************************************************/
	@Autowired
	private MessageService messageService;
	
	@Autowired
	private EchoHandler echoHandler; 
	/*김률민 추가 20180708 메시징 추가  *************************************************/
	
	Logger logger = LoggerFactory.getLogger(getClass());

	/********************************** 회원가입(장익순) 시작 */
	@RequestMapping(value = "/member/memberAgreement.do")
	public ModelAndView memberAgreement() {
		logger.info("회원동의홈페이지");
		if (logger.isDebugEnabled()) {
			logger.debug("회원동의홈페이지");
		}
		ModelAndView mav = new ModelAndView();
		try {
			List <Map<String , String>> service = memberService.serviceagree();
			List <Map<String , String>> information = memberService.informationagree();
			System.out.println(service);
			System.out.println(information);
			
			mav.addObject("service", service);
			mav.addObject("information", information);
			
		} catch (Exception e) {
		}
		return mav;
	}

	/* 정보 입력페이지 이동 시작 */
	@RequestMapping(value = "/member/memberEnroll.do")
	public ModelAndView memberEnroll(@RequestParam(value = "check", required = false, defaultValue = "1") int check,
			@RequestParam(value = "agree1", required = false, defaultValue = "2") int agree1,
			@RequestParam(value = "agree2", required = false, defaultValue = "2") int agree2) {

		if (logger.isDebugEnabled()) {
			logger.debug("회원등록홈페이지");
		}
		System.out.println(check);
		ModelAndView mav = new ModelAndView();
		int c = check + agree1 + agree2;
		System.out.println(c);
		if (c != 23) {
			String loc = "/member/memberAgreement.do";
			String msg = "잘못된 경로 입니다. 관리자에게 문의 하세요.";
			mav.addObject("msg", msg);
			mav.addObject("loc", loc);
			mav.setViewName("common/msg");
			return mav;
		}
		try {
			List<Map<String, String>> list = memberService.selectCategory();
			
			System.out.println(list);
			mav.addObject("list", list);
			
		} catch (Exception e) {
		}
		return mav;
	}

	/* mailSending 코드 전송 */
	@RequestMapping(value = "/member/certification.do")
	@ResponseBody
	public Map<String, Object> mailCertification(HttpServletRequest request, @RequestParam(value = "em") String em) {
		Map<String, Object> map = new HashMap<>();
		String setfrom = "kimemail201807@gmail.com";
		String tomail = em; // 받는 사람 이메일
		String title = "( 스터디 그룹트 ) 회원가입 인증번호 내역"; // 제목
		String content = "회원님 \n인증번호는  "; // 내용
		String ranstr = "";
		for (int i = 0; i < 4; i++) {
			int ran = (int) (Math.random() * 10);
			ranstr += ran;
		}
		/* 멤버 이메일 확인 */
		System.out.println("tomail"+tomail);
		try {
			int result = memberService.memberCheckEmail(tomail);
			if(result >1) {
				System.out.println("이미 가입?");
				map.put("check", false);
				return map;
			}
			
		} catch (Exception e) {
		}
		

		try {
			/* 이메일 insert /update 구분  */
			String encoded = bcryptPasswordEncoder.encode(ranstr);
			content += ranstr;
			
			
			
			
			System.out.println("1 :");
			int checkemail = memberService.checkEmail(tomail);
			System.out.println("2 :");

			if (checkemail == 0) {
				memberService.insertMailCertification(tomail, encoded);
				System.out.println("3 :");
			} else {
				memberService.uploadMailCertification(tomail, encoded);
			}
			System.out.println("4 :");
			MimeMessage message = mailSender.createMimeMessage();
			System.out.println("5 :");
			MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "UTF-8");
			System.out.println("6 :");
			messageHelper.setFrom(setfrom); // 보내는사람 생략하거나 하면 정상작동을 안함
			messageHelper.setTo(tomail); // 받는사람 이메일
			messageHelper.setSubject(title); // 메일제목은 생략이 가능하다
			messageHelper.setText(content); // 메일 내용
			System.out.println("7 :");
			mailSender.send(message);
		} catch (Exception e) {
			System.out.println("혹시 에러?");
			map.put("check", false);
			return map;
		}
		map.put("check", true);
		return map;
	}

	/* mailSending 코드 검증 */
	@RequestMapping(value = "/member/checkJoinCode.do")
	@ResponseBody
	public Map<String, Object> checkJoinCode(HttpServletRequest request, @RequestParam(value = "em") String em,
			@RequestParam(value = "inputCode") String inputCode) {
		Map<String, Object> map = new HashMap<>();
		String email = em;
		System.out.println(email);
		Map<String, String> cer = new HashMap<>();
		System.out.println(cer);
		try {
			cer = memberService.selectCheckJoinCode(email);
			
		} catch (Exception e) {
		}
		if (bcryptPasswordEncoder.matches(inputCode, cer.get("CERTIFICATION"))) {
			map.put("result", true);
		} else {
			map.put("result", false);
		}
		System.out.println(map);
		return map;
	}

	/* 주소입력 */
	@RequestMapping(value = "/member/jusoPopup.do")
	public String jusoPopup() {
		return "member/jusoPopup";
	}

	/* 파일 업로드 시작 */
	@RequestMapping(value = "/member/memberImgUpload.do")
	public ModelAndView insertBoard(Model model,
			@RequestParam(value = "upFile", required = false) MultipartFile[] upFiles, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		logger.debug("게시판 페이지저장");
		logger.debug("upFiles.length=" + upFiles.length);
		logger.debug("upFile1=" + upFiles[0].getOriginalFilename());

		Map<String, String> map = new HashMap<>();

		// 1.파일업로드처리
		String saveDirectory = request.getSession().getServletContext().getRealPath("/resources/upload/member");
		String renamedFileName = "";
		/****** MultipartFile을 이용한 파일 업로드 처리로직 시작 ******/
		for (MultipartFile f : upFiles) {
			if (!f.isEmpty()) {
				// 파일명 재생성
				String originalFileName = f.getOriginalFilename();
				String ext = originalFileName.substring(originalFileName.lastIndexOf(".") + 1);
				SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmssSSS");
				int rndNum = (int) (Math.random() * 1000);
				renamedFileName = sdf.format(new Date(System.currentTimeMillis())) + "_" + rndNum + "." + ext;
				try {
					f.transferTo(new File(saveDirectory + "/" + renamedFileName));
				} catch (IllegalStateException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		/****** MultipartFile을 이용한 파일 업로드 처리로직 끝 ******/

		// 3.view단 분기
		logger.debug(renamedFileName);
		map.put("renamedFileName", renamedFileName);

		mav.addAllObjects(map);
		mav.setViewName("jsonView");

		return mav;
	}

	/* 회원가입 시작 */
	@RequestMapping(value = "/member/memberEnrollEnd.do", method = RequestMethod.POST)
	public String memberEnrollEnd(Model model, Member member) {
		if (logger.isDebugEnabled()) {
			logger.debug("회원가입완료");
		}
		/* 이메일 가져오기 */
		String email = member.getEmail();
		String[] emailArr = email.split(",");
		email = emailArr[0] + "@" + emailArr[1];
		System.out.println("member : " + member);
		logger.debug(email);
		member.setEmail(email);
		String loc = "/";
		String msg = "";
		try {
			Map<String, String> cer = memberService.selectCheckJoinCode(email);
			System.out.println("email : " + email);
			if (cer == null) {
				msg = "회원가입을 실패했습니다.";
				model.addAttribute("loc", loc);
				model.addAttribute("msg", msg);
				return "common/msg";
			}
		} catch (Exception e) {
		}
		/**
		 * 탈퇴 회원 여부 확인 탈퇴 회원일 경우 EXP/POINt/NPOINT 가져오고 set해준다
		 */

		try {
			int memberCheckEmail = memberService.memberCheckEmail(email);
			if (memberCheckEmail == 2) {
				msg = "회원가입을 실패했습니다. 탈퇴 확인을 해주세요";
				msg = "회원가입실패!";
				model.addAttribute("loc", loc);
				model.addAttribute("msg", msg);
				return "common/msg";
			} else if (memberCheckEmail == 1) {
				Member memberGetPoint = memberService.memberGetPoint(email);
				member.setExp(memberGetPoint.getExp());
				member.setPoint(memberGetPoint.getPoint());
				member.setNPoint(memberGetPoint.getNPoint());

			} else {
				member.setExp(0);
				member.setPoint(0);
				member.setNPoint(0);
			}
		} catch (Exception e) {
			msg = "회원가입을 실패했습니다. 관리자에게 문의 하세요";
			msg = "회원가입실패!";
			model.addAttribute("loc", loc);
			model.addAttribute("msg", msg);
			return "common/msg";
		}
		System.out.println("member : " + member);
		logger.debug(email);

		String rawPassword = member.getPwd();
		/******* password 암호화 시작 *******/
		String encodedPassword = bcryptPasswordEncoder.encode(rawPassword);
		member.setPwd(encodedPassword);
		/******* password 암호화 끝 *******/

		/* favor null일 경우 처리 */
		if (member.getFavor() == null) {
			String[] favor = new String[1];
			favor[0] = "no";
			member.setFavor(favor);
		}

		int result = 0;
		try {
			result = memberService.memberEnrollEnd(member);
			memberService.deleteCertification(email);
		} catch (Exception e) {
		}


		// 2.처리결과에 따라 view단 분기처리

		if (result > 0)
			msg = "회원가입성공!";
		else {
			msg = "회원가입실패!";
			model.addAttribute("loc", loc);
			model.addAttribute("msg", msg);
			return "common/msg";
		}
		model.addAttribute("check", "현직 강사님이신가요? 강사님이시라면 <a href=\"#\" onclick=\"fn_instruct();\">강사신청</a>");

		return "member/memberSuccess";
	}

	/* ID 중복 검사 시작 */
	@RequestMapping(value = "/member/checkIdDuplicate.do")
	@ResponseBody
	public Map<String,Object> checkIdDuplicate(@RequestParam("userId") String userId) throws IOException {
		logger.debug("@ResponseBody-javaobj ajax : "+userId);
		Map<String,Object> map = new HashMap<>();
		try {
			int count = memberService.checkIdDuplicate(userId);
			logger.debug("count : "+count);
			boolean isUsable = count==0?true:false;
			logger.debug(""+isUsable);
			
			map.put("isUsable", isUsable);
		} catch (Exception e) {
		}
		
		return map;
	}

	/* 회원가입(장익순) 끝 *********************************/
	/********************************************** 로그인 및 마이페이지(김회진) 시작 */
	/******************************* 로그인&로그아웃 시작 */
	@RequestMapping(value = "/member/memberLogin.do", method = RequestMethod.POST)
	public ModelAndView memberLogin(HttpServletRequest request, @RequestParam(value = "userId") String userId,
			@RequestParam(value = "pwd") String pwd, @RequestParam(value = "admin", required = false) String admin) {
		ModelAndView mav = new ModelAndView();
		
		/*김률민 추가 로그인시 이전 페이지로 바로 갈수 있게 처리*/
		String referer = request.getHeader("Referer");
		String root = request.getRequestURL().toString().replaceAll(request.getRequestURI(), "");
		String prev = referer.replaceAll(root, "").replaceFirst("/study", "");
		Member m = memberService.selectOneMember(userId);

		String msg = "";
		String loc = "/";

		if (m == null || m.getQdate() != null) {
			msg = "존재하지 않는 아이디입니다.";
		} else {
			if (bcryptPasswordEncoder.matches(pwd, m.getPwd())) {
				// msg = "로그인성공!";
				mav.addObject("memberLoggedIn", m);
				
				
				/*김률민 추가 */
				Map<String, Object> rmMap = new HashMap<>();
				String ip =request.getHeader("X-FORWARDED-FOR");
				Calendar calendar = Calendar.getInstance();
				SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss:SSS");
				if (ip == null || ip.length() == 0) {
			         ip = request.getHeader("Proxy-Client-IP");
			     }
			     if (ip == null || ip.length() == 0) {
			         ip = request.getHeader("WL-Proxy-Client-IP"); 
			     }
			     if (ip == null || ip.length() == 0) {
			         ip = request.getRemoteAddr() ;
			     }
				rmMap.put("member", m);
				rmMap.put("ip", ip);
				rmMap.put("time", dateFormat.format(calendar.getTime()));
				rmMap.put("log", "login");
				rs.addMember(rmMap);
				/*김률민 추가 */
								
				if(admin==null) {
					if(prev.contains("memberSuccess")) {
						mav.setViewName("redirect:/");
					}else if(prev.contains("FindPage.do")||prev.contains("memberPwd.do")) {
						mav.setViewName("redirect:/");
					}else {
						mav.setViewName("redirect:"+prev);
					}
				}else {
					mav.setViewName("redirect:/admin/adminMain"); 
				}

				return mav;
			} else {
				msg = "비밀번호가 틀렸습니다.";
			}

		}
		mav.addObject("msg", msg);
		mav.addObject("loc", loc);
		mav.setViewName("common/msg");

		return mav;
	}

	@RequestMapping(value="/member/memberLogout.do")
	public String memberLogout(SessionStatus sessionStatus, HttpServletRequest request) {
		/* 김률민 추가*/
		Map<String, Object> rmMap = new HashMap<>();
		String ip =request.getHeader("X-FORWARDED-FOR");
		if (ip == null || ip.length() == 0) {
	         ip = request.getHeader("Proxy-Client-IP");
	     }
	     if (ip == null || ip.length() == 0) {
	         ip = request.getHeader("WL-Proxy-Client-IP"); 
	     }
	     if (ip == null || ip.length() == 0) {
	         ip = request.getRemoteAddr() ;
	     }
	     
		Calendar calendar = Calendar.getInstance();
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss:SSS");

	    rmMap.put("member", ((Member) request.getSession().getAttribute("memberLoggedIn"))); 
	    rmMap.put("ip", ip);
	    rmMap.put("time", dateFormat.format(calendar.getTime()));
		rmMap.put("log", "logout");
		rs.addMember(rmMap);
		/* 김률민 추가*/
		if (!sessionStatus.isComplete())
			sessionStatus.setComplete();

		return "redirect:/";
	}

	/* 로그인&로그아웃 끝 *********************************/

	/**************** id, pwd찾기 */
	// 아이디,비밀번호 찾기 페이지로 이동
	@RequestMapping(value = "/member/memberFindPage.do")
	public ModelAndView memberFindPage(@RequestParam("findType") String findType) {

		ModelAndView mav = new ModelAndView();

		mav.addObject("findType", findType); // findType - 아이디/비밀번호
		mav.setViewName("member/memberFind");

		return mav;
	}

	// 아이디 찾기 페이지이면, 바로 아이디를 맨 뒤의 2자리를 제외하고 알려준다.
	// 비밀번호 찾기 페이지면, 비밀번호 찾는 페이지로 이동
	@RequestMapping(value = "/member/memberFindIdPwd.do")
	public ModelAndView memberFindId(@RequestParam("mname") String mname, @RequestParam("email") String email,
			@RequestParam("findType") String findType) {
		ModelAndView mav = new ModelAndView();

		Member fm = new Member();
		fm.setMname(mname);
		fm.setEmail(email);

		Member m = memberService.selectOneMember(fm);

		String msg = "";
		String loc = "/";

		System.out.println(findType);

		// id 찾기
		if (m != null && findType.equals("아이디")) {

			String mid = m.getMid();
			mid = mid.substring(0, mid.length() - 2);

			mav.addObject("findType", findType);
			mav.addObject("mid", mid);
			mav.setViewName("member/memberFind");
		} else if (m == null && findType.equals("아이디")) {
			msg = "존재 하지 않는 회원 입니다. ";
			mav.addObject("msg", msg);
			mav.addObject("loc", "/member/memberFindPage.do?findType=아이디");
			mav.setViewName("common/msg");
		} else if (findType.equals("비밀번호")) {

			mav.addObject("findType", findType);
			mav.setViewName("member/memberFind");
		}

		return mav;
	}

	// ****************(방법1)비밀번호 변경 페이지 보내주기*********************

	// 이메일로 비밀번호 변경 페이지를 보내준다.
			@RequestMapping(value = "/member/mailSending.do", method = RequestMethod.POST)
			public ModelAndView mailSending(HttpServletRequest request, @RequestParam String mid, @RequestParam String email) {
				ModelAndView mav = new ModelAndView();
				String msg = "";
				String loc = "/";

				// 1. 페이지의 인증키를 생성한다.
				String tempPwd = "";
				int tempSize = 8;
				char[] temp = new char[tempSize];

				// 48~57- 숫자, 65~90- 대문자, 97~122- 소문자
				for (int i = 0; i < tempSize; i++) {
					int rnd = (int) (Math.random() * 122) + 48;
					if (rnd > 48 && rnd < 57 || rnd > 65 && rnd < 90 || rnd > 97 && rnd < 122) {
						temp[i] = (char) rnd;
						tempPwd += temp[i];
					} else {
						i--;
					}
				}

				// 2. 입력한 아이디와 이메일이 일치하는지 확인
				Member equalM = new Member();
				equalM.setMid(mid);
				equalM.setEmail(email);
				int resultEqual = memberService.selectCntMember(equalM);

				// 3. 입력한 아이디와 이메일이 일치하면 이메일로 비밀번호 변경 페이지를 전송함.
				if (resultEqual > 0) {

					try {
						MimeMessage message = mailSender.createMimeMessage();
						MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "UTF-8");

						msg = "비밀번호 변경을 메일로 발송하였습니다.";

						messageHelper.setFrom("kimemail2018@gmail.com"); // 보내는사람 생략하거나 하면 정상작동을 안함
						messageHelper.setTo(email); // 받는사람 이메일
						messageHelper.setSubject("스터디 그룹 비밀번호 변경"); // 메일제목은 생략이 가능하다

						// 4. 인증키를 암호화 한다.
						Member changeM = new Member();
						String encodedPassword = bcryptPasswordEncoder.encode(tempPwd);
						changeM.setPwd(encodedPassword);
						changeM.setMid(mid);

						// 4.1 암호화 한 인증키를 디비에 넣어준다.(임시 비밀번호처럼 )
						int result = memberService.updatePwd(changeM);

						// 4.2 메일 내용에 form을 이용하여 비밀번호를 변경하고자 하는 아이디와 인증키(페이지의 유효성?을 위해)를 보내준다.
						messageHelper.setText(new StringBuffer().append(
								"<form action='http://localhost:9090/study/member/memberPwd.do' target=\"_blank\" method='post'>")
								.append("<input type='hidden' name='mid' value='" + mid + "'/>")
								.append("<input type='hidden' name='key' value='" + encodedPassword + "'/>")
								.append("<h4>Study Grooupt 비밀번호 변경</h4>")
								.append("<button type='submit' style='background: #ffffff; color: #666; border: 1px solid #666; border-radius: 10px;'>비밀번호 변경하러 가기</button>").append("</form>").toString(), true); // 메일

						mailSender.send(message);
					} catch (Exception e) {
						e.getStackTrace();
					}

				} else {
					msg = "일치하는 회원 정보가 없습니다.";
					loc="/member/memberFindPage.do?findType=비밀번호";
				}

				mav.addObject("loc", loc);
				mav.addObject("msg", msg);

				mav.setViewName("common/msg");

				return mav;
			}
			
		// 5. 암호화 한 인증키를 이동시켜준다.
		@RequestMapping(value = "/member/memberPwd.do", method = RequestMethod.POST)
		public ModelAndView pwd(@RequestParam(value="mid") String mid, @RequestParam(value="key") String key) {
			ModelAndView mav = new ModelAndView();

			// System.out.println("이동 중인 값 : "+ key);

			// 인코딩 된 키 값과 디비에 있는 값(임시 비밀번호)을 비교하고 맞으면 비밀번호를 바꿔준다.
			Member m = memberService.selectOneMember(mid);

			if (key.equals(m.getPwd())) {
				mav.setViewName("member/memberUpdatePwd");
			} else {
				System.out.println("값은 있지만 비번이 서로 매치가 안됨");// 유효성
				mav.addObject("loc", "/");
				mav.addObject("msg", "이미 비밀번호를 변경하셨습니다.");
				mav.setViewName("common/msg");

			}

			mav.addObject("mid", mid);
			mav.addObject("key", key);

			return mav;

			/*
			 * mav.addObject("mid", mid); mav.addObject("key", key);
			 * mav.setViewName("member/memberUpdatePwd");
			 * 
			 * return mav;
			 */
		}

		// 6. 디비의 임시 비밀번호와 페이지 이동을 통한 인증키 비교(페이지 유효성 검사)
		@RequestMapping(value = "/member/memberUpdatePwd.do", method = RequestMethod.POST)
		public String updatePwd(@RequestParam("pwd") String pwd, @RequestParam("key") String key,
				@RequestParam("mid") String mid, Model model) {
			String loc = "/";
			String msg = "";

			// 인코딩 된 키 값과 디비에 있는 값(임시 비밀번호)을 비교하고 맞으면 비밀번호를 바꿔준다.
			Member m = memberService.selectOneMember(mid);

			if (m == null) {
				msg = "이미 비밀번호를 변경하셨습니다.";
				System.out.println("mid 잘못 가져옴");
			} else {
				// 인증키와 디비값 비교
				if (key.equals(m.getPwd())) {
					msg = "비밀번호 변경!";
					Member changeM = new Member();
					String encodedPassword = bcryptPasswordEncoder.encode(pwd);
					changeM.setPwd(encodedPassword);
					changeM.setMid(mid);

					// 사용자가 입력한 비밀번호로 디비값 변경
					int result = memberService.updatePwd(changeM);

				} else {
					System.out.println("값은 있지만 비번이 서로 매치가 안됨");// 유효성
					msg = "이미 비밀번호를 변경하셨습니다.";
				}

			}

			model.addAttribute("loc", loc);
			model.addAttribute("msg", msg);

			return "common/msg";
		}

	/*
	 * // *********************(방법2)임시 비밀번호 메일로 보내기*********************
	 * 
	 * @RequestMapping(value = "/member/mailSending.do", method=RequestMethod.POST)
	 * public ModelAndView mailSending(HttpServletRequest request, @RequestParam
	 * String mid, @RequestParam String email) { ModelAndView mav = new
	 * ModelAndView(); String msg=""; String loc="/";
	 * 
	 * //디비에서 회원 아이디와 이메일 가져오기 Member equalM = new Member(); equalM.setMid(mid);
	 * equalM.setEmail(email); int resultEqual =
	 * memberService.selectCntMember(equalM);
	 * 
	 * //디비를 통해 회원 아이디와 이메일을 비교해서 일치하는 디비 값 확인 if(resultEqual>0) { //임시 비밀번호 생성
	 * String tempPwd = ""; int tempSize = 8; char[] temp = new char[tempSize];
	 * 
	 * //48~57- 숫자, 65~90- 대문자, 97~122- 소문자 for(int i=0; i<tempSize; i++) { int rnd
	 * = (int)(Math.random()*122)+48;
	 * if(rnd>48&&rnd<57||rnd>65&&rnd<90||rnd>97&&rnd<122) { temp[i] = (char)rnd;
	 * tempPwd += temp[i]; } else { i--; } }
	 * 
	 * 
	 * //이메일을 보내면서 디비의 비밀번호를 임시비밀번호로 update 한다. Member changeM = new Member();
	 * String encodedPassword = bcryptPasswordEncoder.encode(tempPwd);
	 * changeM.setPwd(encodedPassword); changeM.setMid(mid);
	 * 
	 * int result = memberService.updatePwd(changeM);
	 * 
	 * if(result>0) { msg="회원 가입시 입력한 이메일로 임시 비밀번호를 발송했습니다."; try { //이메일 발송 코드
	 * MimeMessage message = mailSender.createMimeMessage(); MimeMessageHelper
	 * messageHelper = new MimeMessageHelper(message, true, "UTF-8");
	 * 
	 * messageHelper.setFrom("kimemail2018@gmail.com"); // 보내는사람 생략하거나 하면 정상작동을 안함
	 * messageHelper.setTo(email); // 받는사람 이메일
	 * messageHelper.setSubject("스터디 그룹 임시 비밀번호 발송"); // 메일제목은 생략이 가능하다
	 * messageHelper.setText("당신의 임시 비밀번호는 "+tempPwd+"입니다."); // 메일 내용
	 * 
	 * mailSender.send(message); } catch(Exception e){ e.getStackTrace(); }
	 * 
	 * }else { msg="오류 발생!!!";
	 * 
	 * }
	 * 
	 * } else { msg="일치하는 아이디나 이메일이 없습니다.";
	 * loc="/member/memberFindPage.do?findType=비밀번호"; }
	 * 
	 * mav.addObject("loc", loc); mav.addObject("msg", msg);
	 * 
	 * mav.setViewName("common/msg");
	 * 
	 * return mav; }
	 */
	/* id,pwd 찾기 ******************************/

	/**************************** 개인 정보 수정 시작 */
	// 개인 정보 수정 페이지로 이동
	@RequestMapping(value = "/member/memberView.do")
	public ModelAndView memberView(@ModelAttribute("memberLoggedIn") Member m) {
		ModelAndView mav = new ModelAndView();

		List<Map<String, String>> favor = memberService.selectKind();

		m = memberService.selectOneMember(m);

		if (m != null) {
			System.out.println(m);
			mav.addObject("memberLoggedIn", m);
			mav.addObject("favor", favor);
			mav.setViewName("member/memberView");
		} else {
			mav.addObject("msg", "로그인 후 이용해 주세요");
			mav.addObject("loc", "/");

			mav.setViewName("common/msg");

		}

		return mav;
	}

	// 개인 정보 수정 - 비밀번호 변경
	@RequestMapping(value = "/member/newPwd.do", method = RequestMethod.POST)
	public String newPwd(@RequestParam("newPwd") String newPwd, @RequestParam("oldPwd") String oldPwd,
			@ModelAttribute("memberLoggedIn") Member m, SessionStatus sessionStatus, Model model) {

		Member oldMember = memberService.selectOneMember(m.getMid());

		if (bcryptPasswordEncoder.matches(oldPwd, oldMember.getPwd())) {
			Member changeM = new Member();
			String encodedPwd = bcryptPasswordEncoder.encode(newPwd);
			changeM.setPwd(encodedPwd);
			changeM.setMid(m.getMid());

			int result = memberService.updatePwd(changeM);

			if (result > 0) {

				if (!sessionStatus.isComplete())
					sessionStatus.setComplete();
				model.addAttribute("loc", "/");
				model.addAttribute("msg", "비밀번호가 변경되었습니다. 다시 로그인 해주세요.");

				return "common/msg"; 
			} else {
				model.addAttribute("loc", "/member/memberView.do");
				model.addAttribute("msg", "비밀번호가 변경되지 않았습니다.");

			}
		} else {
			model.addAttribute("loc", "/member/memberView.do");
			model.addAttribute("msg", "비밀번호가 일치 하지 않습니다.");
		}

		return "common/msg";
	}
	
	//redirect:/사용하면서 msg 주기 위해 추가함.
	@RequestMapping(value="/msg.do")
	public String sendMsg(Model model, @ModelAttribute(value="memberLoggedIn") Member m) {
		
		model.addAttribute("loc", "/");
		model.addAttribute("msg", "다시 로그인 해주세요.");
		
		if("manager".equals(m.getMid())) {
			model.addAttribute("loc", "/admin/adminMember");
			model.addAttribute("msg", "해당 회원을 탈퇴했습니다.");			
		}
		 
		return "common/msg";
	}
	
	//개인 정보 수정 (전체)
	@RequestMapping(value="/member/updateUser.do", method = RequestMethod.POST)
	public ModelAndView insertBoard(@RequestParam(value="mno") String mno,
									@RequestParam(value="mid") String mid,
									@RequestParam(value="mname") String mname,
									@RequestParam(value="phone") String phone,
									@RequestParam(value="preMprofile") String preMprofile,
									@RequestParam(value="email") String email,
									//@RequestParam(value="newPwd", required=false, defaultValue="no") String newPwd,
									//@RequestParam(value="gender") String gender,
									@RequestParam(value="favor", required=false, defaultValue="no") String[] favor,
									@RequestParam(value="cover", required=false) String cover,
									@RequestParam(value="upFile", required=false) MultipartFile[] upFiles,
									HttpServletRequest request,
									@ModelAttribute("memberLoggedIn") Member m
									) {
		ModelAndView mav = new ModelAndView();
		Member member = new Member();
		System.out.println("favor==="+favor);
		try {
			//1.파일 업로드 처리
			String saveDirectory = request.getSession().getServletContext().getRealPath("/resources/upload/member");
			
			
			
			/*********** MultipartFile을 이용한 파일 업로드 처리 로직 시작 **********/
			for(MultipartFile f: upFiles) {
				if(!f.isEmpty()) {
					//파일명 재생성
					String originalFileName = f.getOriginalFilename();
					String ext = originalFileName.substring(originalFileName.lastIndexOf(".")+1);
					SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmssSSS");
					int rndNum = (int)(Math.random()*1000);
					String renamedFileName = sdf.format(new Date(System.currentTimeMillis()))+"_"+rndNum+"."+ext;
					
					try {
						f.transferTo(new File(saveDirectory+"/"+renamedFileName));
					} catch (IllegalStateException e) {
						e.printStackTrace();
					} catch (IOException e) {
						e.printStackTrace();
					}
					
					member.setMprofile(renamedFileName);
				}else {
					member.setMprofile(preMprofile);					
				}
			}
		}catch(Exception e) {
			throw new MemberException("회원 정보 수정 오류");
		}
			
			/*********** MultipartFile을 이용한 파일 업로드 처리 로직 끝 **********/
			
		  
		  member.setMno(Integer.parseInt(mno));
	      member.setMname(mname);
	      member.setPhone(phone);
	      member.setEmail(email);
	      //member.setBirth(birth);
	      //member.setGender(gender);
	      member.setFavor(favor);
	      member.setCover(cover);
	      
	      int result = memberService.updateMember(member);
	      
	      if(result>0) {
	         mav.addObject("memberLoggedIn", member);
	         
	         if(mid==m.getMid()) {
	        	 mav.addObject("msg", "회원 정보가 변경되었습니다.");
	        	 mav.addObject("loc", "/member/memberView.do");
	         }
	         
	      }else {
	    	  mav.addObject("msg", "회원 정보가 변경되지 않았습니다.");
	    	  mav.addObject("loc", "/member/memberView.do");
	    	  mav.addObject("memberLoggedIn", m);
	      }
	      
	      
	      mav.setViewName("common/msg");
	      
	      return mav;
	}

	// 개인 정보 수정 - 탈퇴하기
	@RequestMapping(value = "/member/memberDrop.do")
	public String memberDrop(@RequestParam("mno") String mno, 
							@RequestParam(value="admin", required=false) String admin,
							Model model, SessionStatus sessionStatus) {

		// 탈퇴일만
		int result = memberService.dropMember(mno);

		if (result > 0 && !"admin".equals(admin)) {
			if (!sessionStatus.isComplete())
				sessionStatus.setComplete();
				model.addAttribute("loc", "/");
				model.addAttribute("msg", "탈퇴 되었습니다.");
		} else if(result > 0 && "admin".equals(admin)) {
			model.addAttribute("loc", "/admin/adminMember");
			
			return "redirect:/msg.do";
		} else if(result <= 0 && "admin".equals(admin)) {
			model.addAttribute("msg", "오류가 발생했습니다.");
			
			return "redirect:/member/adminMemberView.do?mno="+mno;
		} else {
			model.addAttribute("msg", "오류가 발생하였습니다.");
			model.addAttribute("loc", "/");
		}
		return "common/msg";
	}
	
	// 개인 정보 수정 - 이메일 변경(중복되는 이메일 체크하기 )
		@RequestMapping(value = "/member/emailDuplication.do")
		@ResponseBody
		public Map<String, Object> emailDuplication(@RequestParam("newEmail") String newEmail) {
			Map<String, Object> map = new HashMap<>();
			boolean isDulpl = false;
			int result = memberService.selectCntEmail(newEmail);

			if (result == 0) {
				isDulpl = true; // 중복값이 없을 경우
			} else {
				isDulpl = false; //중복값 존재
			}
			System.out.println(result);
			map.put("isDulpl", isDulpl);
			return map;
		}

	// 개인 정보 수정 - 이메일 변경(인증키 생성 및 메일 보내주기)
	@RequestMapping(value = "/member/newEmailKey.do")
	@ResponseBody
	public Map<String, Object> newEmailKey(@RequestParam(value = "newEmail") String newEmail)
			throws JsonProcessingException {

		Map<String, Object> map = new HashMap<>();
		boolean isUsable = false;

		// 1. 페이지의 인증키를 생성한다.
		String tempPwd = "";
		int tempSize = 8;
		char[] temp = new char[tempSize];

		// 48~57- 숫자, 65~90- 대문자, 97~122- 소문자
		for (int i = 0; i < tempSize; i++) {
			int rnd = (int) (Math.random() * 122) + 48;
			if (rnd > 48 && rnd < 57 || rnd > 65 && rnd < 90 || rnd > 97 && rnd < 122) {
				temp[i] = (char) rnd;
				tempPwd += temp[i];
			} else {
				i--;
			}
		}

		try {
			MimeMessage message = mailSender.createMimeMessage();
			MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "UTF-8");

			messageHelper.setFrom("kimemail201807@gmail.com"); // 보내는사람 생략하거나 하면 정상작동을 안함
			messageHelper.setTo(newEmail); // 받는사람 이메일
			messageHelper.setSubject("스터디 그룹 이메일 인증"); // 메일제목은 생략이 가능하다
			messageHelper.setText("이메일 인증 번호는 [" + tempPwd + "] 입니다.");

			mailSender.send(message);
			isUsable = true;
		} catch (Exception e) {
			e.getStackTrace();
		}

		map.put("isUsable", isUsable);
		map.put("tempPwd", tempPwd);

		return map;
	}

	// 개인 정보 수정 - 이메일 변경(인증된 이메일로 디비 값 변경 )
	@RequestMapping(value = "/member/newEmail.do", method = RequestMethod.POST)
	public String newEmail(HttpServletRequest request, @RequestParam("email") String email, Model model,
			@ModelAttribute("memberLoggedIn") Member m) {
		// System.out.println(email+"로 이메일 변경해주기");

		m.setEmail(email);
		int result = memberService.updateEmail(m);

		if (result > 0) {
			model.addAttribute("memberLoggedIn", m);
			return "redirect:/member/memberView.do";
		} else {
			model.addAttribute("msg", "이메일이 변경되지 않았습니다.");
			model.addAttribute("loc", "member/memberView.do");
			return "common/msg";
		}
	}
	/* 개인 정보 수정 끝 **********************************/

	/************************** 내 스터디 & 신청 & 찜 목록 시작 */
	
	@RequestMapping(value="/member/searchMyPageKwd.do", produces ="application/text; charset=utf8")
	@ResponseBody public ModelAndView searchPageWish (@RequestParam(value="cPage", required=false, defaultValue="1") int cPage
													, @RequestParam(value="searchKwd", defaultValue="title") String searchKwd
													, @RequestParam(value="kwd", required=false, defaultValue="") String kwd
													, @RequestParam(value="type", defaultValue="study") String type
													, @RequestParam(value="applyDate",required=false, defaultValue="present")String applyDate 
													, @RequestParam(value="myPage",required=false,defaultValue="study") String myPage 
													, @RequestParam(value="leader",	required=false, defaultValue="y") String leader 
													, @RequestParam(value="lno", required=false, defaultValue="0") String lno 
													, @RequestParam(value="tno",required=false,defaultValue="0") String tno 
													, @RequestParam(value="kno",required=false,defaultValue="0") String kno 
													, @RequestParam(value="subno",	required=false, defaultValue="0") String subno 
													, @RequestParam(value="dno",required=false,defaultValue="0") String dno 
													, @ModelAttribute("memberLoggedIn") Member m
													) { 
		ModelAndView mav = new ModelAndView();
	
		int numPerPage = 5;
//		System.out.println(lno);
//		System.out.println(tno);
//		System.out.println(kno);
//		System.out.println(subno);
//		System.out.println(dno);
		Map<String,String> map = new HashMap<>(); 
		
		lno = lno.split(",")[0];
		tno = tno.split(",")[0];
		kno = kno.split(",")[0];
		subno = subno.split(",")[0];
		dno = dno.split(",")[0];
		
		map.put("lno", lno); 
		map.put("tno", tno); 
		map.put("kno", kno); 
		map.put("subno", subno); 
		map.put("dno", dno); 
		map.put("mno", String.valueOf(m.getMno())); //리스트를 검색한 회원 고유번호
		map.put("myPage", myPage); //스터디, 신청, 찜 구분
		map.put("leader", leader); //팀장,팀원 구분
		map.put("type", type); //스터디, 강의 구분
		map.put("applyDate", applyDate); //오늘을 기준으로 오늘까지는 현재 진행중인 스터디, 
		map.put("searchKwd", searchKwd); //검색할 항목
		//kwd관련 map(title(스터디명), captain(팀장명), subject(과목명), place(장소명), diff(난이도명), term(검색한 날짜에 스터디가 진행 중인 것?), freq(주기명))
		if("term".equals(searchKwd) || "freq".equals(searchKwd)) { 
			String[] termKwd = kwd.split(","); 
			map.put("kwd", termKwd[0]); 
			if(termKwd.length>1) { 
				for(int i=1; i<termKwd.length; i++) {
					map.put("kwd"+i, termKwd[i]); 
					System.out.println(termKwd[i]); 
				} 
			} 
		} else if(kwd==null ){ 
			map.put("kwd", null); 
		} else{ 
			map.put("kwd", kwd); 
		}
		
		//팀장인 경우의 리스트
		List<Map<String,String>> leaderList = null; 
		int leaderCount = 0;
		
		//팀원인 경우의 리스트 (신청, 찜 리스트?)
		List<Map<String,String>> list = null; 
		int count = 0; 
		
		//지역 리스트
		List<Map<String,Object>> localList=studyService.selectLocal();
		
		//카테고리 리스트
		List<Map<String,Object>> kindList=studyService.selectKind();
		
		//난이도 리스트
		List<Map<String,Object>> diffList=studyService.selectLv();
		
		System.out.println(map);
		
		if("study".equals(myPage)) { //팀원일 때, 내 스터디 
			if ("n".equals(leader)) { 
				list = memberService.selectMyStudyList(map, numPerPage, cPage); 
				count =	memberService.selectMyStudyListCnt(map); 
				}
		
			//팀장일 때, 내 스터디
			if ("y".equals(leader)) { 
				leaderList = memberService.selectLeaderList(map, numPerPage, cPage); 
				leaderCount = memberService.selectLeaderListCnt(map); 
			}
			mav.setViewName("member/memberMyStudy"); 
		} 
		if("apply".equals(myPage)) { 
			list = memberService.selectApplyList(map, numPerPage, cPage); 
			count = memberService.selectApplyListCnt(map); 
			mav.setViewName("member/memberApply");
		} 
		if("wish".equals(myPage)) { 
			list = memberService.selectWishList(map, numPerPage, cPage); 
			count = memberService.selectWishListCnt(map);
		mav.setViewName("member/memberWish"); 
		}
		
		mav.addObject("lno",lno);//지역 리스트
		mav.addObject("tno",tno);//지역 리스트
		mav.addObject("kno",kno);//카테고리 리스트
		mav.addObject("subno",subno);//과목 리스트
		mav.addObject("dno",dno);//난이도 리스트
		mav.addObject("localList",localList);//지역 리스트
		mav.addObject("kindList",kindList);//카테고리 리스트(과목)
		mav.addObject("diffList",diffList);//난이도 리스트
		mav.addObject("myPage", myPage); // study, apply, wish
		mav.addObject("leader", leader); //팀장인지 팀원인지 구분
		mav.addObject("type", type); // 스터디, 강의 구분
		mav.addObject("applyDate", applyDate); // 신청이 지난, 진행 중인
		mav.addObject("searchKwd", searchKwd); //검색할 분야?
		mav.addObject("kwd", kwd); // 검색할 키워드
		mav.addObject("count", count); // 팀원의 스터디, 강의, 신청, 찜 총 수
		mav.addObject("myPageList", list); //study, apply, wish 타입에 맞는 리스트 =>팀원의 리스트?
		mav.addObject("leaderList", leaderList); // 팀장일때 스터디 목록?
		mav.addObject("leaderCount", leaderCount); //팀장일때 스터디 총 수
		mav.addObject("numPerPage", numPerPage);
		mav.addObject("cPage", cPage);
		mav.addObject("memberLoggedIn", m);
		
		return mav; 
	}
	
	/* 내 스터디 & 신청 & 찜 목록 끝 *******************************/
	
	//ajax로 평가 페이지를 보여준다.
	@RequestMapping(value="/member/reviewEnrollView.do", produces =	"application/json; charset=utf8")
	@ResponseBody public ModelAndView reviewEnrollView(@RequestParam("studyNo")	String studyNo 
													, @RequestParam(value="leader", defaultValue="y") String leader ) { 
		ModelAndView mav = new ModelAndView("jsonView");
	
		List<Map<String,Object>> list = null; 
		List<Map<String,Object>> lList = null;
		list = memberService.reviewEnrollView(studyNo);
		

		if("n".equals(leader)) {
			lList = memberService.leaderReviewEnrollView(studyNo);			
			for(Map<String,Object> a : lList) {
				list.add(a);
			}
		}
		//System.out.println(list);
		 

		mav.addObject("list", list);
		
		return mav; 
		}
	
	//insert all을 통해 평가 내용을 등록한다.
	@RequestMapping(value="/member/reviewEnroll.do", method= RequestMethod.POST, produces = "application/text; charset=utf8")
	@ResponseBody public ModelAndView reviewEnroll(@RequestParam(value="tmno") String[] tmno 
												, @RequestParam("sno") String[] sno 
												, @RequestParam("mno") String[] mno
												, @RequestParam("point") String[] point 
												, @RequestParam("content") String[] content 
												, @RequestParam(value="searchKwd", defaultValue="title") String searchKwd 
												, @RequestParam(value="kwd", required=false, defaultValue="") String kwd 
												, @RequestParam(value="type", defaultValue="study") String type
												, @RequestParam(value="leader", defaultValue="y") String leader
												, @RequestParam(value="cPage", defaultValue="1") String cPage
												, @ModelAttribute("memberLoggedIn") Member m ) { 
		ModelAndView mav = new ModelAndView(); 
		List<Review> list = new ArrayList<>(); 
		//평가 전체 등록하기 
		//	int	result = memberService.reviewEnrollView(); 
		for(int i=0; i<tmno.length; i++) {
			Review r = new Review(); 
//			System.out.println("tmno="+tmno[i]);
//			System.out.println("sno="+sno[i]); 
//			System.out.println("mno="+mno[i]);
//			System.out.println("point="+point[i]);
//			System.out.println("content="+content[i]); 
//			System.out.println("~~~~~~~~");
			r.setTmno(tmno[i]); 
			r.setSno(sno[i]); 
			r.setMno(mno[i]); 
			r.setPoint(point[i]);
			r.setContent(content[i]); 
			list.add(r); 
		} 
		Map <String,Object> map = new HashMap<>();
		
		map.put("list", list);
		
		try { 
			kwd =URLEncoder.encode(kwd, "UTF-8"); 
		} catch (UnsupportedEncodingException e) { // TODO Auto-generated catch block
			e.printStackTrace(); 
		}
		
		int result = memberService.reviewEnroll(map);
		
		if(result>0) { //리뷰 달면 경험치 10점 주기 
			map.put("exp", 10); 
			map.put("mno", m.getMno()); 
			int resultExp = memberService.updateMemberExp(map);
			if(resultExp>0) { 
				System.out.println("리뷰 등록 : exp+10점"); 
			}else {
				System.out.println("리뷰 등록 실패"); 
			} 
		}
		
		
		mav.setViewName("redirect:/member/searchMyPageKwd.do?searchKwd="+searchKwd+	"&kwd="+kwd+"&type="+type+"&leader="+leader+"&cPage="+cPage); 
		//redirect시 한글이 깨져서 가기 때문에 인코딩을 반드시 해줘야한다.
		
		return mav; 
	}
	
	//평가 완료 버튼 처리 & 평가 보기
	@RequestMapping(value="/member/reviewFinish.do")
	@ResponseBody 
	public ModelAndView reviewFinish(@RequestParam("studyNo") String studyNo 
									, @ModelAttribute("memberLoggedIn") Member m ) { 
		ModelAndView mav = new ModelAndView("jsonView"); 
		String[] sno = studyNo.split(",");
		List<Map<String, Object>> reviewList = new ArrayList<>(); 
		Map<String,Object> reviewListMap = new HashMap<>();
		List<Map<String, Object>> giveReviewList = new ArrayList<>(); 
		Map<String,Object> giveReviewListMap = new HashMap<>();
		System.out.println(sno);
		System.out.println(m.getMid());
		//평가를 완료하고, 다른 사람이 평가를 줬을 경우 평가 리스트 
		for(int i=0; i<sno.length; i++) { 
			Map	<String,Object> listMap = new HashMap<>(); 
			listMap.put("sno", sno[i]);
			listMap.put("tmno", m.getMno());
		
			List<Map<String,Object>> list = memberService.reviewList(listMap);
			
			reviewListMap.put(String.valueOf(sno[i]), list);//평가를 한 스터디의 평가 리스트 담기
			System.out.println(reviewList); 
		} 
		//평가를 완료하고, 내가 다른 사람에게 준 평가 리스트 
		for(int i=0; i<sno.length; i++) { 
			Map	<String,Object> listMap = new HashMap<>(); 
			listMap.put("sno", sno[i]);
			listMap.put("mno", m.getMno());
			
			List<Map<String,Object>> list = memberService.giveReviewList(listMap);
			
			giveReviewListMap.put(String.valueOf(sno[i]), list);//평가를 한 스터디의 평가 리스트 담기
			System.out.println(reviewList); 
		} 
		reviewList.add(reviewListMap);
		giveReviewList.add(giveReviewListMap);
		
		//평가 완료한 스터디 리스트 
		Map <String,Object> map = new HashMap<>(); 
		map.put("sno", sno); 
		map.put("mno", m.getMno()); 
		List<Integer> studyNoList =	memberService.reviewFinish(map);
		
		mav.addObject("studyNoList", studyNoList); 
		mav.addObject("reviewList",	reviewList); 
		mav.addObject("giveReviewList",	giveReviewList); 
		return mav; 
	}
	
	//신청 현황
	@RequestMapping(value="/member/applyListView.do")
	@ResponseBody 
	public ModelAndView applyListView( @RequestParam("studyNo") String studyNo 
									, @ModelAttribute("memberLoggedIn") Member m ) { 
		ModelAndView mav = new ModelAndView("jsonView"); 
		Map <String,String> map = new HashMap<>(); 
		map.put("studyNo", studyNo); 
		//map.put("forCrewList", "forCrewList"); 
		int numPerPage = memberService.selectApplyListCnt(map); 
		int	crewNumPerPage = memberService.selectMyStudyListCnt(map); 
		int cPage = 1;
	
		List<Map<String,String>> list = memberService.selectApplyList(map, numPerPage, cPage); 
		List<Map<String,String>> crewList = memberService.selectMyStudyList(map, crewNumPerPage, cPage);
		System.out.println(list); 
		System.out.println(crewList); 
		String studyName = 	memberService.selectStudyName(studyNo); 
		System.out.println(studyName);
		
		//해당 스터디의 모집 인원
		Study s = studyService.selectStudyByMnoTypeStudy(studyNo);
		String recruit =s.getRecruit();
		
		int crewCnt = crewList.size();
				
		mav.addObject("applyList", list); 
		mav.addObject("crewList", crewList);
		mav.addObject("studyName", studyName); 
		mav.addObject("studyNo", studyNo);
		mav.addObject("crewCnt", crewCnt);
		mav.addObject("recruit", recruit);
		
		return mav; 
	} 
	
	
	//신청 현황 수락 버튼
	@RequestMapping(value="/member/applyButton.do")
	@ResponseBody 
	public ModelAndView applyButton(@RequestParam("sno") String sno
									, @RequestParam("mno")String mno
									, @RequestParam("confirm") String confirm
									, HttpServletRequest session
									){ 
		ModelAndView mav = new ModelAndView("jsonView"); 
		Map<String, String> map = new HashMap<>();
		map.put("studyNo", sno); 
		//map.put("forCrewList", "forCrewList");
		map.put("mno", mno);
		
		int resultDel = 0;
		int result=0;
		/*김률민 추가 20180708 메시징 핸들러를 위해  스코프 범위 변경 *************************************************/
		Study study = studyService.selectStudyByMnoTypeStudy(sno);
		Member m = (Member) session.getSession().getAttribute("memberLoggedIn");
		/*김률민 추가 20180708 메시징 핸들러를 위해  스코프 범위 변경 *************************************************/
		if("agree".equals(confirm)) {

		   Map<String, Object> key = new HashMap<>();
	       key.put("mno", mno);
	       key.put("key", "crew");
	       //수락하려는 회원이 이미 포함되어있는 크루 검사. 
		   List<Map<String, Object>> list = studyService.selectStudyListBySno(key);
		   System.out.println("agree에 들어오나요"+list);
			
		   try {
               String[] freqs = study.getFreq().split(",");
               int cnt = checkDate(study, list, freqs);
               
               if (cnt == 0) {
                  System.out.println("###########중복이 없음##########");
                  result = memberService.insertCrew(map);
                  /*김률민 추가 20180708 메시징 핸들러를 위해 *************************************************/
                  ObjectMapper mapper = new ObjectMapper();
                  map.put("sendermno", String.valueOf(m.getMno()));
                  map.put("receivermno", mno);
                  map.put("checkdate", "checkdate");
                  map.put("content", study.getTitle()+"신청수락 되었습니다.");

  				  //시스템 쪽지 발송
  				  int messageResult = messageService.messageWrite(map);
  				  int count = messageService.messageCount(map);
  				  Message message = new Message("insert:crew", String.valueOf(m.getMno()), map.get("mno"), study.getTitle()+"신청수락 되었습니다.", count);

                  
  				  if(result > 0 && messageResult > 0) {
      				try {
						echoHandler.handleMessage(echoHandler.getSessions().get(String.valueOf(m.getMno())), new TextMessage(mapper.writeValueAsString(message)));

					} catch (JsonProcessingException e) {
						e.printStackTrace();
					} catch (Exception e) {
						e.printStackTrace();
					}

                  }

  				  
  				  
                  /*김률민 추가 20180708 메시징 핸들러를 위해 ***************************************************/
               } else {
                  //중복된게 있어서 회원을 팀원으로 수락 불가. 
                  System.out.println("&&&&&&&&&&&중복이 있음&&&&&&&&&&&");
                  mav.addObject("msg","이미 참여한 스터디나 강의가 있는 회원입니다.");
                  result=-1;
                  
               }
               resultDel = memberService.deleteApply(map);
            } catch (NullPointerException e) {
               
            }
					
		}else if("cancel".equals(confirm)){
			result = memberService.insertApply(map);
			resultDel = memberService.deleteCrew(map);
            /*김률민 추가 20180708 메시징 핸들러를 위해 *************************************************/
            ObjectMapper mapper = new ObjectMapper();
            map.put("sendermno", String.valueOf(m.getMno()));
            map.put("receivermno", mno);
            map.put("checkdate", "checkdate");
            map.put("content", study.getTitle()+"신청 수락이 취소 되었습니다.");

			  //시스템 쪽지 발송
			  int messageResult = messageService.messageWrite(map);
			  int count = messageService.messageCount(map);
            
		    Message message = new Message("insert:crew", String.valueOf(m.getMno()), map.get("mno"), study.getTitle()+"수락이 취소 되었습니다.", count);

            if(resultDel > 0 && messageResult > 0 ) {
				try {
					echoHandler.handleMessage(echoHandler.getSessions().get( String.valueOf(m.getMno())), new TextMessage(mapper.writeValueAsString(message)));
				} catch (JsonProcessingException e) {
					e.printStackTrace();
				} catch (Exception e) {
					e.printStackTrace();
				}

            }
            /*김률민 추가 20180708 메시징 핸들러를 위해 ***************************************************/
			
		}
		
		if(result==0 || resultDel==0) {
			mav.addObject("msg","다시 시도해주세요");
		}
		
		map.remove("mno");
		
		int crewNumPerPage = memberService.selectMyStudyListCnt(map); 
		int cPage = 1;
		
		List<Map<String,String>> crewList = memberService.selectMyStudyList(map, crewNumPerPage, cPage); 
		System.out.println(crewList);
		
		mav.addObject("crewList", crewList); 
		mav.addObject("studyNo", sno);
		
		return mav; 
	}
	
	public int checkDate(Study study, List<Map<String, Object>> list, String[] freqs) {
	      int cnt = 0;
	      if (!list.isEmpty()) {
	         // 시간 뽑기
	         // 등록 될 시간들.
	         long lectureSdate = study.getSdate().getTime();
	         long lectureEdate = study.getEdate().getTime();

	         // 뽑아올 시간들.
	         String[] times = study.getTime().split("~");
	         int sHour = Integer.parseInt(times[0].split(":")[0]);
	         int eHour = Integer.parseInt(times[1].split(":")[0]);

	         for (int i = 0; i < list.size(); i++) {
	            java.util.Date sdate = (java.util.Date) list.get(i).get("SDATE");
	            java.util.Date edate = (java.util.Date) list.get(i).get("EDATE");
	            
	            System.out.println("sdate="+sdate);
	            System.out.println("edate="+edate);
	            System.out.println("sHour="+sHour);
	            System.out.println("eHour="+eHour);
	            
	            // 등록된 날짜들에 포함되지 않는 경우
	            if (lectureEdate < sdate.getTime() || lectureSdate > edate.getTime()) {
	               System.out.println("날짜가 안겹쳐서 들어감");
	            }
	            // 포함되는 경우
	            else if (lectureSdate >= sdate.getTime() || lectureEdate <= edate.getTime()) {
	               // 요일을 검사해보자...
	               for (int j = 0; j < freqs.length; j++) {
	                  if (list.get(i).get("FREQ").toString().contains(freqs[j])) {
	                	  System.out.println("요일겹치기..");
	                     // 등록이 가능한 경우.
	                
	                     if (sHour > Integer.parseInt(list.get(i).get("ETIME").toString())
	                           || eHour < Integer.parseInt(list.get(i).get("STIME").toString())) {
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
	
	//평가 목록 페이지
	@RequestMapping(value="/member/searchMyPageEvaluation.do")
	@ResponseBody 
	public ModelAndView searchMyPageEvaluation( @RequestParam(value="myPage",required=false, defaultValue="exp") String eval 
												, @RequestParam(value="count",required=false, defaultValue="0" ) int count
												, @RequestParam(value="cPage",required=false, defaultValue="1" ) int cPage
												, @RequestParam(value="numPerPage",required=false, defaultValue="5" ) int numPerPage
												, @RequestParam(value="bcPage",required=false, defaultValue="1" ) int bcPage
												, @RequestParam(value="bnumPerPage",required=false, defaultValue="5" ) int bnumPerPage
												, @RequestParam(value="rcPage",required=false, defaultValue="1" ) int rcPage
												, @RequestParam(value="rnumPerPage",required=false, defaultValue="5" ) int rnumPerPage
												, @RequestParam(value="kno",required=false, defaultValue="0" ) String kno
												, @RequestParam(value="subno",required=false, defaultValue="0" ) String subno
												, @RequestParam(value="point",required=false, defaultValue="0" ) String point
												, @RequestParam(value="searchKwd",required=false, defaultValue="title" ) String searchKwd
												, @RequestParam(value="kwd",required=false ) String kwd
												, @ModelAttribute("memberLoggedIn") Member m ) { 
		ModelAndView mav = new ModelAndView(); 
		
		kno = kno.split(",")[0];
		subno = subno.split(",")[0];
		
		Map <String,Object> map = new HashMap<>();
		map.put("eval", eval);
		map.put("mno", m.getMno());
		map.put("kno", kno);
		map.put("subno", subno);
		map.put("point", point);
		map.put("searchKwd", searchKwd);
		map.put("kwd", kwd);
		
		Map<String, Object> list = memberService.searchEvaluation(map);
		List<Map<String,Object>> gradeList = memberService.selectGradeList();
		
		//나의 평가 리스트 tmno => 평가받는 회원
		List<Map<String,Object>> evalList = memberService.selectEvalList(map, numPerPage, cPage); 
		count = memberService.selectEvalCnt(map);
		
		//카테고리 리스트
		List<Map<String,Object>> kindList=studyService.selectKind();
		
		Map<String, String> queryMap = new HashMap<>();
		queryMap.put("mno", String.valueOf(m.getMno()));
		queryMap.put("searchKwd", searchKwd);
		queryMap.put("kwd", kwd);
		/*
		//게시판 리스트
		List<Map<String,String>> boardList = boardService.selectBoardList(cPage, numPerPage, queryMap);
		int boardCount = boardService.selectCount();
		*/
		//리플 리스트
		List<Map<String, String>> replyList = replyService.replyList(cPage, numPerPage, queryMap);
		int replyCount = replyService.replyCount(queryMap);
		
		
		//평가 관리 페이지로 이동
		mav.addObject("myPage", eval); 
		
		//경험치
		mav.addObject("list", list); 
		
		//평가 점수 리스트
		mav.addObject("evalList", evalList); 
		mav.addObject("gradeList", gradeList); 
		mav.addObject("gradeMin", gradeList.get(0)); 
		mav.addObject("gradeMax", gradeList.get(gradeList.size()-1)); 
		mav.addObject("m", m); 
		
		//평가 점수 페이징
		mav.addObject("numPerPage", numPerPage);
		mav.addObject("cPage", cPage);
		mav.addObject("count", count);
		/*
		//지식 점수 게시판 페이징
		mav.addObject("bnumPerPage", numPerPage);
		mav.addObject("bcPage", cPage);
		mav.addObject("bcount", count);
		*/
		
		//카테고리
		mav.addObject("kindList", kindList);
		mav.addObject("kno",kno);//카테고리 리스트
		mav.addObject("subno",subno);//과목 리스트
		
		//평가 점수 검색
		mav.addObject("searchKwd", searchKwd); //검색할 분야?
		mav.addObject("kwd", kwd); // 검색할 키워드
		mav.addObject("point", point); // 검색할 키워드
		
		//지식 점수 리스트
		/*mav.addObject("boardList", boardList); 
		mav.addObject("boardCount", boardCount); */
		mav.addObject("replyList", replyList); 
		mav.addObject("replyCount", replyCount); 
		
		//지식 점수 댓글 페이징
		mav.addObject("rnumPerPage", rnumPerPage);
		mav.addObject("rcPage", rcPage);
		mav.addObject("rcount", replyCount);
		mav.addObject("kwd", kwd); // 검색할 키워드
		mav.addObject("point", point); // 검색할 키워드
	
		mav.setViewName("member/MyEvaluation");
		
	return mav; 
	}
	@RequestMapping(value="/member/paymentList.do")
	public ModelAndView paymentList(@ModelAttribute("memberLoggedIn") Member m
									,@RequestParam(value="searchKwd", required=false, defaultValue="title") String searchKwd
									,@RequestParam(value="kwd", required=false, defaultValue="") String kwd
									,@RequestParam(value="myPage", required=false, defaultValue="") String myPage
									,@RequestParam(value="lno", required=false, defaultValue="0") String lno 
									,@RequestParam(value="tno",required=false,defaultValue="0") String tno 
									,@RequestParam(value="kno",required=false,defaultValue="0") String kno 
									,@RequestParam(value="subno",	required=false, defaultValue="0") String subno 						
									,@RequestParam(value="cPage", required=false, defaultValue="1") int cPage									
									) {
		
		ModelAndView mav = new ModelAndView();
		lno = lno.split(",")[0];
		tno = tno.split(",")[0];
		kno = kno.split(",")[0];
		subno = subno.split(",")[0];
		
		//지역 리스트
		List<Map<String,Object>> localList=studyService.selectLocal();
		
		//카테고리 리스트
		List<Map<String,Object>> kindList=studyService.selectKind();
		
		//난이도 리스트
		List<Map<String,Object>> diffList=studyService.selectLv();
		Map<String, Object> map = new HashMap<>();
		map.put("mno", m.getMno());
		map.put("lno", lno);
		map.put("tno", tno);
		map.put("kno", kno);
		map.put("subno", subno);
		map.put("searchKwd", searchKwd);
		map.put("kwd", kwd);
		if("term".equals(searchKwd)) { 
			String[] termKwd = kwd.split(","); 
			map.put("kwd", termKwd[0]); 
			if(termKwd.length>1) { 
				for(int i=1; i<termKwd.length; i++) {
					map.put("kwd"+i, termKwd[i]); 
					System.out.println(termKwd[i]); 
				} 
			} 
		} else if(kwd==null ){ 
			map.put("kwd", null); 
		} else{ 
			map.put("kwd", kwd); 
		}
		
		int numPerPage = 5;
		int count = memberService.selectPayListCnt(map);
		
		List<Map<String, String>> list = memberService.selectPayList(cPage, numPerPage, map);

		System.out.println(list);

		mav.addObject("list", list);
		mav.addObject("cPage", cPage);
		mav.addObject("numPerPage", numPerPage);
		mav.addObject("count", count);
		mav.addObject("localList", localList);
		mav.addObject("kindList", kindList);
		mav.addObject("diffList", diffList);
		mav.addObject("lno",lno);//지역 리스트
		mav.addObject("tno",tno);//지역 리스트
		mav.addObject("kno",kno);//카테고리 리스트
		mav.addObject("subno",subno);//과목 리스트
		mav.addObject("searchKwd",searchKwd);
		mav.addObject("kwd",kwd);
		mav.setViewName("member/memberPaymentList");
		
		return mav;
	}
	
	
	@RequestMapping(value="/member/paymentCancel.do")
	public String paymentcancel(@RequestParam int mno, 
									@RequestParam int sno, 
									@RequestParam long pno,
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
		System.out.println("tokkens = " + success);

		// 아임포트에서 결제취소가 성공한 경우.
		if (success == 1 || success == 0) {
			msg = "결제취소";

			ls.successAdminPayCancel(pno);
		}
		// 이미 취소한 경우.
		else if ( success == -1 ) {
			msg = "이미 취소된 결제입니다.";
			
			ls.successAdminPayCancel(pno);
		}
		// 실패한 경우
		else {
			msg = "결제 취소가 실패했습니다. 관리자에게 문의하세요.";
		}

		
		return msg;
	}
	
	///////////////////////////////////////
	//admin설정 시작
	//
	@RequestMapping(value = "/member/adminMemberView.do")
	public ModelAndView adminMemberView(@RequestParam(value = "mno", defaultValue = "0") int mno) {
		
		ModelAndView mav = new ModelAndView();
		Member member = memberService.selectOneMemberMno(mno);
		List<Map<String, String>> favor = memberService.selectKind();
		
		mav.addObject("member", member);
		mav.addObject("favor", favor);
		mav.setViewName("admin/adminMemberView");
		return mav;
	}
	//회원 정보 수정 (전체)
		@RequestMapping(value="/member/adminUpdateUser.do", method = RequestMethod.POST)
		public ModelAndView adminUpdateUser(@RequestParam(value="mno") String mno,
										@RequestParam(value="mid") String mid,
										@RequestParam(value="mname") String mname,
										@RequestParam(value="phone") String phone,
										@RequestParam(value="preMprofile") String preMprofile,
										@RequestParam(value="email") String email,
										@RequestParam(value="newPwd", required=false, defaultValue="no") String newPwd,
										//@RequestParam(value="gender") String gender,
										@RequestParam(value="favor", required=false, defaultValue="no") String[] favor,
										@RequestParam(value="cover", required=false) String cover,
										@RequestParam(value="admin", required=false) String admin,										
										@RequestParam(value="upFile", required=false) MultipartFile[] upFiles,
										HttpServletRequest request
										) {
			ModelAndView mav = new ModelAndView();
			Member member = new Member();
			System.out.println("favor==="+favor);
			try {
				//1.파일 업로드 처리
				String saveDirectory = request.getSession().getServletContext().getRealPath("/resources/upload/member");
				
				
				/*********** MultipartFile을 이용한 파일 업로드 처리 로직 시작 **********/
				for(MultipartFile f: upFiles) {
					if(!f.isEmpty()) {
						//파일명 재생성
						String originalFileName = f.getOriginalFilename();
						String ext = originalFileName.substring(originalFileName.lastIndexOf(".")+1);
						SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmssSSS");
						int rndNum = (int)(Math.random()*1000);
						String renamedFileName = sdf.format(new Date(System.currentTimeMillis()))+"_"+rndNum+"."+ext;
						
						try {
							f.transferTo(new File(saveDirectory+"/"+renamedFileName));
						} catch (IllegalStateException e) {
							e.printStackTrace();
						} catch (IOException e) {
							e.printStackTrace();
						}
						
						member.setMprofile(renamedFileName);
					}else {
						member.setMprofile(preMprofile);					
					}
				}
			}catch(Exception e) {
				throw new MemberException("회원 정보 수정 오류");
			}
				
				/*********** MultipartFile을 이용한 파일 업로드 처리 로직 끝 **********/
			if(!"no".equals(newPwd)) {
				String encodedPassword = bcryptPasswordEncoder.encode(newPwd);
				member.setPwd(encodedPassword);
			  }
			  member.setMno(Integer.parseInt(mno));
		      member.setMname(mname);
		      member.setPhone(phone);
		      member.setEmail(email);
		      //member.setBirth(birth);
		      //member.setGender(gender);
		      member.setFavor(favor);
		      member.setCover(cover);
		      
		      int result = memberService.updateMember(member);
		     
		      
		      //mav.setViewName("common/msg");
		      mav.setViewName("redirect:/member/adminMemberView.do?mno="+mno);
		      
		      return mav;
		}

	/* 로그인 및 마이페이지(김회진) 끝 **********************************************/
	/*************************************
	 * 추가?
	 ***************************************/

	/* 정보 입력페이지 이동 시작 */
	@RequestMapping(value = "/member/instructorEnroll.do")
	public ModelAndView instructorEnroll(@RequestParam(value = "check", required = false, defaultValue = "1") int check,
			@RequestParam(value = "agree1", required = false, defaultValue = "2") int agree1,
			@RequestParam(value = "agree2", required = false, defaultValue = "2") int agree2) {

		if (logger.isDebugEnabled()) {
			logger.debug("회원등록홈페이지");
		}
		System.out.println(check);
		ModelAndView mav = new ModelAndView();
		int c = check + agree1 + agree2;
		System.out.println(c);
		if (c != 23) {
			String loc = "/member/memberAgreement.do";
			String msg = "회원가입을 실패했습니다.";
			mav.addObject("msg", msg);
			mav.addObject("loc", loc);
			mav.setViewName("common/msg");
			return mav;
		}
		List<Map<String, String>> list = memberService.selectCategory();
		System.out.println(list);
		// 큰 분류 리스트
		List<Map<String, String>> kindList = ls.selectKindList();
		mav.addObject("kindList", kindList);
		mav.addObject("list", list);
		return mav;
	}

	@RequestMapping("/member/selectSubject.do")
	@ResponseBody
	public List<Map<String,Object>> selectSubject(@RequestParam(value="kindNo", required=true) int kindNo){
		List<Map<String, Object>> subList = ls.selectSubList(kindNo);
		return subList;
	}
	

		
	@RequestMapping("/member/selectKind.do")
	@ResponseBody
	public List<Map<String, Object>> selectKind() {

		List<Map<String, Object>> list = studyService.selectKind();

		return list;

	}

	/* 강사회원가입 시작 */
	@RequestMapping(value = "/member/instructorEnrollEnd.do", method = RequestMethod.POST)
	public ModelAndView instructorEnrollEnd(Member member,
			@RequestParam(value = "psFile", required = false) MultipartFile[] psFiles,
			@RequestParam(value = "kno", required = false) int kno,
			@RequestParam(value = "sno", required = false) int sno, HttpServletRequest request) {
		if (logger.isDebugEnabled()) {
			logger.debug("회원가입완료");
		}
		ModelAndView mav = new ModelAndView();
		/* 이메일 가져오기 */
		String email = member.getEmail();
		String[] emailArr = email.split(",");
		email = emailArr[0] + "@" + emailArr[1];
		member.setEmail(email);
		String loc = "/";
		String msg = "";
		/* 이메일 인증 여부 확인 */
		Map<String, String> cer = null;
		try {
			cer = memberService.selectCheckJoinCode(email);
		} catch (Exception e) {
			msg = "회원가입을 실패했습니다. 관리자에게 문의 하세요";
			mav.addObject("loc", loc);
			mav.addObject("msg", msg);
			mav.setViewName("common/msg");
			return mav;
		}
		System.out.println("email : " + email);

		if (cer == null) {
			msg = "회원가입을 실패했습니다.이메일 확인을 해주세요";
			mav.addObject("loc", loc);
			mav.addObject("msg", msg);
			mav.setViewName("common/msg");
			return mav;
		}
		/**
		 * 탈퇴 회원 여부 확인 탈퇴 회원일 경우 EXP/POINt/NPOINT 가져오고 set해준다
		 */

		try {
			int memberCheckEmail = memberService.memberCheckEmail(email);
			if (memberCheckEmail == 2) {
				msg = "회원가입을 실패했습니다. 탈퇴 확인을 해주세요";
				mav.addObject("loc", loc);
				mav.addObject("msg", msg);
				mav.setViewName("common/msg");
				return mav;
			} else if (memberCheckEmail == 1) {
				Member memberGetPoint = memberService.memberGetPoint(email);
				member.setExp(memberGetPoint.getExp());
				member.setPoint(memberGetPoint.getPoint());
				member.setNPoint(memberGetPoint.getNPoint());

			} else {
				member.setExp(0);
				member.setPoint(0);
				member.setNPoint(0);
			}
		} catch (Exception e) {
			msg = "회원가입을 실패했습니다. 관리자에게 문의 하세요";
			mav.addObject("loc", loc);
			mav.addObject("msg", msg);
			mav.setViewName("common/msg");
			return mav;
		}
		System.out.println("member : " + member);
		logger.debug(email);

		String rawPassword = member.getPwd();
		/******* password 암호화 시작 *******/
		String encodedPassword = bcryptPasswordEncoder.encode(rawPassword);
		member.setPwd(encodedPassword);

		/* favor null일 경우 처리 */
		if (member.getFavor() == null) {
			String[] favor = new String[1];
			favor[0] = "no";
			member.setFavor(favor);
		}

		/******
		 * MultipartFile을 이용한 파일 업로드 처리로직 시작 파일이름변경 파일이름+ 아이디 + 날짜
		 */
		List<String> list = new ArrayList<>();
		String saveDirectory = request.getSession().getServletContext().getRealPath("/resources/upload/instructor");
		String renamedFileName = "";
		for (MultipartFile f : psFiles) {
			if (!f.isEmpty()) {
				// 파일명 재생성
				String originalFileName = f.getOriginalFilename();
				String ext = originalFileName.substring(originalFileName.lastIndexOf(".") + 1);
				SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmssSSS");
				int rndNum = (int) (Math.random() * 1000);
				renamedFileName = member.getMid() + "_" + sdf.format(new Date(System.currentTimeMillis())) + "_"
						+ rndNum + "." + ext;
				try {
					f.transferTo(new File(saveDirectory + "/" + renamedFileName));
				} catch (IllegalStateException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}
				list.add(renamedFileName);
			}
		}
		System.out.println("list : " + list);
		Instructor instructor = new Instructor();
		instructor.setPortpolio(list.get(0));
		instructor.setSelfintroduction(list.get(1));
		instructor.setKno(kno);
		instructor.setSno(sno);
		System.out.println(instructor);
		/* 회원 가입 */
		int result = -1;
		try {
			result = memberService.memberEnrollEnd(member);
			int mno = member.getMno();
			System.out.println("mno : " + mno);
			instructor.setMno(mno);
			System.out.println(instructor);
			result = memberService.instructorEnrollEnd(instructor);
			memberService.deleteCertification(email);
		} catch (Exception e) {
			msg = "회원가입을 실패했습니다. 관리자에게 문의 하세요";
			mav.addObject("loc", loc);
			mav.addObject("msg", msg);
			mav.setViewName("common/msg");
			return mav;
		}

		// 2.처리결과에 따라 view단 분기처리
		if (result > 0)
			msg = "회원가입성공!";
		else {
			msg = "회원가입실패!";
			mav.addObject("loc", loc);
			mav.addObject("msg", msg);
			mav.setViewName("common/msg");
			return mav;
		}
		mav.addObject("ckeck", true);
		mav.setViewName("member/memberSuccess");
		return mav;

	}
	/*강사 신청 페이지 이동*/
	@RequestMapping("/member/instructorApply.do")
	public ModelAndView instructorApply(@RequestParam(value = "mno", required = false, defaultValue = "-1") int mno,
			@RequestParam(value = "mid", required = false, defaultValue = "-1") String mid) {
		ModelAndView mav = new ModelAndView();
		System.out.println("mid : " + mid);
		System.out.println("mno : " + mno);
		if (mno == -1 || mid == "-1") {
			mav.addObject("loc", "/");
			mav.addObject("msg", "잘못된 경로 입니다. 관리자에게 문의하세요");
			mav.setViewName("common/msg");
			return mav;
		}
		try {
			int result = memberService.instructorCheckO(mno);
			System.out.println("result : "+ result);
			if(result ==1) {
				mav.addObject("loc", "/member/memberView.do");
				mav.addObject("msg", "이미 강사 이시군요.");
				mav.setViewName("common/msg");
				return mav;
			}
			// 큰 분류 리스트
			List<Map<String, String>> kindList = ls.selectKindList();
			mav.addObject("kindList", kindList);
			mav.addObject("mno", mno);
			mav.addObject("mid", mid);
			
		} catch (Exception e) {
		}
		return mav;
	}

	/* 회원이 강사 신청 */
	@RequestMapping("/member/instructorApplyEnd.do")
	public ModelAndView instructorApplyEnd(@RequestParam(value="psFile",required=false) MultipartFile[] psFiles
			,@RequestParam(value="mno",required=false) int mno,@RequestParam(value="mid",required=false) String mid
			,@RequestParam(value="kno",required=false) int kno,@RequestParam(value="sno",required=false) int sno
			,HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		/******
		 * MultipartFile을 이용한 파일 업로드 처리로직 시작 파일이름변경 파일이름+ 아이디 + 날짜
		 */
		List<String> list = new ArrayList<>();
		String loc = "/";
		String msg = "";
		String saveDirectory = request.getSession().getServletContext().getRealPath("/resources/upload/instructor");
		String renamedFileName = "";
		for (MultipartFile f : psFiles) {
			if (!f.isEmpty()) {
				// 파일명 재생성
				String originalFileName = f.getOriginalFilename();
				String ext = originalFileName.substring(originalFileName.lastIndexOf(".") + 1);
				SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmssSSS");
				int rndNum = (int) (Math.random() * 1000);
				renamedFileName = mid + "_" + sdf.format(new Date(System.currentTimeMillis())) + "_" + rndNum + "."
						+ ext;
				try {
					f.transferTo(new File(saveDirectory + "/" + renamedFileName));
				} catch (IllegalStateException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}
				list.add(renamedFileName);
			}
		}
		Instructor instructor = new Instructor();
		instructor.setPortpolio(list.get(0));
		instructor.setSelfintroduction(list.get(1));
		instructor.setKno(kno);
		instructor.setSno(sno);
		instructor.setMno(mno);
		System.out.println(instructor);

		int result = -1;
		try {
			result = memberService.instructorCheckX(mno);
			if (result == 0) {
				result = memberService.instructorEnrollEnd(instructor);
			} else {
				result = memberService.updateInstructorEnrollEnd(instructor);
			}
		} catch (Exception e) {
			msg = "강사신청이 실패했습니다. 관리자에게 문의 하세요";
			mav.addObject("loc", loc);
			mav.addObject("msg", msg);
			mav.setViewName("common/msg");
			return mav;
		}

		// 2.처리결과에 따라 view단 분기처리
		if (result > 0)
			msg = "강사신청이 됬습니다. 결과를 기다려 주세요";
		else
			msg = "강사신청이 실패!";

		mav.addObject("loc", loc);
		mav.addObject("msg", msg);
		mav.setViewName("common/msg");
		return mav;
	}

	/* mailSending 코드 전송 */
	@RequestMapping(value = "/member/instructorCertification.do")
	@ResponseBody
	public Map<String, Object> instructorCertification(@RequestParam(value = "em") String em,
			@RequestParam(value = "mno") String mno, HttpServletRequest request) {
		Map<String, Object> map = new HashMap<>();
		Map<String,String> checkInstructor = new HashMap<>();
		checkInstructor.put("tomail", em);
		checkInstructor.put("mno", mno);
		try {
			int checkemail = memberService.instructorCheckEmail(checkInstructor);
			
			if (checkemail == 1) {
				map = mailCertification(request, em);
			} else {
				map.put("check", false);
				return map;
			}
		} catch (Exception e) {
		}
		return map;
	}
	/*약관동의서 관리 페이지 이동*/
	@RequestMapping(value = "/member/agreementAdmin.do")
	public ModelAndView agreementAdmin() {
		ModelAndView mav = new ModelAndView();
		Map<String,String> link = new HashMap<>();
		link.put("urlname","agreementadmin");
		link.put("check","1");
		List <Map<String , String>> service = null;
		List <Map<String , String>> information = null;
		try {
			
/*			int states = memberService.selectInnerAdmin(link);
			if(states==0) {
			}else {
				mav.addObject("loc", "/");
				mav.addObject("msg", "이미 입장되어 있습니다. 확인 부탁 드립니다.");
				mav.setViewName("common/msg");
			int result = memberService.adminInnerCheck(link);
			}*/
				System.out.println("???");
				service = memberService.serviceagree();
				information = memberService.informationagree();
				mav.addObject("service", service);
				mav.addObject("information", information);

		} catch (Exception e) {
		
		}
		
	
		return mav;
	}

	@RequestMapping(value = "/member/agreementAdminEnd.do")
	public ModelAndView agreementAdminEnd(@RequestParam(value = "em") String em) {
		ModelAndView mav = new ModelAndView();
		return mav;
	}

	@RequestMapping(value = "/member/serviceOneAdminEnd.do")
	@ResponseBody
	public Map<String, Object> agreementOneAdminEnd(@RequestParam(value = "sno") String sno,
			@RequestParam(value = "scontent") String scontent) {
		Map<String, Object> map = new HashMap<>();

		System.out.println(sno);
		System.out.println(scontent);
		Map<String, String> scont = new HashMap<>();
		scont.put("sno", sno);
		scont.put("scontent", scontent);
		int result = memberService.updateScontent(scont);

		if (result == 1) {
			map.put("check", true);
		} else {
			map.put("check", false);
		}

		return map;
	}

	@RequestMapping(value = "/member/informationOneAdminEnd.do")
	@ResponseBody
	public Map<String, Object> informationOneAdminEnd(@RequestParam(value = "ino") String ino,
			@RequestParam(value = "icontent") String icontent) {
		Map<String, Object> map = new HashMap<>();

		System.out.println(ino);
		System.out.println(icontent);
		Map<String, String> icont = new HashMap<>();
		icont.put("ino", ino);
		icont.put("icontent", icontent);
		int result = memberService.updateIcontent(icont);

		if (result == 1) {
			map.put("check", true);
		} else {
			map.put("check", false);
		}

		return map;
	}
	/*서비스 삭제*/
	@RequestMapping(value = "/member/serviceOneDeleteEnd.do")
	@ResponseBody
	public Map<String, Object> serviceOneDeleteEnd(@RequestParam(value = "sno") String sno) {
		Map<String, Object> map = new HashMap<>();

		System.out.println(sno);
		int result = memberService.deleteScontent(sno);

		if (result == 1) {
			map.put("check", true);
		} else {
			map.put("check", false);
		}

		return map;
	}
	/*약관동의서 삭제*/
	@RequestMapping(value = "/member/informationOneDeleteEnd.do")
	@ResponseBody
	public Map<String, Object> informationOneDeleteEnd(@RequestParam(value = "ino") String ino) {
		Map<String, Object> map = new HashMap<>();

		System.out.println(ino);
		int result = memberService.deleteIcontent(ino);

		if (result == 1) {
			map.put("check", true);
		} else {
			map.put("check", false);
		}

		return map;
	}
	/*서비스동의 문서 수정*/
	@RequestMapping(value = "/member/serviceInsertEnd.do")
	@ResponseBody
	public Map<String, Object> serviceInsertEnd(@RequestParam(value = "scontent") String scontent) {
		Map<String, Object> map = new HashMap<>();

		System.out.println(scontent);

		try {
			int result = memberService.insertScontent(scontent);
			
			if(result ==1) {
				map.put("check", true);
			}else {
				map.put("check", false);
			}
			
		} catch (Exception e) {
		}

		return map;
	}
	/*약관 동의 문서 수정*/
	@RequestMapping(value = "/member/informationInsertEnd.do")
	@ResponseBody
	public Map<String, Object> informationInsertEnd(@RequestParam(value = "icontent") String icontent) {
		Map<String, Object> map = new HashMap<>();

		System.out.println(icontent);
		try {
			int result = memberService.insertIcontent(icontent);
			
			if(result ==1) {
				map.put("check", true);
			}else {
				map.put("check", false);
			}
			
		} catch (Exception e) {
		}

		return map;
	}

	@RequestMapping(value = "/member/memberSuccess.do")
	public String memberSuccess(Model model) {
		ModelAndView mav = new ModelAndView();
		// mav.addObject("check", "현직 강사님이신가요? 강사님이시라면 <a href=\"#\"
		// onclick=\"fn_instruct();\">강사신청</a>");
		// model.addAttribute("check", "현직 강사님이신가요? 강사님이시라면 <a href=\"#\"
		// onclick=\"fn_instruct();\">강사신청</a>");
		return "member/memberSuccess";
	}
	
	/* 회원가입 -> 성공 -> 강사 신청 */
	@RequestMapping(value="/member/memberLoginInstruct.do", method = RequestMethod.POST)
	public ModelAndView memberLoginInstruct(HttpServletRequest request, @RequestParam(value="userId",required=false , defaultValue="-1" ) String userId, @RequestParam(value="pwd",required=false , defaultValue="-1") String pwd) {
		ModelAndView mav = new ModelAndView();

		System.out.println(userId);
		Member m = null;
		String msg = "";
		String loc = "/";
		try {
			m = memberService.selectOneMember(userId);
		} catch (Exception e) {
			msg = "로그인에 오류가 발생 했습니다. 관리자에게 문의 하세요";
			mav.addObject("msg", msg);
			mav.addObject("loc", loc);
			mav.setViewName("common/msg");
		}
		if (m == null || m.getQdate() != null) {
			msg = "존재하지 않는 아이디입니다.";
			mav.addObject("msg", msg);
			mav.addObject("loc", loc);
			mav.setViewName("common/msg");
		} else {
			if (bcryptPasswordEncoder.matches(pwd, m.getPwd())) {
				mav.addObject("mno", m.getMno());
				mav.addObject("mid", m.getMid());
				mav.setViewName("member/instructorApply");
			} else {
				msg = "비밀번호가 틀렸습니다.";
				mav.addObject("msg", msg);
				mav.addObject("loc", loc);
				mav.setViewName("common/msg");
			}
		}
		try {
			List<Map<String, String>> kindList = ls.selectKindList();
			mav.addObject("kindList", kindList);
		} catch (Exception e) {
		}

		return mav;
	}

	/* 멤버 강사 $ 포인트 관리 */
	@RequestMapping(value = "/member/memberPointList.do")
	public ModelAndView memberList() {
		ModelAndView mav = new ModelAndView();
		
		Map<String,String> link = new HashMap<>();
		link.put("urlname","memberlist");
		link.put("check","1");
	
		try {
			
/*			int states = memberService.selectInnerAdmin(link);
			if(states==0) {
			}else {
				mav.addObject("loc", "/");
				mav.addObject("msg", "이미 입장되어 있습니다. 확인 부탁 드립니다.");
				mav.setViewName("common/msg");
			}*/
				System.out.println("???");
				int result = memberService.adminInnerCheck(link);
				List<Map<String,Object>> list = memberService.selectMemberList();
				mav.addObject("list",list);
			

		} catch (Exception e) {
		}
		
		return mav;
	}
	/* 경험치 1개 수정 */
	@RequestMapping(value = "/member/changOneEXP.do" , method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> changOneEXP(@RequestParam(value = "mno") String mno,
			@RequestParam(value = "exp") String exp) {
		Map<String, Object> map = new HashMap<>();
		Map<String,String> expMap = new HashMap<>();
	
		expMap.put("mno", mno);
		expMap.put("exp", exp);
		int result =0;
		try {
			result = memberService.changOneEXP(expMap);
			System.out.println("result : "+result);
			map.put("check", false);
		} catch (Exception e) {
		}
		
		if(result ==1) {
			map.put("check", true);
		} else {
			map.put("check", false);
		}

		return map;
	}
	/* 성실포인트 1개 수정 */
	@RequestMapping(value = "/member/changOnePOINT.do" , method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> changOnePOINT(@RequestParam(value = "mno") String mno,
			@RequestParam(value = "point") String point) {
		Map<String, Object> map = new HashMap<>();

		System.out.println(mno);
		System.out.println(point);
		Map<String, String> expMap = new HashMap<>();
		expMap.put("mno", mno);
		expMap.put("point", point);
		int result = 0;
		try {
			result= memberService.changOneEXP(expMap);
		} catch (Exception e) {
			map.put("check", false);
		}
		
		if(result ==1) {
			map.put("check", true);
		} else {
			map.put("check", false);
		}

		return map;
	}
	/* 지식포인트 1개 수정 */
	@RequestMapping(value = "/member/changOneNPOINT.do" , method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> changOneNPOINT(@RequestParam(value = "mno") String mno,
			@RequestParam(value = "npoint") String npoint) {
		Map<String, Object> map = new HashMap<>();

		System.out.println(mno);
		System.out.println(npoint);
		Map<String, String> expMap = new HashMap<>();
		expMap.put("mno", mno);
		expMap.put("npoint", npoint);
		int result = 0;
		try {
			result = memberService.changOneEXP(expMap);
		}catch (Exception e) {
			map.put("check", false);
		}
		if(result ==1) {
			map.put("check", true);
		} else {
			map.put("check", false);
		}

		return map;
	}

	/* 경험치 추가 */
	@RequestMapping(value = "/member/changEXPPLUS.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> changEXPPLUS(@RequestParam(value = "mno") String[] mno) {
		Map<String, Object> map = new HashMap<>();
		List<Map<String, String>> list = new ArrayList<>();
		int result = 0;
		for (int i = 0; i < mno.length; i++) {
			Map<String, String> expMap = new HashMap<>();
			expMap.put("mno", mno[i]);
			result = memberService.changEXPPLUS(expMap);

			Map<String, String> getExp = new HashMap<>();
			getExp = memberService.getExp(expMap);

			list.add(getExp);
		}
		System.out.println(map);
		if (result == 1) {
			map.put("check", true);
		} else {
			map.put("check", false);
		}
		map.put("list", list);
		return map;
	}

	/* 경험치 빼기 */
	@RequestMapping(value = "/member/changEXPMINUS.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> changEXPTMINUS(@RequestParam(value = "mno") String[] mno) {
		Map<String, Object> map = new HashMap<>();
		List<Map<String, String>> list = new ArrayList<>();
		int result = 0;
		try {
			for(int i = 0 ; i < mno.length;i++) {
				Map<String,String> expMap = new HashMap<>();
				expMap.put("mno", mno[i]);
				result = memberService.changEXPMINUS(expMap );
				
				Map<String,String> getExp = new HashMap<>();
				getExp = memberService.getExp(expMap );
				list.add(getExp);
			}
			System.out.println(map);
			if(result ==1) {
				map.put("check", true);
			}else {
				map.put("check", false);
			}
			
		} catch (Exception e) {
		}
		map.put("list", list);
		return map;
	}

	/* 성실도 추가 */
	@RequestMapping(value = "/member/changPOINTPLUS.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> changPOINTPLUS(@RequestParam(value = "mno") String[] mno) {
		Map<String, Object> map = new HashMap<>();
		List<Map<String, String>> list = new ArrayList<>();
		int result = 0;
		try {
			for(int i = 0 ; i < mno.length;i++) {
				Map<String,String> expMap = new HashMap<>();
				expMap.put("mno", mno[i]);
				result = memberService.changPOINTPLUS(expMap );
				
				Map<String,String> getExp = new HashMap<>();
				getExp = memberService.getPoint(expMap );
				
				list.add(getExp);
			}
			System.out.println(map);
			if(result ==1) {
				map.put("check", true);
			}else {
				map.put("check", false);
			}
			
		} catch (Exception e) {
		}
		map.put("list", list);
		return map;
	}

	/* 성실도 빼기 */
	@RequestMapping(value = "/member/changPOINTMINUS.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> changPOINTMINUS(@RequestParam(value = "mno") String[] mno) {
		Map<String, Object> map = new HashMap<>();
		List<Map<String, String>> list = new ArrayList<>();
		int result = 0;

		try {
			for(int i = 0 ; i < mno.length;i++) {
				Map<String,String> expMap = new HashMap<>();
				expMap.put("mno", mno[i]);
				result = memberService.changPOINTMINUS(expMap );
				
				Map<String,String> getExp = new HashMap<>();
				getExp = memberService.getPoint(expMap );
				list.add(getExp);
			}
			System.out.println(map);
			if(result ==1) {
				map.put("check", true);
			}else {
				map.put("check", false);
			}
		} catch (Exception e) {
		}
		map.put("list", list);
		return map;
	}

	/* 지식 추가 */
	@RequestMapping(value = "/member/changNPOINTPLUS.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> changNPOINTPLUS(@RequestParam(value = "mno") String[] mno) {
		Map<String, Object> map = new HashMap<>();
		List<Map<String, String>> list = new ArrayList<>();
		int result = 0;
		try {
			for(int i = 0 ; i < mno.length;i++) {
				Map<String,String> expMap = new HashMap<>();
				expMap.put("mno", mno[i]);
				result = memberService.changNPOINTPLUS(expMap );
				Map<String,String> getExp = new HashMap<>();
				getExp = memberService.getNPoint(expMap );
				list.add(getExp);
			}
			System.out.println(map);
			if(result ==1) {
				map.put("check", true);
			}else {
				map.put("check", false);
			}
			
		} catch (Exception e) {
		}
		System.out.println("list : "+list);
		map.put("list", list);
		return map;
	}

	/* 지식 빼기 */
	@RequestMapping(value = "/member/changNPOINTMINUS.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> changNPOINTMINUS(@RequestParam(value = "mno") String[] mno) {
		Map<String, Object> map = new HashMap<>();
		List<Map<String, String>> list = new ArrayList<>();
		int result = 0;
		try {
			for(int i = 0 ; i < mno.length;i++) {
				Map<String,String> expMap = new HashMap<>();
				expMap.put("mno", mno[i]);
				result = memberService.changNPOINTMINUS(expMap );
				Map<String,String> getExp = new HashMap<>();
				getExp = memberService.getNPoint(expMap );
				list.add(getExp);
			}
			System.out.println(map);
			if(result ==1) {
				map.put("check", true);
			}else {
				map.put("check", false);
			}
			
		} catch (Exception e) {
		}
		map.put("list", list);
		return map;
	}
	@RequestMapping("/member/selectViewMember.do")
	public ModelAndView selectViewMember(@RequestParam(value="mid") String mid,@RequestParam(value="size" ,required=false , defaultValue="-1") int size) {
		ModelAndView mav = new ModelAndView();
		System.out.println(mid);
		Member m = memberService.selectOneMember(mid);
		List<Map<String,String>> reviewList = memberService.selectMemberReviewList(m.getMno());
		
		
		Map <String,Object> map = new HashMap<>();
		map.put("eval", "exp");
		map.put("mno", m.getMno());
		
		Map<String, Object> list = memberService.searchEvaluation(map);
		List<Map<String,Object>> gradeList = memberService.selectGradeList();
		//경험치 및 포인트 등급 보여주기
		List<Map<String,Object>> replyList = memberService.selectmemberReply(m.getMno());
		Map<String,String> instruct = memberService.selectOneInstruct(m.getMno());
		System.out.println("size = "+size);
		if(size==10) {
			mav.addObject("size",size);
			List<Map<String, String>> category = memberService.selectCategory();
			
			System.out.println(category);
			mav.addObject("category", category);
		}
		
		//평가 관리 페이지로 이동
		mav.addObject("instruct", instruct); 
		mav.addObject("eval", "exp"); 
		mav.addObject("list", list); 
		mav.addObject("gradeList", gradeList); 
		mav.addObject("gradeMin", gradeList.get(0)); 
		mav.addObject("gradeMax", gradeList.get(gradeList.size()-1)); 
		mav.addObject("replyList",replyList);
		mav.addObject("m",m);
		mav.addObject("reviewList", reviewList);
		return mav;
	}
	
	
	//회원 가져와볼까
	
		@RequestMapping(value="/member/member/loadInstructor.do", method=RequestMethod.GET)
		@ResponseBody
		public ModelAndView selectMemberPageCount() {
			
			ModelAndView mav = new ModelAndView("jsonView");
			
			List<Map<String, Object>> list = null;
			int total = 0;
			list = memberService.selectInstructorMemberOX();
			total = memberService.selectCntInstructorMember();
			
			
			mav.addObject("list", list);
			mav.addObject("total",total);
			return mav;
		}
		
	@RequestMapping(value="/member/applyInstructAgree.do")
	public ModelAndView applyInstructAgree(@RequestParam(value="ino",required=false , defaultValue="-1" )int ino , HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		int result = memberService.updateInstructorApply(ino);
		if(result <0) {
			
		}else {
		}
		String referer = request.getHeader("Referer");
		mav.setViewName("redirect:"+referer);
		return mav;
	}
	@RequestMapping(value="/member/applyInstructCancel.do")
	public ModelAndView applyInstructCancel(@RequestParam(value="ino",required=false , defaultValue="-1" )int ino , HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		int result = memberService.updateInstructorCancel(ino);
		if(result <0) {
			
		}else {
		}
		String referer = request.getHeader("Referer");
		mav.setViewName("redirect:"+referer);
		return mav;
	}
	
	@RequestMapping("/member/boardDownload.do")
	public void fileDownload(@RequestParam String oName,
							 HttpServletRequest request,
							 HttpServletResponse response) {
		System.out.println("와???????");
		System.out.println("파일다운로드페이지["+oName+"]");
		//logger.debug("파일다운로드페이지["+oName+"]");
		
		BufferedInputStream bis = null;
		ServletOutputStream sos = null;
		String saveDirectory = request.getSession()
									  .getServletContext()
									  .getRealPath("/resources/upload/instructor");
		System.out.println("saveDirectory : "+saveDirectory);
		File savedFile = new File(saveDirectory+"/"+oName);
		System.out.println("savedFile : "+savedFile );
		try {
			bis = new BufferedInputStream(new FileInputStream(savedFile));
			System.out.println("bis : "+bis);
			sos = response.getOutputStream();
			
			
			System.out.println("savedFile = "+savedFile);
			//응답세팅
			response.setContentType("application/octet-stream; charset=utf-8");
			
			//한글파일명 처리
			String resFilename = "";
			boolean isMSIE = request.getHeader("user-agent")
									.indexOf("MSIE") != -1 ||
							 request.getHeader("user-agent")
							 		.indexOf("Trident") != -1;
			if(isMSIE) {
				//ie는 utf-8인코딩을 명시적으로 해줌.
				resFilename = URLEncoder.encode(oName, "utf-8");
				resFilename = resFilename.replaceAll("\\+", "%20");
			}
			else {
				resFilename = new String(oName.getBytes("utf-8"),"ISO-8859-1");
			}
			logger.debug("resFilename="+resFilename);
			response.addHeader("Content-Disposition", 
					"attachment; filename=\""+resFilename+"\"");
			
			
			//쓰기
			int read = 0;
			while((read=bis.read())!=-1) {
				sos.write(read);
			}
			
			
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				sos.close();
				bis.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		
		
	}
	/* 강사확인  */
	@RequestMapping(value = "/member/instructerCheckO.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> instructerCheckO(@RequestParam(value = "mno") int mno) {
		Map<String, Object> map = new HashMap<>();
		
		System.out.println("mno : "+ mno);
		int result = memberService.instructorCheckO(mno);
		System.out.println("result : "+ result);
		if(result ==1) {
			map.put("stack", false);
			
		}else {
			
			map.put("stack", true);
		}
		
		return map;
	}
		
	/* 관리자 접속 여부 확인 
	@RequestMapping(value="/member/adminInnerCheck.do",method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> adminInnerCheck( @RequestParam(value = "urlname") String urlname){
		Map<String,Object> map = new HashMap<>();
		Map<String,String> link = new HashMap<>();
		link.put("urlname",urlname);
		link.put("check","0");
		int result = 0;
		try {
			result = memberService.adminInnerCheck(link);			
		} catch (Exception e) {
		}
		if(result ==1) {
			map.put("check", true);
		} else {
			map.put("check", false);
		}
		return map;
	}*/
	
	
	
	/*김률민 2018 07 07 추가 작업**************************************************************************/
	@RequestMapping(value="/member/memberMessageList", method=RequestMethod.GET)
	@ResponseBody
	public ModelAndView memberMessageList(@RequestParam (value="cPage", required=false, defaultValue="1") int cPage, 
										@RequestParam (required=false) Map<String, String> queryMap,
		 							@PathVariable(value="location", required=false) String location, HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		int numPerPage = 10;
		Member m = (Member)request.getSession().getAttribute("memberLoggedIn");
		
		if(m != null) {
			queryMap.put("receivermno", String.valueOf(m.getMno()));
			List<Map<String, String>> listAll = messageService.messageList();
			List<Map<String, String>> listQuery = messageService.messageList(queryMap);
			List<Map<String, String>> listQueryPage = messageService.messageList(cPage, numPerPage, queryMap);
			
			
			int totalCount = messageService.messageCount(queryMap);
			
			mav.addObject("count", totalCount);
			mav.addObject("numPerPage", numPerPage);
			
			mav.addObject("listAll", listAll);
			mav.addObject("listQuery", listQuery);
			mav.addObject("listQueryPage", listQueryPage);
		}
		
		return mav; 
	}

	
	

	
	/*****   장익순 작업 ****/
	@RequestMapping("/member/selectViewInstructor.do")
	public ModelAndView selectViewInstructor(@RequestParam(value="mid") String mid,@RequestParam(value="size" ,required=false , defaultValue="-1") int size) {
		ModelAndView mav = new ModelAndView();
		System.out.println(mid);
		Member m = memberService.selectOneMember(mid);
		List<Map<String,String>> reviewList = memberService.selectMemberReviewList(m.getMno());
		
		
		Map <String,Object> map = new HashMap<>();
		map.put("eval", "exp");
		map.put("mno", m.getMno());
		
		Map<String, Object> list = memberService.searchEvaluation(map);
		List<Map<String,Object>> gradeList = memberService.selectGradeList();
		//경험치 및 포인트 등급 보여주기
		List<Map<String,Object>> replyList = memberService.selectmemberReply(m.getMno());
		Map<String,String> instruct = memberService.selectOneInstruct(m.getMno());
		System.out.println("size = "+size);
		if(size==10) {
			mav.addObject("size",size);
			List<Map<String, String>> category = memberService.selectCategory();
			
			System.out.println(category);
			mav.addObject("category", category);
		}
		
		//평가 관리 페이지로 이동
		mav.addObject("instruct", instruct); 
		mav.addObject("eval", "exp"); 
		mav.addObject("list", list); 
		mav.addObject("gradeList", gradeList); 
		mav.addObject("gradeMin", gradeList.get(0)); 
		mav.addObject("gradeMax", gradeList.get(gradeList.size()-1)); 
		mav.addObject("replyList",replyList);
		mav.addObject("m",m);
		mav.addObject("reviewList", reviewList);
		mav.setViewName("instructor/selectViewInstructor");
		return mav;
	}
	
	/*****장익순 작업 끝******/
	@RequestMapping(value="/member/memberMessageView", method=RequestMethod.GET)
	@ResponseBody
	public ModelAndView memberMessageView(@RequestParam (value="messageNo", required=false, defaultValue="1") int messageNo, 
										  @RequestParam (required=false) Map<String, String> queryMap,
										  HttpServletRequest request){
		ModelAndView mav = new ModelAndView("jsonView");
		Member m = (Member)request.getSession().getAttribute("memberLoggedIn");
		
		
		
		
		if(m != null) {
/*			queryMap.put("mno", String.valueOf(m.getMno()));*/
			queryMap.put("messageNo", String.valueOf(messageNo));
			queryMap.put("receivermno", String.valueOf(m.getMno()));
			queryMap.put("checkdate", "checkdate");
			
			Map<String, String> resultMap = messageService.messageOne(queryMap);
			System.out.println(resultMap);
			
			if(resultMap.get("MESSAGENO") != null ) {
				int readCheck = messageService.messageReadCheck(queryMap);
				if(readCheck > 0 ) {
				  resultMap = messageService.messageOne(queryMap);	
	              ObjectMapper mapper = new ObjectMapper();
	              int count = messageService.messageCount(queryMap);
					  Message message = new Message("view:message", String.valueOf(m.getMno()), String.valueOf(m.getMno()), queryMap.get("messageNo")+"^"+String.valueOf(resultMap.get("CHECKDATE")), count);
		  				try {
							echoHandler.handleMessage(echoHandler.getSessions().get( String.valueOf(m.getMno())), new TextMessage(mapper.writeValueAsString(message)));
						} catch (JsonProcessingException e) {
							e.printStackTrace();
						} catch (Exception e) {
							e.printStackTrace();
						}
				}
			}
			mav.addObject("resultMap", resultMap);
		}
		
		return mav; 
	}
	
	@RequestMapping(value="/member/memberSearch", method=RequestMethod.GET)
	@ResponseBody
	public ModelAndView memberSearch(@RequestParam (value="searchType", required=false, defaultValue="") String searchType,
									 @RequestParam (value="mname", required=false, defaultValue="") String mname,
								     @RequestParam (required=false) Map<String, String> queryMap,
										  HttpServletRequest request){
		ModelAndView mav = new ModelAndView("jsonView");
		
		Member m = (Member)request.getSession().getAttribute("memberLoggedIn");
		if(m != null) {
			List<Map<String, String>> resultListMap = memberService.memberSearch(queryMap);
			mav.addObject("resultListMap", resultListMap);
		}else {
			mav.addObject("msg", "로그인후 이용해 주세요");
			mav.addObject("loc", "/");
			mav.setViewName("common/msg");
			return mav;
		}
		
		return mav; 
	}
	
	
	/*김률민 2018 07 07 추가 작업**************************************************************************/
}
