package com.pure.study.member.controller;

import java.io.File;
import java.io.IOException;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.pure.study.member.model.service.MemberService;
import com.pure.study.member.model.vo.Member;

@SessionAttributes({ "memberLoggedIn" })
@Controller
public class MemberController {

	// private Logger logger = LoggerFactory.getLogger(getClass());

	@Autowired
	private MemberService memberService;

	@Autowired
	private BCryptPasswordEncoder bcryptPasswordEncoder;

	@Autowired
	private JavaMailSender mailSender;
	
	Logger logger = LoggerFactory.getLogger(getClass());
	
	/**********************************회원가입(장익순) 시작*/
	@RequestMapping(value = "/member/memberAgreement.do")
	public ModelAndView memberAgreement() {
		if (logger.isDebugEnabled()) {
			logger.debug("회원동의홈페이지");
		}
		ModelAndView mav = new ModelAndView();
		List <Map<String , String>> service = memberService.serviceagree();
		List <Map<String , String>> information = memberService.informationagree();
		System.out.println(service);
		System.out.println(information);
		
		mav.addObject("service", service);
		mav.addObject("information", information);
		return mav;
	}
	/* 정보 입력페이지 이동 시작 */
	@RequestMapping(value = "/member/memberEnroll.do")
	public ModelAndView memberEnroll(@RequestParam(value="check", required=false, defaultValue="1")  int check,
			@RequestParam(value="agree1", required=false, defaultValue="2")  int agree1,
			@RequestParam(value="agree2", required=false, defaultValue="2")  int agree2)  {
		
		if (logger.isDebugEnabled()) {
			logger.debug("회원등록홈페이지");
		}
		System.out.println(check);
		ModelAndView mav = new ModelAndView();
		int c = check+agree1+agree2;
		System.out.println(c);
		if(c != 23) {
			String loc = "/member/memberAgreement.do";
			String msg = "회원가입을 실패했습니다.";
			mav.addObject("msg", msg);
			mav.addObject("loc", loc);
			mav.setViewName("common/msg");
			return mav;
		}
		List<Map<String, String>> list = memberService.selectCategory();
		System.out.println(list);

		mav.addObject("list", list);
		return mav;
	}
	
