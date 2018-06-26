package com.pure.study.study.controller;

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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.pure.study.member.model.vo.Member;
import com.pure.study.study.model.service.StudyService;
import com.pure.study.study.model.vo.Study;

import net.sf.json.JSONException;



@SessionAttributes({"memberLoggedIn"})
@Controller
public class StudyController {
	
	@Autowired
	private StudyService studyService;
	
	Logger logger = LoggerFactory.getLogger(getClass());
	
	private int numPerPage=6;

	
	
	@RequestMapping("/study/studyList.do")
	public ModelAndView studyList() {
		ModelAndView mav = new ModelAndView();
		
		//지역 리스트
		List<Map<String,Object>> localList=studyService.selectLocal();
		mav.addObject("localList",localList);
		
		//카테고리 리스트
		List<Map<String,Object>> kindList=studyService.selectKind();
		mav.addObject("kindList",kindList);
		
		//난이도 리스트
		List<Map<String,Object>> diffList=studyService.selectLv();
		mav.addObject("diffList",diffList);
		
		mav.setViewName("study/study");
		
		return mav;
	}
	
	//아무 조건 없을 때 페이징처리하여 스터디 리스트를 가져옴.
	@RequestMapping("/study/selectStudyList.do")
	public ModelAndView selectStudyList(){
		int cPage=1;
		List<Map<String,Object>> list = studyService.selectStudyList(cPage,numPerPage);
		int total = studyService.studyTotalCount();

		/*resultmap.put("list", list);
		resultmap.put("total",total);
		resultmap.put("numPerPage", numPerPage);
		resultmap.put("cPage", cPage+1);*/

		ModelAndView mav = new ModelAndView("jsonView");
		System.out.println("selectStudyList.do numPerPage="+numPerPage);
		System.out.println("selectStudyList.do cPage="+cPage);
		mav.addObject("list",list);
		mav.addObject("numPerPage",numPerPage);
		mav.addObject("cPage",cPage+1);
		mav.addObject("total",total);
	
		return mav;
	}
	
