package com.pure.study.adversting.controller;

import java.io.File;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.pure.study.adversting.model.service.AdverstingService;
import com.pure.study.adversting.model.vo.Adversting;
@SessionAttributes({"popUpSession"})
@Controller
public class AdverstingController {
	private Logger logger = LoggerFactory.getLogger(getClass());
	
	
	@Autowired
	private AdverstingService adverstingService;
	
	
	
	@RequestMapping("/admin/adverstingUpload")
	@ResponseBody
	public ModelAndView adverstingUpload(@RequestParam(value="file", required=false) MultipartFile[] upFiles) {
		logger.info("테스트"+upFiles);
		ModelAndView mav = new ModelAndView();
		return mav; 
	}
	
	
	//목록보기
	@RequestMapping("/{location}/adverstingList")
	@ResponseBody
	public ModelAndView adverstingListPaging(@RequestParam(value="cPage", required=false, defaultValue="1") int cPage, 
											 @RequestParam Map<String, String> queryMap,
											 @PathVariable(value="location", required=false) String location, 
											 HttpServletRequest request) {
		
		ModelAndView mav = new ModelAndView();
		
		if(location == null || !(location.equals("admin") || location.equals("adv")) ) {
			mav.addObject("msg", "잘못된 경로로 접근 하셨습니다.");
			mav.addObject("loc", "/");
			mav.setViewName("common/msg");
			return mav;
		}

		int numPerPage = 10; 
		List<Map<String, String>>  list = adverstingService.adverstingListPaging(cPage, numPerPage, queryMap);
		logger.debug("adversting list"+list);
		
		int totalBoardNumber = adverstingService.adverstingTotalCount(queryMap);
		
		mav.addObject("count", totalBoardNumber);
		mav.addObject("list", list);
		mav.addObject("numPerPage", numPerPage);
		return mav;
	}
	
	
	//등록하기
	@RequestMapping(value="/{location}/adverstingWrite", method=RequestMethod.GET)
	@ResponseBody
	public ModelAndView adverstingWrite(@PathVariable(value="location", required=false) String location){
		ModelAndView mav = new ModelAndView();
		if(location == null || !(location.equals("admin") || location.equals("adv")) ) {
			mav.addObject("msg", "잘못된 경로로 접근 하셨습니다.");
			mav.addObject("loc", "/");
			mav.setViewName("common/msg");
			return mav;
		}
		return mav;
	}
	//등록하기
	@RequestMapping(value="/{location}/adverstingWriteEnd", method=RequestMethod.POST)
	@ResponseBody
	public ModelAndView adverstingWriteEnd(Adversting adversting, 
										   HttpServletRequest request,
										   @PathVariable(value="location", required=false) String location, 
 	 		    						   @RequestParam(value="img", required=false) MultipartFile[] upFiles){ 
																  
		ModelAndView mav = new ModelAndView();
		if(location == null || !(location.equals("admin") || location.equals("adv")) ) {
			mav.addObject("msg", "잘못된 경로로 접근 하셨습니다.");
			mav.addObject("loc", "/");
			mav.setViewName("common/msg");
			return mav;
		}
		
		if(adversting.getStatus().equals("on")) {
			adversting.setStatus("Y");
		}else {
			adversting.setStatus("N");
		}
		try {
			String saveDirectory = request.getSession().getServletContext().getRealPath("/resources/upload/adversting");
			int cnt = 0;
				for(MultipartFile f : upFiles) {
					cnt++;
					logger.info("cnt"+saveDirectory);
					logger.debug("cnt"+cnt);
					if(!f.isEmpty()) {
	
						//파일명 재생성
						String originalFileName = f.getOriginalFilename();
						String ext = originalFileName.substring(originalFileName.lastIndexOf(".")+1);
						SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmssSSS");
						int rndNum = (int)(Math.random() * 1000);
						String renamedFileName = sdf.format(new Date(System.currentTimeMillis())) + "_" + rndNum + "." + ext;
						logger.info("renamedFileName"+renamedFileName);
						try {
							f.transferTo(new File(saveDirectory + "/" + renamedFileName));
						} catch (IllegalStateException e) {
							e.printStackTrace();
						} catch (IOException e) {
							e.printStackTrace();
						}
						adversting.setAdvImg(renamedFileName);
					}
				}
			
			int result = adverstingService.insertAdversting(adversting);
			//3. view단 분기
			String loc = "/";
			String msg = "";
			
			if(result>0) {
				msg = "게시물 등록 성공 했습니다.";
				loc = "/"+location+"/adverstingView?ano="+adversting.getAno();
			}else {
				msg = "게시물 등록 실패 했습니다.";
				loc = "/"+location+"/adverstingWrite";
			}
			
			mav.addObject("msg", msg);
			mav.addObject("loc", loc);
			mav.setViewName("common/msg");
		} catch(Exception e) {
			e.printStackTrace();
/*			throw new BoardException("게시물 등록 오류");*/
		}
		return mav; 
	}
	
