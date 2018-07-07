package com.pure.study.rest;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.socket.WebSocketSession;

import com.pure.study.adversting.model.service.AdverstingService;
import com.pure.study.adversting.model.vo.Adversting;
import com.pure.study.board.model.service.BoardService;
import com.pure.study.board.model.service.ReplyService;
import com.pure.study.common.websocket.EchoHandler;
import com.pure.study.lecture.model.service.LectureService;
import com.pure.study.member.model.service.MemberService;
import com.pure.study.member.model.vo.Member;
import com.pure.study.rest.model.RestService;
import com.pure.study.study.model.service.StudyService;
@SessionAttributes({ "memberLoggedIn" })
@Controller
public class RestController {
	
	@Autowired
	private RestService restService;
	
	@Autowired
	private StudyService studyService;
	
	@Autowired
	private LectureService lectureService;
	
	@Autowired
	private MemberService memberService;
	
	@Autowired
	private BoardService boardService;
	
	@Autowired
	private AdverstingService adverstingService;
	
	@Autowired
	private BCryptPasswordEncoder bcryptPasswordEncoder;
	
	@Autowired
	private ReplyService replyService; 
	
	@Autowired
	private RestMemberService rs;
	
	@Autowired
	private EchoHandler echoHandler;
	
	Logger logger = LoggerFactory.getLogger(getClass());

	
	
	@RequestMapping(value="/rest/study/all/{cPage}/{count}", method=RequestMethod.GET)
	@ResponseBody
	public ModelAndView selectStudyPageCount(@PathVariable(value="count", required=false) int count, @PathVariable(value="cPage", required=false) int cPage) {
		
		ModelAndView mav = new ModelAndView("jsonView");
		List<Map<String, Object>> list = studyService.selectStudyList(cPage, count);
		int total = studyService.studyTotalCount();
		
		mav.addObject("list", list);
		mav.addObject("numPerPage", count);
		mav.addObject("cPage",cPage);
		mav.addObject("total",total);
		return mav;
	}

	@RequestMapping(value="/rest/studyCount", method=RequestMethod.GET)
	@ResponseBody
	public ModelAndView studyCounter() {
		ModelAndView mav = new ModelAndView("jsonView");
		int count = studyService.studyTotalCount();
		mav.addObject("count", count);
		return mav;
	}
	
	@RequestMapping(value="/rest/lectureCount", method=RequestMethod.GET)
	@ResponseBody
	public ModelAndView lectureCounter() {
		ModelAndView mav = new ModelAndView("jsonView");
		
		int count = lectureService.selectTotalLectureCount();
		mav.addObject("count", count);
		return mav;
	}

	@RequestMapping(value="/rest/memberCount", method=RequestMethod.GET)
	@ResponseBody
	public ModelAndView memberCounter() {
		ModelAndView mav = new ModelAndView("jsonView");
		
		int count = memberService.selectCntAllMemberList();
		mav.addObject("count", count);
		return mav;
	}
	
	
	@RequestMapping(value="/rest/counter", method=RequestMethod.GET)
	@ResponseBody
	public ModelAndView counter() {
		ModelAndView mav = new ModelAndView("jsonView");
		int study = studyService.studyTotalCount();
		int lecture = lectureService.selectTotalLectureCount();
		int member = memberService.selectCntAllMemberList();
		int board = boardService.selectCount();
		int reply = replyService.replyCount();
		
		mav.addObject("study", study);
		mav.addObject("lecture", lecture);
		mav.addObject("member", member);
		mav.addObject("board", board);
		mav.addObject("reply", reply);
		return mav;
	}
	
	
	@RequestMapping(value="/rest/study/all/{count}", method=RequestMethod.GET)
	@ResponseBody
	public ModelAndView selectStudyCount(@PathVariable(value="count", required=false) int count,  @RequestParam(value="filter", required=false) String filter) {
		
		Adversting adversting = new Adversting();
		Map<String, String> map = new HashMap<>();
		
		ModelAndView mav = new ModelAndView("jsonView");
		List<Map<String, Object>> list = studyService.selectStudyList(1, count);
		mav.addObject("list", list);
		return mav;
	}
	
