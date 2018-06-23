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
	
	
	
	@RequestMapping(value="/adv/", method=RequestMethod.GET)
	@ResponseBody
	public Adversting selectAdverstingRest(@RequestParam(value="filter", required=false) String filter) {
		
		Adversting adversting = new Adversting();
		
		adversting.setAdvImg("kkk22222");
		
		return adversting;
	}
	
	@RequestMapping(value="/adv/{advIdx}", method=RequestMethod.GET)
	@ResponseBody
	public Adversting selectTestRest(@PathVariable int advIdx, @RequestParam(value="filter", required=false) String filter) {
		
		Adversting adversting = new Adversting();
		
		adversting.setAdvImg("kkk");
		adversting.setAno(advIdx);
		return adversting;
	}
	
	@RequestMapping(value="/adv", method=RequestMethod.POST)
	@ResponseBody
	public boolean insertTestRest(@RequestParam Adversting adversting) {
		return true;
	}
	
	@RequestMapping(value="/advs/{advIdx}", method= {RequestMethod.PUT, RequestMethod.POST})
	@ResponseBody
	public boolean updateTestRest(@PathVariable int advIdx, @RequestParam Adversting adversting) {
		
		
		return false;
	}
	
	@RequestMapping(value="/advs/{advIdx}", method=RequestMethod.DELETE)
	@ResponseBody
	public boolean deleteTestRest(@PathVariable int advIdx) {
		return true;
	}
	
	
	@RequestMapping("/adv/adverstingWrite")
	public void adverstingWrite() {
		logger.info("test");
		
	}
	
	@RequestMapping("/adv/adverstingWriteEnd")
	public ModelAndView adverstingWriteEnd(Adversting adversting, @RequestParam(value="img", required=false) MultipartFile[] upFiles, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		
		adversting.setAno(3);
		
		if(adversting.getStatus().equals("on")) {
			adversting.setStatus("Y");
		}else {
			adversting.setStatus("N");
		}
		
		
		try {
			//1.파일업로드 처리
			String saveDirectory = request.getSession().getServletContext().getRealPath("/resources/upload/adversting");
					
			/************** MultipartFile을 이용한 파일 업로드 처리 로직 시작  ********************************************************/
			
			//
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
			
			int result = adverstingService.insertAdversting(adversting);
			
			if(result == -1) {
				mav.addObject("msg", "에러테스트");
				mav.addObject("loc", "/adv/adverstingWrite");
				mav.setViewName("common/msg");
				return mav;
			}
			//3. view단 분기
			String loc = "/";
			String msg = "";
			
			if(result>0) {
				msg = "게시물 등록 성공";
				loc = "/adv/adverstingView?ano="+adversting.getAno();
			}else {
				msg = "게시물 등록 실패";
				loc = "/adv/adverstingWrite";
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
	
	@RequestMapping("/adv/selectAdversting")
	public String  selectAdversting(Model model) {
		
		logger.debug("adversting list");
		return "selectAdversting";
		
	}
	
	
	
	@RequestMapping("/adv/adverstingListPaging")
	public ModelAndView adverstingListPaging(@RequestParam(value="cPage", required=false, defaultValue="1") int cPage, 
											@RequestParam Map<String, String> queryMap
											  ,HttpServletRequest request) {
		
		logger.debug("================="+request.getParameterMap().get("type"));
		logger.debug("================="+request.getParameter("type"));
		logger.debug("=================queryMap"+ queryMap.get("type"));
		logger.debug("=================queryMap"+ queryMap.toString());
		ModelAndView mav = new ModelAndView();
		int numPerPage = 10; 
		List<Map<String, String>>  list = adverstingService.adverstingListPaging(cPage, numPerPage, queryMap);
		logger.debug("adversting list"+list);
		
		int totalBoardNumber = adverstingService.adverstingTotalCount(queryMap);
		
		mav.addObject("count", totalBoardNumber);
		mav.addObject("list", list);
		mav.addObject("numPerPage", numPerPage);
		return mav;
	}
	
	
	@RequestMapping("/adv/adverstingView")
	public ModelAndView adverstingView(String ano) {
		
		ModelAndView mav = new ModelAndView();
		
		Map<String, String> adversting = adverstingService.selectAdverstingOne(Integer.parseInt(ano));
		
		mav.addObject("adversting", adversting);
		return mav; 
	}
	
	
	
	
	@RequestMapping("/adv/adverstingReWrite")
	public ModelAndView adverstingReWrite(Adversting adversting, @RequestParam(value="img", required=false) MultipartFile[] upFiles, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		
		if(adversting.getStatus() != null) {
			adversting.setStatus("Y");
		}else {
			adversting.setStatus("N");
		}
		
		Map<String, String> map = adverstingService.selectAdverstingOne(adversting.getAno());
		
		logger.debug("test======================================================================================"+adversting);
		logger.debug("test======================================================================================"+map);
		
		try {
			if((!adversting.getAdvImg().equals(map.get("ADVIMG")) || adversting.getAdvImg() != null)) {
			//1.파일업로드 처리
				String saveDirectory = request.getSession().getServletContext().getRealPath("/resources/upload/adversting");
					
			/************** MultipartFile을 이용한 파일 업로드 처리 로직 시작  ********************************************************/
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
				loc = "/adv/adverstingView?ano="+adversting.getAno();
			}else {
				msg = "게시물 수정 실패";
				loc = "/adv/adverstingWrite";
			}
			
			mav.addObject("msg", msg);
			mav.addObject("loc", loc);
			mav.setViewName("common/msg");
		} catch(Exception e) {
/*			throw new BoardException("게시물 등록 오류");*/
		}
		
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