	/* mailSending 코드 전송 */
	@RequestMapping(value = "/member/certification.do")
	@ResponseBody
	public Map<String, Object> mailCertification(HttpServletRequest request, @RequestParam(value = "em") String em) {
		Map<String, Object> map = new HashMap<>();
		String setfrom = "kimemail2018@gmail.com";
		String tomail = em; // 받는 사람 이메일
		String title = "( 스터디 그룹트 ) 회원가입 인증번호 내역"; // 제목
		String content = "회원님 \n인증번호는  "; // 내용
		String ranstr = "";
		for (int i = 0; i < 4; i++) {
			int ran = (int) (Math.random() * 10); 
			ranstr += ran;
		}
		System.out.println(tomail);
		
		String encoded = bcryptPasswordEncoder.encode(ranstr);
		content += ranstr;

		int checkemail = memberService.checkEmail(tomail);
		int result = 0;
		if (checkemail == 0) {
			result = memberService.insertMailCertification(tomail, encoded);
		} else {
			result = memberService.uploadMailCertification(tomail, encoded);
		}
		try {
			MimeMessage message = mailSender.createMimeMessage();
			MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "UTF-8");
			messageHelper.setFrom(setfrom); // 보내는사람 생략하거나 하면 정상작동을 안함
			messageHelper.setTo(tomail); // 받는사람 이메일
			messageHelper.setSubject(title); // 메일제목은 생략이 가능하다
			messageHelper.setText(content); // 메일 내용

			mailSender.send(message);
		} catch (Exception e) {
		}
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
		cer = memberService.selectCheckJoinCode(email);
		if (bcryptPasswordEncoder.matches(inputCode, cer.get("CERTIFICATION"))) {
			map.put("result", true);
		} else {
			map.put("result", false);
		}
		System.out.println(map);
		return map;
	}
		


	
	/*주소입력*/
	@RequestMapping(value="/member/jusoPopup.do")
	public String jusoPopup() {
		return "member/jusoPopup";
	}
	
	/*파일 업로드 시작*/
	@RequestMapping(value="/member/memberImgUpload.do")
	public ModelAndView insertBoard(Model model,@RequestParam(value="upFile",required=false) MultipartFile[] upFiles,HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		logger.debug("게시판 페이지저장");
		logger.debug("upFiles.length="+upFiles.length);
		logger.debug("upFile1="+upFiles[0].getOriginalFilename());
		
		Map<String , String> map = new HashMap<>();
	
		//1.파일업로드처리
		String saveDirectory = request.getSession().getServletContext().getRealPath("/resources/upload/member");
		String renamedFileName ="";
		/****** MultipartFile을 이용한 파일 업로드 처리로직 시작 ******/
		for(MultipartFile f: upFiles) {
			if(!f.isEmpty()) {
				//파일명 재생성
				String originalFileName = f.getOriginalFilename();
				String ext = originalFileName.substring(originalFileName.lastIndexOf(".")+1);
				SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmssSSS");
				int rndNum = (int)(Math.random()*1000);
				renamedFileName = sdf.format(new Date(System.currentTimeMillis()))+
										"_"+rndNum+"."+ext;
				try {
					f.transferTo(new File(saveDirectory+"/"+renamedFileName));
				} catch (IllegalStateException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		/****** MultipartFile을 이용한 파일 업로드 처리로직 끝 ******/

		//3.view단 분기
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
		Map<String, String> cer = memberService.selectCheckJoinCode(email);
		System.out.println("email : " + email);
		String loc = "/";
		String msg = "";
		if (cer == null) {
			msg = "회원가입을 실패했습니다.";
			model.addAttribute("loc", loc);
			model.addAttribute("msg", msg);
			return "common/msg";
		}

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

		int result = memberService.memberEnrollEnd(member);

		memberService.deleteCertification(email);

		// 2.처리결과에 따라 view단 분기처리

		if (result > 0)
			msg = "회원가입성공!";
		else
			msg = "회원가입성공!";

		model.addAttribute("loc", loc);
		model.addAttribute("msg", msg);

		return "common/msg";
	}
	
	/*ID 중복 검사 시작 */
	@RequestMapping(value="/member/checkIdDuplicate.do")
	@ResponseBody
	public Map<String,Object> checkIdDuplicate(@RequestParam("userId") String userId) throws IOException {
		logger.debug("@ResponseBody-javaobj ajax : "+userId);
		Map<String,Object> map = new HashMap<>();
	
		//업무로직
		int count = memberService.checkIdDuplicate(userId);
		logger.debug("count : "+count);
		boolean isUsable = count==0?true:false;
		logger.debug(""+isUsable);
		
		map.put("isUsable", isUsable);
		
		return map;
	}
	
	/*회원가입(장익순) 끝*********************************/
	
	
	
	
	/**********************************************로그인 및 마이페이지(김회진) 시작*/
	/*******************************로그인&로그아웃 시작*/
	@RequestMapping(value="/member/memberLogin.do", method = RequestMethod.POST)
	public ModelAndView memberLogin(HttpServletRequest request, @RequestParam(value="userId") String userId, @RequestParam(value="pwd") String pwd) {
		ModelAndView mav = new ModelAndView();

		System.out.println(userId);
		
		Member m = memberService.selectOneMember(userId);

		String msg = "";
		String loc = "/";

		if (m == null || m.getQdate() != null) {
			msg = "존재하지 않는 아이디입니다.";
		} else {
			if (bcryptPasswordEncoder.matches(pwd, m.getPwd())) {
				//msg = "로그인성공!";
				mav.addObject("memberLoggedIn", m);
				mav.setViewName("redirect:/");
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
	public String memberLogout(SessionStatus sessionStatus) {

		if (!sessionStatus.isComplete())
			sessionStatus.setComplete();

		return "redirect:/";
	}
	
	/*로그인&로그아웃 끝*********************************/
	
	/**************** id, pwd찾기 */
	// 아이디,비밀번호 찾기 페이지로 이동
	@RequestMapping(value="/member/memberFindPage.do")
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
			mav.addObject("loc", loc);
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
				messageHelper.setSubject("스터디 그룹 임시 비밀번호 발송"); // 메일제목은 생략이 가능하다
				
				// 4. 인증키를 암호화 한다.
				Member changeM = new Member();
				String encodedPassword = bcryptPasswordEncoder.encode(tempPwd);
				changeM.setPwd(encodedPassword);
				changeM.setMid(mid);
				
				// 4.1 암호화 한 인증키를 디비에 넣어준다.(임시 비밀번호처럼 )
				int result = memberService.updatePwd(changeM);
				
				// 4.2 메일 내용에 form을 이용하여 비밀번호를 변경하고자 하는 아이디와 인증키(페이지의 유효성?을 위해)를 보내준다.
				messageHelper.setText(new StringBuffer().append("<form action='http://localhost:9090/study/member/memberPwd.do' target=\"_blank\" method='post'>")
						.append("<input type='hidden' name='mid' value='" + mid + "'/>")
						.append("<input type='hidden' name='key' value='" + encodedPassword + "'/>")
						.append("<button type='submit'>비밀번호 변경하러 가기</button>").append("</form>").toString(), true); // 메일
				
				mailSender.send(message);
			} catch (Exception e) {
				e.getStackTrace();
			}

		} else {
			msg = "일치하는 회원 정보가 없습니다.";
		}

		mav.addObject("loc", loc);
		mav.addObject("msg", msg);

		mav.setViewName("common/msg");

		return mav;
	}

	// 5. 암호화 한 인증키를 이동시켜준다.
	@RequestMapping(value = "/member/memberPwd.do", method = RequestMethod.POST)
	public ModelAndView pwd(String mid, String key) {
		ModelAndView mav = new ModelAndView();
		
		//System.out.println("이동 중인 값 : "+ key);
		
		// 인코딩 된 키 값과 디비에 있는 값(임시 비밀번호)을 비교하고 맞으면 비밀번호를 바꿔준다.
		Member m = memberService.selectOneMember(mid);
		
		if (key.equals(m.getPwd())) {
			mav.setViewName("member/memberUpdatePwd");
		}else {
			System.out.println("값은 있지만 비번이 서로 매치가 안됨");// 유효성
			mav.addObject("loc", "/");
			mav.addObject("msg", "잘못된 접근입니다.");
			mav.setViewName("common/msg");
			
		}

		mav.addObject("mid", mid);
		mav.addObject("key", key);
	
		return mav;
		
		/*mav.addObject("mid", mid);
		mav.addObject("key", key);
		mav.setViewName("member/memberUpdatePwd");

		return mav;*/
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
			msg = "잘못된 접근입니다.";
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
				msg = "잘못된 접근입니다.";
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
	
	
	/****************************개인 정보 수정 시작*/
	//개인 정보 수정 페이지로 이동
	@RequestMapping(value="/member/memberView.do")
	public ModelAndView memberView(@ModelAttribute("memberLoggedIn") Member m) {
		ModelAndView mav = new ModelAndView();
		
		List<Map<String, String>> favor = memberService.selectKind();
		
		m = memberService.selectOneMember(m);
		
		if(m!=null) {
			System.out.println(m);
			mav.addObject("memberLoggedIn", m);
			mav.addObject("favor", favor);
			mav.setViewName("member/memberView");
		}else {
			mav.addObject("msg", "로그인 후 이용해 주세요");
			mav.addObject("loc", "/");
			
			mav.setViewName("common/msg");
			
		}
		
		
		return mav;
	}
	
	//개인 번호 수정 - 비밀번호 변경
	@RequestMapping(value="/member/newPwd.do", method = RequestMethod.POST)
	public String newPwd(@RequestParam("newPwd") String newPwd
							, @RequestParam("oldPwd") String oldPwd
							, @ModelAttribute("memberLoggedIn") Member m
							, SessionStatus sessionStatus
							, Model model) {
		
		Member oldMember = memberService.selectOneMember(m.getMid());
		
		
		if(bcryptPasswordEncoder.matches(oldPwd, oldMember.getPwd())) {
			Member changeM = new Member();
			String encodedPwd = bcryptPasswordEncoder.encode(newPwd);
			changeM.setPwd(encodedPwd);
			changeM.setMid(m.getMid());
			
			int result = memberService.updatePwd(changeM);
			
			if(result>0) {
				
				if (!sessionStatus.isComplete())
					sessionStatus.setComplete();
				
				return "redirect:/";
			}else {
				model.addAttribute("loc", "/member/memberView.do");
				model.addAttribute("msg", "비밀번호가 변경되지 않았습니다.");
				
			}
		}else {
			model.addAttribute("loc", "/member/memberView.do");
			model.addAttribute("msg", "비밀번호가 일치 하지 않습니다.");
		}
						
		return "common/msg";
	}
	
	//개인 정보 수정 - 전체 수정
	@RequestMapping(value="/member/updateUser.do", method= RequestMethod.POST)
	public String updateUser(@RequestParam("mno") int mno, @RequestParam("mid") String mid
							, @RequestParam("mname") String mname, @RequestParam("phone") String phone
							, @RequestParam("post") String post,@RequestParam("addr1") String addr1
							,@RequestParam("addr2") String addr2,@RequestParam("addrDetail") String addrDetail
							,@RequestParam("email")String email
							, @RequestParam("birth") Date birth, @RequestParam("gender") String gender
							, @RequestParam("favor") String[] favor, @RequestParam("cover") String cover
							, @RequestParam(value="mprofile", required=false) MultipartFile[] mprofile
							, HttpServletRequest request, Model model, @RequestParam("pre_mprofile") String pre_mprofile
							, @ModelAttribute("memberLoggedIn") Member m
							) {
		Member member = new Member();
		
		String saveDirectory = request.getSession().getServletContext().getRealPath("/resources/upload/member");
		if(mprofile != null) {
			/*********** MultipartFile을 이용한 파일 업로드 처리 로직 시작 **********/
			for(MultipartFile f: mprofile) {
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
					//vo객체 담기
					member.setMprofile(originalFileName);
					
				}
			}
		}else {
			member.setMprofile(pre_mprofile);
		}
		
		
		member.setMno(mno);
		member.setMname(mname);
		member.setPhone(phone);
		member.setPost(post);
		member.setAddr1(addr1);
		member.setAddr2(addr2);
		member.setAddrDetail(addrDetail);
		member.setEmail(email);
		member.setBirth(birth);
		member.setGender(gender);
		member.setGender(gender);
		member.setFavor(favor);
		member.setCover(cover);
		
		int result = memberService.updateMember(member);
		
		if(result>0) {
			model.addAttribute("memberLoggedIn", member);
			
			if(mid==m.getMid()) {
				model.addAttribute("msg", "회원 정보가 변경되었습니다.");
			}
			model.addAttribute("msg", "회원 아이디는 변경할 수 없습니다.");				
			model.addAttribute("loc", "/member/memberView.do");
			
		}else {
			model.addAttribute("msg", "회원 정보가 변경되지 않았습니다.");
			model.addAttribute("loc", "/member/memberView.do");
		}
		
		return "common/msg";
	}
	
	//개인 정보 수정 - 탈퇴하기
	@RequestMapping(value="/member/memberDrop.do")
	public String memberDrop(@RequestParam("mid") String mid, Model model, SessionStatus sessionStatus) {
		
		//탈퇴일만
		int result = memberService.dropMember(mid);
		
		if(result>0) {
			if (!sessionStatus.isComplete())
				sessionStatus.setComplete();
			return "redirect:/";
		}else {
			model.addAttribute("msg", "오류가 발생하였습니다.");
			model.addAttribute("loc", "/");
			
			
		}
		return "common/msg";
	}
	
	//개인 정보 수정 - 이메일 변경(인증키 생성 및 메일 보내주기)
	@RequestMapping(value="/member/newEmailKey.do")
	@ResponseBody
	public Map<String, Object> newEmailKey(@RequestParam(value="newEmail") String newEmail) throws JsonProcessingException{
		
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


			messageHelper.setFrom("kimemail2018@gmail.com"); // 보내는사람 생략하거나 하면 정상작동을 안함
			messageHelper.setTo(newEmail); // 받는사람 이메일
			messageHelper.setSubject("스터디 그룹 이메일 인증번호 발송"); // 메일제목은 생략이 가능하다
			messageHelper.setText("이메일 인증 번호는 ["+tempPwd+"] 입니다.");
					
			mailSender.send(message);
			isUsable = true;
		} catch (Exception e) {
			e.getStackTrace();
		}
		
		map.put("isUsable", isUsable);
		map.put("tempPwd", tempPwd);
		
		return map;
	}
	
	//개인 정보 수정 - 이메일 변경(인증된 이메일로 디비 값 변경 )	
	@RequestMapping(value="/member/newEmail.do", method= RequestMethod.POST)
	public String newEmail(HttpServletRequest request, @RequestParam("email") String email, Model model, @ModelAttribute("memberLoggedIn") Member m) {
		//System.out.println(email+"로 이메일 변경해주기");
				
		m.setEmail(email);
		int result = memberService.updateEmail(m);
		
		if(result>0) {
			model.addAttribute("memberLoggedIn", m);
			return "redirect:/member/memberView.do";
		}else {
			model.addAttribute("msg", "이메일이 변경되지 않았습니다.");
			model.addAttribute("loc", "member/memberView.do");
			return "common/msg";
		}
	}
	/*개인 정보 수정 끝**********************************/
	
	/**************************내 스터디 & 신청 & 찜 목록 시작*/
	@RequestMapping("/member/searchMyPageKwd.do")
	@ResponseBody
	public ModelAndView searchPageWish (@RequestParam(value="cPage", required=false, defaultValue="1") int cPage
									, @RequestParam(value="searchKwd", defaultValue="title") String searchKwd
									, @RequestParam(value="kwd", required=false, defaultValue="") String kwd
									, @RequestParam(value="type", defaultValue="study") String type									
									, @RequestParam(value="applyDate",required=false, defaultValue="present") String applyDate
									, @RequestParam(value="myPage",required=false, defaultValue="study") String myPage
									, @RequestParam(value="leader", defaultValue="y") String leader									
									, @ModelAttribute("memberLoggedIn") Member m
									) {
		ModelAndView mav = new ModelAndView();
		
		int numPerPage = 5;
		
		Map<String,String> map = new HashMap<>();
		map.put("mno", String.valueOf(m.getMno()));
		map.put("applyDate", applyDate);
		System.out.println("확인:"+kwd);
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
		//mapper 수정이 필요함
		map.put("searchKwd", searchKwd);
		map.put("type", type);
		map.put("myPage", myPage);
		map.put("leader", leader);
		
		List<Map<String,String>> list = null;
		int count = 0;		
		List<Map<String,String>> leaderList = null;
		int leaderCount = 0;
		
		if("study".equals(myPage)) {
			//팀원일 때, 내 스터디
			if ("n".equals(leader)) {
				 list = memberService.selectMyStudyList(map, numPerPage, cPage);
				count = memberService.selectMyStudyListCnt(map);
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
		
		
		System.out.println("값이 잘 있나용?"+list);
		System.out.println("값이 잘 있나용?"+count);
		
		mav.addObject("type", type);
		mav.addObject("myPage", myPage);		
		mav.addObject("applyDate", applyDate);
		mav.addObject("kwd", kwd);
		mav.addObject("searchKwd", searchKwd);
		mav.addObject("myPageList", list);
		mav.addObject("count", count);
		mav.addObject("leader", leader);
		mav.addObject("leaderList", leaderList);
		mav.addObject("leaderCount", leaderCount);
		mav.addObject("numPerPage", numPerPage);
		mav.addObject("memberLoggedIn", m);
		
		
		return mav;
	}
	
	/*내 스터디 & 신청 & 찜  목록 끝*******************************/
	
	/*로그인 및 마이페이지(김회진) 끝**********************************************/
	
	
}