	@RequestMapping(value="/rest/study/one/{sno}", method=RequestMethod.GET)
	@ResponseBody
	public ModelAndView selectStudyOne(@PathVariable int sno,  @RequestParam(value="filter", required=false) String filter) {
		
		ModelAndView mav = new ModelAndView("jsonView");
		Map<String, Object> study= studyService.selectStudyOne(sno);
		mav.addObject("study", study);
		return mav;
	}
	
	
	@RequestMapping("/study/studyDetailView")
	public ModelAndView selectStudyOneView(@RequestParam(value="sno") int sno){
		ModelAndView mav = new ModelAndView();
		Map<String,Object> study = studyService.selectStudyOne(sno);
		mav.addObject("study", study);
		mav.setViewName("study/studyDetailView");
		return mav;
	}
	
	
	@RequestMapping(value="/rest/lecture/{count}", method=RequestMethod.GET)
	@ResponseBody
	public ModelAndView selectLectureCount(@PathVariable int count,  @RequestParam(value="filter", required=false) String filter) {
		
		
		ModelAndView mav = new ModelAndView("jsonView");
		System.out.println(count);
		List<Map<String, Object>> list = lectureService.selectLectureList(1, count);
		mav.addObject("list", list);
		return mav;
	}
	
	
	//회원 가져와볼까
	
	@RequestMapping(value="/rest/member/{type}/{cPage}/{count}", method=RequestMethod.GET)
	@ResponseBody
	public ModelAndView selectMemberPageCount(@PathVariable(value="type", required=false) String type, @PathVariable(value="count", required=false) int count, @PathVariable(value="cPage", required=false) int cPage) {
		
		ModelAndView mav = new ModelAndView("jsonView");
		
		List<Map<String, Object>> list = null;
		int total = 0;
		
		if(type.equals("instructor")) {
			list = memberService.selectInstructorMember(cPage, count);
			total = memberService.selectCntInstructorMember();
		}else if(type.equals("member")) {
			list = memberService.selectAllMemberList(cPage, count);
			total = memberService.selectCntAllMemberList();
		}
		
		mav.addObject("list", list);
		mav.addObject("numPerPage", count);
		mav.addObject("cPage",cPage);
		mav.addObject("total",total);
		return mav;
	}
	
	
	
	
	
	
	//게시판
	@RequestMapping(value="/rest/board/{type}/{cPage}/{count}", method=RequestMethod.GET)
	@ResponseBody
	public ModelAndView selectBoardPageCount(@PathVariable(value="type", required=false) String type, 
												  @PathVariable(value="count", required=false) int count, 
												  @PathVariable(value="cPage", required=false) int cPage,
												  @RequestParam Map<String, String> queryMap) {
		
		ModelAndView mav = new ModelAndView("jsonView");
		
		if(type.equals("all")) {
			type="";
		}else {
			
		}
		queryMap.put("type",type);
		
		List<Map<String, String>> list = boardService.selectBoardList(cPage, count, queryMap);
		
		int total = boardService.selectCount();
		
		mav.addObject("list", list);
		mav.addObject("numPerPage", count);
		mav.addObject("cPage",cPage);
		mav.addObject("total",total);
		return mav;
	}
	