	//수정하기
	@RequestMapping("/{location}/adverstingUpdate")
	public ModelAndView adverstingReWrite(Adversting adversting, @RequestParam(value="img", required=false) MultipartFile[] upFiles, HttpServletRequest request, @PathVariable String location) {
		ModelAndView mav = new ModelAndView();
		
		if(location == null || !(location.equals("admin") || location.equals("adv")) ) {
			mav.addObject("msg", "잘못된 경로로 접근 하셨습니다.");
			mav.addObject("loc", "/");
			mav.setViewName("common/msg");
			return mav;
		}
		
		if(adversting.getStatus() != null) {
			adversting.setStatus("Y");
		}else {
			adversting.setStatus("N");
		}
		
		Map<String, String> map = adverstingService.selectAdverstingOne(adversting.getAno());
		try {
			if((!adversting.getAdvImg().equals(map.get("ADVIMG")) || adversting.getAdvImg() != null)) {
				String saveDirectory = request.getSession().getServletContext().getRealPath("/resources/upload/adversting");
				int cnt = 0; 
				for(MultipartFile f : upFiles) {
					cnt++;
					logger.info("cnt"+saveDirectory);
					logger.debug("cnt"+cnt);
					if(!f.isEmpty()) {
						//파일명 재생성
						String originalFileName = f.getOriginalFilename();
						String ext = originalFileName.substring(originalFileName.lastIndexOf(".")+1);
						SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmssSSS");
						int rndNum = (int)(Math.random() * 1000);
						String renamedFileName = sdf.format(new Date(System.currentTimeMillis())) + "_" + rndNum + "." + ext;
						logger.info("renamedFileName"+renamedFileName);
						try {
							f.transferTo(new File(saveDirectory + "/" + renamedFileName));
						} catch (IllegalStateException e) {
							e.printStackTrace();
						} catch (IOException e) {
							e.printStackTrace();
						}
						//VO객체 담기
						adversting.setAdvImg(renamedFileName);
					}
				}
			}else {
				map.get("ADVIMG");
				adversting.setAdvImg(map.get("ADVIMG"));
			}
			int result = adverstingService.updateAdversting(adversting);
			//3. view단 분기
			String loc = "/";
			String msg = "";
			
			if(result>0) {
				msg = "게시물 수정 성공";
				loc = "/"+location+"/adverstingList";
			}else {
				msg = "게시물 수정 실패";
				loc = "/"+location+"/adverstingUpdate?ano="+adversting.getAno();
			}
			
			mav.addObject("msg", msg);
			mav.addObject("loc", loc);
			mav.setViewName("common/msg");
		} catch(Exception e) {
/*			throw new BoardException("게시물 등록 오류");*/
		}
		
		return mav; 
	}	

	
	
	@RequestMapping(value="/{location}/adverstingView", method=RequestMethod.GET)
	public ModelAndView adverstingView(String ano, @PathVariable String location ) {
		
		ModelAndView mav = new ModelAndView();
		
		if(location == null || !(location.equals("admin") || location.equals("adv")) ) {
			mav.addObject("msg", "잘못된 경로로 접근 하셨습니다.");
			mav.addObject("loc", "/");
			mav.setViewName("common/msg");
			return mav;
		}
		
		
		Map<String, String> adversting = adverstingService.selectAdverstingOne(Integer.parseInt(ano));
		
		mav.addObject("adversting", adversting);
		return mav; 
	}
	
	
	
	@RequestMapping("/admin/adminAdverstingView")
	public ModelAndView adverstingViewForAdmin(String ano) {
		
		ModelAndView mav = new ModelAndView();
		
		Map<String, String> adversting = adverstingService.selectAdverstingOne(Integer.parseInt(ano));
		mav.addObject("adversting", adversting);
		return mav; 
	}
	
	
	
	
	

	
	@RequestMapping("/adv/adverstingDelete")
	public ModelAndView adverstingDelete(int ano) {
		ModelAndView mav = new ModelAndView();
		
		int result = adverstingService.adverstingDelete(ano);
		//3. view단 분기
		String loc = "/";
		String msg = "";
		
		if(result>0) {
			msg = "광고 삭제 성공";
			loc = "/adv/adverstingListPaging";
		}else {
			msg = "광고 삭제 실패";
			loc = "/adv/adverstingView?ano="+ano;
		}
		 
		mav.addObject("msg", msg);
		mav.addObject("loc", loc);
		mav.setViewName("common/msg"); 
		
		return mav;
	}
	
 
	
	@RequestMapping("/adv/call")
	@ResponseBody
	public Map<String, Object> call(String type, Model model)  throws JsonProcessingException {
      Map<String, Object> map = new HashMap<>();
		Map<String, String> adv = adverstingService.adverstingCall(type);
		map.put("adv", adv);
		return map;
	}
	
	@RequestMapping("/adv/popupClose")
	@ResponseBody
	public void popupClose( HttpServletResponse response)  throws JsonProcessingException {
		Cookie popupCookie = new Cookie("popupValue", "Y"); // 쿠키 생성
		popupCookie.setMaxAge(50*60); // 기간을 하루로 지정
		popupCookie.setPath("/");
		response.addCookie(popupCookie);
		
	}
}