	@RequestMapping("/study/studyForm.do")
	public void boardForm() {
		
	}
	@RequestMapping("/study/studyFormEnd.do") 
	public ModelAndView insertStudy(Study study, @RequestParam(value="freq") String[] freq, @RequestParam(value="upFile", required=false) MultipartFile[] upFiles,
			HttpServletRequest request, @ModelAttribute("memberLoggedIn") Member m) {
		ModelAndView mav= new ModelAndView();
		String dayname="";
		int i=0;
		for(String day:freq) {
			if(i!=0) dayname+=",";
			dayname+=day+"";
			i++;
		}
		study.setFreq(dayname);
		String imgs="";
		i=0;
		
		logger.debug("upFiles.length="+upFiles.length);

		if(study.getPrice()==null) study.setPrice(0+"원");
		System.out.println("study="+study);
		study.setMno(m.getMno()); 
		System.out.println("study.mno"+study.getMno());
		//스터디 생성하기 
		int result = studyService.insertStudy(study);
		
		//스터디 생성 성공하면, 첨부 사진들 폴더에 저장, db에 저장
		if(result>0) {
			try { //최초 메소드 부른 곳은 controller이기때문에 여기서 에러 처리함. 
				
				//1. 파일 업로드 처리 
				String saveDirectory = request.getSession().getServletContext().getRealPath("/resources/upload/study");
				//List<Attachment> attachList = new ArrayList<>();
				System.out.println("save"+saveDirectory);
				/********* MultipartFile을 이용한 파일 업로드 처리 로직 시작 ********/
				for(MultipartFile f : upFiles) {
					
					if(!f.isEmpty()) {
						//파일명 재생성
						String originalFileName = f.getOriginalFilename();
						String ext = originalFileName.substring(originalFileName.lastIndexOf(".")+1);
						SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmssSSS");
						int rndNum = (int)(Math.random()*1000); //0~9999
						String renamedFileName = sdf.format(new Date(System.currentTimeMillis()))+"_"+rndNum+"."+ext;
						
						try {
							
							//저장하는 걸, study insert 성공하고 해야 하는 것이 아닌가.? 
							f.transferTo(new File(saveDirectory+"/"+renamedFileName)); //실제 저장하는 코드. 
						} catch (IllegalStateException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						} catch (IOException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
						if(i!=0) {
							imgs+=",";
						}
						imgs+=renamedFileName;
						i++;
					}
				}
		
				System.out.println("imgs="+imgs);
			}catch(Exception e) {
				throw new RuntimeException("스터디 등록 오류");
			}
			
		}
		/********* MultipartFile을 이용한 파일 업로드 처리 로직 끝 ********/
		study.setUpfile(imgs);
		
		result = studyService.updateStudyImg(study);
		
		//3. view단 분기
		String loc="/";
		String msg="";
		if(result>0) {
			msg="스터디 등록 성공";
			loc="/study/studyList.do";
		}else
			msg="스터디 등록 실패";
		
		mav.addObject("msg",msg);
		mav.addObject("loc",loc);
		mav.addObject("memberLoggedIn",m);
		mav.setViewName("common/msg");
		
		return mav;
	}
	
	//검색조건으로 첫 페이징 결과를 가져옴. total, list, cPage 넘김
	@RequestMapping("/study/searchStudy.do")
	public ModelAndView selectStudyForSearch(@RequestParam(value="lno") int lno,@RequestParam(value="tno", defaultValue="null") int tno, @RequestParam(value="subno") int subno,
			@RequestParam(value="kno") int kno,@RequestParam(value="dno") int dno,@RequestParam(value="leadername") String leadername
			,@RequestParam(value="cPage", required=false, defaultValue="1") int cPage) {
		
		if(leadername.trim().length()<1) leadername=null;
		
		ModelAndView mav= new ModelAndView("jsonView");
		
		/* 쿼리에 넘길 조건들 Map*/
		Map<String,Object> terms=new HashMap<>();
		terms.put("lno", lno);
		terms.put("tno", tno);
		terms.put("subno", subno);
		terms.put("kno", kno);
		terms.put("dno", dno);
		terms.put("leadername", leadername);
		terms.put("cPage", cPage+1);
		terms.put("numPerPage", numPerPage);
		System.out.println("map="+terms);
		
		
		//검색 조건에 따른 총 스터기 갯수
		int total = studyService.studySearchTotalCount(terms);
		
		
		//페이징 처리해서 가져온 리스트
		List<Map<String,Object>> studyList = studyService.selectStudyForSearch(terms);
		mav.addObject("list",studyList);
		mav.addObject("total",total);
		mav.addObject("cPage",cPage);
		System.out.println("studyList="+studyList);
		
		
		return mav;
	}
	
	//검색결과에서 무한스크롤시 리스트를 페이징 처리해서 더 가져오기.
	@RequestMapping("/study/searchStudyAdd.do")
	public ModelAndView selectSearchStudyAdd(@RequestParam(value="lno") int lno,@RequestParam(value="tno", defaultValue="null") int tno, @RequestParam(value="subno") int subno,
			@RequestParam(value="kno") int kno,@RequestParam(value="dno") int dno,@RequestParam(value="leadername") String leadername
			,@RequestParam(value="cPage", required=false) int cPage){
		
		ModelAndView mav = new ModelAndView("jsonView");
		
		if(leadername.trim().length()<1) leadername=null;
		
		/* 쿼리에 넘길 조건들 Map*/
		Map<String,Object> terms=new HashMap<>();
		terms.put("lno", lno);
		terms.put("tno", tno);
		terms.put("subno", subno);
		terms.put("kno", kno);
		terms.put("dno", dno);
		terms.put("leadername", leadername);
		terms.put("cPage", cPage);
		terms.put("numPerPage", numPerPage);
		
		
		List<Map<String,Object>> list = studyService.selectStudyForSearch(terms);
		mav.addObject("list",list);
		mav.addObject("cPage",cPage+1);
		
		System.out.println("searchListAdd="+list);
		return mav;
		
		
	}
	
	//스터디 리스트 추가로 페이징해서 가져오기 - 처음에 아무 조건 없을 때
	@RequestMapping("/study/studyListAdd.do")
	public ModelAndView selectStudyAdd(@RequestParam(value="cPage",defaultValue="1") int cPage){
		ModelAndView mav = new ModelAndView("jsonView");
		List<Map<String,Object>> studyList= studyService.selectStudyAdd(cPage,numPerPage);
		mav.addObject("list",studyList);
		mav.addObject("cPage",cPage+1);
		
		
		System.out.println("studyList="+studyList);
		return mav;
		
	}
	
	//스터디 상세보기
	@RequestMapping("/study/studyView.do")
	public ModelAndView selectStudyOne(@RequestParam(value="sno", required=true) int sno,HttpSession session) {
		ModelAndView mav = new ModelAndView();
		
		
		
		//스터디 정보 가져오기 +보고 있는 유저의 점수들 가져와야함..
		Map<String,Object> study = studyService.selectStudyOne(sno);
		System.out.println("study="+study);
		
		Member  m= (Member)session.getAttribute("memberLoggedIn");
		int isWish=0;
		if(m!=null) {
			//이미 찜했는지 여부 검사 
			Map<String,Integer> map = new HashMap<>();
			map.put("mno", m.getMno());
			map.put("sno", sno);
			isWish = studyService.isWishStudy(map);
			
		}
		
		
		//팀장에 리뷰 가져오기.
		List<Map<String,Object>> reviewList= studyService.selectReview(sno);
		
		
		mav.addObject("study", study);
		mav.addObject("memberLoggedIn", m);
		mav.addObject("isWish",isWish);	
		mav.addObject("reviewList",reviewList);
		mav.setViewName("study/studyView");
		return mav;
	}
	
	
	
	
	@RequestMapping("/study/applyStudy.do")
	@ResponseBody
	public int insertApplyStudy(@RequestParam(value="sno") int sno,@RequestParam(value="mno") int mno) {
		Map<String,Integer> map = new HashMap<>();
		map.put("sno", sno);
		map.put("mno", mno);
		
		int result =0;
		//먼저 이미 신청했는지 검사한다.
		int cnt = studyService.preinsertApply(map);
		if(cnt == 0 )
	         result = studyService.insertApplyStudy(map);
		return result;
	}
	
	@RequestMapping("/study/wishStudy.do")
	@ResponseBody
	public int insertWishStudy(@RequestParam(value="sno") int sno,@RequestParam(value="mno") int mno) {
		Map<String,Integer> map = new HashMap<>();
		map.put("sno", sno);
		map.put("mno", mno);
		
		int result = studyService.insertWishStudy(map);
		
		return result;
	}
	
	
	@RequestMapping("/study/deletewishStudy.do")
	@ResponseBody
	public int deletewishStudy(@RequestParam(value="sno") int sno,@RequestParam(value="mno") int mno) {
		Map<String,Integer> map = new HashMap<>();
		map.put("sno", sno);
		map.put("mno", mno);
		
		int result = studyService.deletewishStudy(map);
		
		return result;
		
	}
	
	
	
	@RequestMapping("/study/studyUpdate.do")
	public ModelAndView studyUpdate(@RequestParam(value="sno") int sno) {
		ModelAndView mav = new ModelAndView();
		
		Map<String,Object> study = new HashMap<>();
		study=studyService.selectStudyOne(sno);
		System.out.println("@@@@@@@study="+study);
		mav.addObject("study", study);
		mav.setViewName("study/studyUpdate");
		return mav;
	}
	
	@RequestMapping("/study/studyUpdateEnd.do")
	public ModelAndView updateStudy(Study study, @RequestParam(value="freq") String[] freq, @RequestParam(value="upFile", required=false, defaultValue="null") MultipartFile[] upFiles,
			@RequestParam(value="originFile",defaultValue="") String originFile, HttpServletRequest request) {
		
		ModelAndView mav = new ModelAndView();
		
		//월,화,수,목,금,토,일 이렇게 string으로 붙히기 위함.
		String dayname="";
		int i=0;
		for(String day:freq) {
			if(i!=0) dayname+=",";
			dayname+=day+"";
			i++;
		}
		study.setFreq(dayname);
		
		
		String newImgs="";
		i=0;
		
		System.out.println("upFiles.length="+upFiles.length);
		 
		if(study.getPrice()==null) study.setPrice("0");
		System.out.println("study="+study);
		
		
		//스터디 업데이트 (수정) 하기 
		int result = studyService.updateStudy(study);
		
		//새로운 업로드 파일들이 들어와서 스터디 이미지 업데이트할 때, 기존파일이랑 붙여서 업데이트할것인지 여부.
		boolean isImgUpdate=false; 
		for(MultipartFile f:upFiles) {
			if(!f.isEmpty()) { //첨부파일이 하나라도 비어있지 않다면,
				isImgUpdate=true; //새로운 파일을 기존파일과 함께 스트링으로 합쳐줘야함. 
				break;
			}
			
		}
		if(originFile.equals("")&&upFiles.length==0) {
			System.out.println("첨부파일 nulll");
			originFile=null;
		}
		
		//스터디 업데이트(수정) 성공하면, 첨부 사진들 폴더에 저장, db에 저장
		if(result>0) {
			
			//새로 업로드된 파일들도 존재한다. 
			if(isImgUpdate) {
				try { //최초 메소드 부른 곳은 controller이기때문에 여기서 에러 처리함. 
					
					//1. 파일 업로드 처리 
					String saveDirectory = request.getSession().getServletContext().getRealPath("/resources/upload/study");
					
					System.out.println("save"+saveDirectory);
					/********* MultipartFile을 이용한 파일 업로드 처리 로직 시작 ********/
					for(MultipartFile f : upFiles) {
						
						if(!f.isEmpty()) {
							//파일명 재생성
							String originalFileName = f.getOriginalFilename();
							String ext = originalFileName.substring(originalFileName.lastIndexOf(".")+1);
							SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmssSSS");
							int rndNum = (int)(Math.random()*1000); //0~9999
							String renamedFileName = sdf.format(new Date(System.currentTimeMillis()))+"_"+rndNum+"."+ext;
							
							try {
								
								//저장하는 걸, study insert 성공하고 해야 하는 것이 아닌가.? 
								f.transferTo(new File(saveDirectory+"/"+renamedFileName)); //실제 저장하는 코드. 
							} catch (IllegalStateException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							} catch (IOException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
							if(i!=0) {
								newImgs+=",";
							}
							newImgs+=renamedFileName;
							i++;
						}
					}
			
					System.out.println("newImgs="+newImgs);
				}catch(Exception e) {
					throw new RuntimeException("스터디 등록 오류");
				}
				//기존 파일이름과 새로 업로드한 파일이름을 하나로 합침.
				originFile=originFile+","+newImgs;
				
			}//if isImgUpdate 끝
				study.setUpfile(originFile);
				result = studyService.updateStudyImg(study);
			
			
			
			/********* MultipartFile을 이용한 파일 업로드 처리 로직 끝 ********/
			
		}//result>0 if문 끝
		
		//3. view단 분기
		String loc="/";
		String msg="";
		if(result>0) {
			msg="스터디 수정 성공";
			loc="/study/studyView.do?sno="+study.getSno();
		}else
			msg="스터디 수정 실패";
		
		mav.addObject("msg",msg);
		mav.addObject("loc",loc);
		mav.setViewName("common/msg");
		
	
		return mav;
	 }
			
	
	@RequestMapping("/study/deleteStudy.do")
	public ModelAndView deleteStudy(@RequestParam(value="sno") int sno) {
		
		ModelAndView mav = new ModelAndView();
		int result = studyService.deleteStudy(sno);
		
		String msg="";
		String loc="";
		if(result>0) {
			msg="스터디 삭제 성공";
			loc="/study/studyList.do";
		}else {
			msg="스터디 삭제 실패";
			loc="/study/studyView?sno="+sno;
		}
		
		mav.setViewName("common/msg");
		
		
		return mav;
	}
		
	//마감임박순 첫 페이징 처리.
	@RequestMapping("/study/selectByDeadline.do")
	public ModelAndView selectByDeadline() {
		
		ModelAndView mav = new ModelAndView("jsonView");
		
		int cPage=1;
		List<Map<String,Object>> list = studyService.selectByDeadline(cPage,numPerPage);
		int total = studyService.studyDeadlineCount();
	
		System.out.println("selectStudyList.do numPerPage="+numPerPage);
		System.out.println("selectStudyList.do cPage="+cPage);
		mav.addObject("list",list);
		mav.addObject("cPage",cPage+1);
		mav.addObject("total",total);
		
		return mav;
	}
	
	//마감임박순 스크롤 페이징 처리. 
	@RequestMapping("/study/studyDeadlinAdd.do")
	public ModelAndView selectByDeadlineAdd(@RequestParam(value="cPage") int cPage) {
		ModelAndView mav = new ModelAndView("jsonView");
		
		List<Map<String,Object>> list= studyService.selectByDeadline(cPage,numPerPage);
		mav.addObject("list",list);
		mav.addObject("cPage",cPage+1);
		return mav;
	}
	
	//인기스터디순 첫 페이징 처리.
	@RequestMapping("/study/selectByApply.do")
	public ModelAndView selectByApply() {
		ModelAndView mav=  new ModelAndView("jsonView");
		int cPage=1;
		List<Map<String,Object>> list = studyService.selectByApply(cPage,numPerPage);
		int total = studyService.studyByApplyCount();
		mav.addObject("list",list);
		mav.addObject("cPage",cPage+1);
		mav.addObject("total", total);
		
		return mav;
		
	}
	//인기스터디순 스크롤 페이징 처리. 
	@RequestMapping("/study/studyApplyAdd.do")
	public ModelAndView selectByApplyAdd(@RequestParam(value="cPage") int cPage) {
		
		ModelAndView mav = new ModelAndView("jsonView");
		List<Map<String,Object>> list = studyService.selectByApply(cPage,numPerPage);
		mav.addObject("list",list);
		mav.addObject("cPage",cPage+1);
		return mav;
	}
	
	
	
	
	
	/* ---------------------------------------study form에 필요한 select ------------------------------------------------*/
	@RequestMapping("/study/selectSubject.do")
	@ResponseBody
	public List<Map<String,Object>> selectSubject(@RequestParam(value="kno", required=true) int kno){
		
		List<Map<String,Object>> list = studyService.selectSubject(kno);
		return list;
		
	}
	
	@RequestMapping("/study/selectKind.do")
	@ResponseBody
	public List<Map<String,Object>> selectKind(){
		
		List<Map<String,Object>> list = studyService.selectKind();
		
		return list;
		
	}

	@ResponseBody
	@RequestMapping("/study/selectLocal.do")
	public List<Map<String,Object>> selectLocal(){
		
		List<Map<String,Object>> list = studyService.selectLocal();
		System.out.println("@@@@@@@localList="+list);
		
		return list;
	}
	
		
	@RequestMapping("/study/selectTown.do")
	@ResponseBody
	public List<Map<String,Object>> selectTown(@RequestParam(value="lno", required=true) int lno){
		
		List<Map<String,Object>> list = studyService.selectTown(lno);
		
		return list;
	}	

	@RequestMapping("/study/selectLv.do")
	@ResponseBody
	public List<Map<String,Object>> selectLv(){
		
		List<Map<String,Object>> list = studyService.selectLv();
		
		return list;
	}	


}