	// none Rest
	@RequestMapping(value="/rest/board/list", method=RequestMethod.GET)
	@ResponseBody
	public ModelAndView boardList(@RequestParam Map<String, String> queryMap, 
								  @RequestParam(value="type", required=false, defaultValue="") String type,		
								  @RequestParam(value="cPage", required=true, defaultValue="1") int cPage,		
								  @RequestParam(value="viewCount", required=true, defaultValue="10") int viewCount){		
		
		ModelAndView mav = new ModelAndView("jsonView");
		
		List<Map<String, String>> list = boardService.selectBoardList(cPage, viewCount, queryMap);
		int total = boardService.selectCount(queryMap);
		mav.addObject("list", list);
		mav.addObject("queryMap", queryMap);
		mav.addObject("viewCount", viewCount);
		mav.addObject("cPage",cPage);
		mav.addObject("total",total);
		return mav;
	}
	
	
	//광고관련
	@RequestMapping(value="/rest/adversting/{type}/{cPage}/{count}", method=RequestMethod.GET)
	@ResponseBody
	public ModelAndView selectAdverstingPageCount(@PathVariable(value="type", required=false) String type, 
												  @PathVariable(value="count", required=false) int count, 
												  @PathVariable(value="cPage", required=false) int cPage,
												  @RequestParam Map<String, String> queryMap) {
		
		ModelAndView mav = new ModelAndView("jsonView");
		
		List<Map<String, String>> list = adverstingService.adverstingListPaging(cPage, count, queryMap);
		int total = adverstingService.adverstingTotalCount(queryMap);
		
		mav.addObject("list", list);
		mav.addObject("numPerPage", count);
		mav.addObject("cPage",cPage);
		mav.addObject("total",total);
		return mav;
	}
	
	
	/*로그인*/
	@RequestMapping(value="/member/memberLogin", method = RequestMethod.POST)
	public ModelAndView memberLogin(HttpServletRequest request, HttpServletResponse response,
									@RequestParam(value="userId") String userId, 
									@RequestParam(value="pwd") String pwd, 
									@RequestParam(value="admin", required=false) String admin,
									@RequestParam(value="remember", required=false) String remember){
		ModelAndView mav = new ModelAndView();
		Member m = memberService.selectOneMember(userId);

		String msg = ""; 
		String loc = "/";
		
		if (m == null || m.getQdate() != null) {
			msg = "존재하지 않는 아이디입니다.";
		} else {
			if (bcryptPasswordEncoder.matches(pwd, m.getPwd())) {
				//msg = "로그인성공!";
				
				mav.addObject("memberLoggedIn", m);
				System.out.println("remember " + remember );
				if(remember != null) {
					Cookie rememberLogin = new Cookie("remember", m.getMid()); // 쿠키 생성
					
					rememberLogin.setMaxAge(3*(24*60*60)); // 3일
					rememberLogin.setPath("/");
					response.addCookie(rememberLogin);
				}else {
					Cookie rememberLogin = new Cookie("remember", "");
					rememberLogin.setMaxAge(0);
					rememberLogin.setPath("/");
					response.addCookie(rememberLogin);
					
				}
				if(admin==null) {
					mav.setViewName("redirect:/");
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
	
	
	
	//통계관련
	@RequestMapping(value="/rest/{location}/replyDateStatisticsList", method=RequestMethod.GET)
	@ResponseBody
	public ModelAndView replyDateStatisticsList( 
												  @PathVariable(value="location", required=false) String location, 
												  @RequestParam Map<String, String> queryMap) {
		
		ModelAndView mav = new ModelAndView("jsonView");
		String msg = ""; 
		String loc = "/";
		
		System.out.println(location);
		if( location !=  null && !location.equals("admin")) {
			mav.addObject("msg", "잘못된 경로입니다");
			mav.addObject("loc", "/");
			mav.setViewName("common/msg");
			return mav;
		}
		

		List<Map<String, String>> list = replyService.replyDateStatisticsList(queryMap);
		
		mav.addObject("list", list);
		return mav;
	}
	
	@RequestMapping(value="/rest/{location}/statistics", method=RequestMethod.GET)
	@ResponseBody
	public ModelAndView statistics( 
					  @PathVariable(value="location", required=false) String location, 
					  @RequestParam(value="table", required=true) String table, 
					  @RequestParam(value="start", required=true) String start, 
					  @RequestParam(value="end", required=true) String end, 
					  @RequestParam(value="type", required=false) String type, 
					  @RequestParam Map<String, String> queryMap) {
		
		System.out.println(queryMap);
		ModelAndView mav = new ModelAndView("jsonView");
		List<Map<String, String>> list = restService.statistics(queryMap);
		mav.addObject("list", list);
		return mav;
		
	}
	
	
	
	
	
	@RequestMapping(value="/rest/AllSessions", method=RequestMethod.GET)
	@ResponseBody
	public ModelAndView getAllSession(HttpServletRequest request, HttpSession session) {
		

		
		ModelAndView  mav = new ModelAndView("jsonView");
		
		mav.addObject("list" , rs.getMemberLists());
		return mav;
	}
	
	
	@RequestMapping(value="/rest/{location}/restTypeLister", method=RequestMethod.GET)
	@ResponseBody
	public ModelAndView restTypeLister(HttpServletRequest request,
										@PathVariable(value="location", required=false) String location, 
										@RequestParam Map<String, String> queryMap) {
		
		
		List<Map<String, Object>> list = lectureService.restTypeLister(queryMap);
		ModelAndView mav = new ModelAndView("jsonView");
		mav.addObject("list", list);
		return mav;
	}
	
	
	@RequestMapping(value="/rest/chat", method=RequestMethod.GET)
	@ResponseBody
	public ModelAndView chat(HttpServletRequest request,
			@PathVariable(value="location", required=false) String location, 
			@RequestParam Map<String, String> queryMap) {
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName("common/chat");
		return mav;
	}
	
}
