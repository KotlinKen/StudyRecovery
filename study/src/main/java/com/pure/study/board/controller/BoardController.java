package com.pure.study.board.controller;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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

import com.pure.study.board.model.excption.BoardException;
import com.pure.study.board.model.service.BoardService;
import com.pure.study.board.model.vo.Attachment;
import com.pure.study.board.model.vo.Board;
import com.pure.study.member.model.dao.MemberDAO;
import com.pure.study.member.model.service.MemberService;
import com.pure.study.member.model.vo.Member;

@Controller
public class BoardController {

	@Autowired
	BoardService boardService;
	
	@Autowired
	MemberService memberService;
	
	
	Logger logger = LoggerFactory.getLogger(getClass());
	
	@RequestMapping(value="/{location}/boardList", method=RequestMethod.GET)
	@ResponseBody
	public ModelAndView selectBoardList(@RequestParam (value="cPage", required=false, defaultValue="1") int cPage, 
										@RequestParam (value="map", required=false) Map<String, String> queryMap,
										@PathVariable(value="location", required=false) String location){
		ModelAndView mav = new ModelAndView();
		
		if(location == null || !(location.equals("admin") || location.equals("board"))){
			mav.addObject("msg", "잘못된 경로로 접근 하셨습니다.");
			mav.addObject("loc", "/");
			mav.setViewName("common/msg");
			return mav;
		}
		
		int numPerPage = 10; 
		
		//1. 현재 페이지 컨텐츠 구하기
		List<Map<String, String>> list = boardService.selectBoardList(cPage, numPerPage, queryMap);
		
		logger.debug("보드 리스트 값을 알려주세요"+list);
		
		//2. 페이지바 처리를 위한 전체 컨텐츠수 구하기
		int totalBoardNumber = boardService.selectCount();
		
		mav.addObject("count", totalBoardNumber);
		mav.addObject("list", list);
		mav.addObject("numPerPage", numPerPage);
		
		return mav;
	};
	

	@RequestMapping("/{location}/boardWrite")
	public ModelAndView boardForm(@PathVariable(value="location", required=false) String location) {
		ModelAndView mav = new ModelAndView();
		if(location == null || !(location.equals("admin") || location.equals("board")) ) {
			mav.addObject("msg", "잘못된 경로로 접근 하셨습니다.");
			mav.addObject("loc", "/");
			mav.setViewName("common/msg");
			return mav;
		}
		return mav;
	}
	
	@RequestMapping("/{location}/boardWriteEnd")
	public ModelAndView insertBoard(Board board, @RequestParam(value="upFile", required=false) MultipartFile[] upFiles, HttpServletRequest request, @PathVariable(value="location", required=false) String location) {
		ModelAndView mav = new ModelAndView();
		List<String> images = new ArrayList<String>();
		
		if(location == null || !(location.equals("admin") || location.equals("board")) ) {
			mav.addObject("msg", "잘못된 경로로 접근 하셨습니다.");
			mav.addObject("loc", "/");
			mav.setViewName("common/msg");
			return mav;
		}
		
		
		
		try {
			//1.파일업로드 처리
			String saveDirectory = request.getSession().getServletContext().getRealPath("/resources/upload/board");
					
			List<Attachment> attachList = new ArrayList<>();
			
			for(MultipartFile f : upFiles) {
				if(!f.isEmpty()) {
					//파일명 재생성
					String originalFileName = f.getOriginalFilename();
					String ext = originalFileName.substring(originalFileName.lastIndexOf(".")+1);
					SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmssSSS");
					int rndNum = (int)(Math.random() * 1000);
					String renamedFileName = sdf.format(new Date(System.currentTimeMillis())) + "_" + rndNum + "." + ext;
					
					try {
						f.transferTo(new File(saveDirectory + "/" + renamedFileName));
					} catch (IllegalStateException e) {
						e.printStackTrace();
					} catch (IOException e) {
						e.printStackTrace();
					}
					//VO객체 담기
					images.add(renamedFileName);
				}
			}
			String image  = String.join(",", images);
			board.setUpfile(image);
			
			
			int result = boardService.insertBoard(board, attachList);
			
			
			//3. view단 분기
			String loc = "/";
			String msg = "";
			
			if(result>0) {
				msg = "게시물 등록 성공";
				//loc = "/board/boardView.do?boardNo="+board.getBno();
				loc = "/";
			}else {
				msg = "게시물 등록 실패";
			}
			
			mav.addObject("msg", msg);
			mav.addObject("loc", loc);
			mav.setViewName("common/msg");
		} catch(Exception e) {
			throw new BoardException("게시물 등록 오류");
		}
		return mav;
	}

	
	
	@RequestMapping(value="/{location}/boardView", method=RequestMethod.GET)
	public ModelAndView selectOne(@RequestParam int bno, @PathVariable(value="location", required=false) String location) {
		ModelAndView mav = new ModelAndView();
		
		if(location == null || !(location.equals("admin") || location.equals("board")) ) {
			mav.addObject("msg", "잘못된 경로로 접근 하셨습니다.");
			mav.addObject("loc", "/");
			mav.setViewName("common/msg");
			return mav;
		}
		
		
		Map<String, String> board = boardService.selectOne(bno);
		mav.addObject("board", board);
		return mav;
	}
	@RequestMapping(value="/{location}/boardModify", method=RequestMethod.GET)
	public ModelAndView boardModify(@RequestParam int bno, @PathVariable(value="location", required=false) String location) {
		ModelAndView mav = new ModelAndView();
		
		if(location == null || !(location.equals("admin") || location.equals("board")) ) {
			mav.addObject("msg", "잘못된 경로로 접근 하셨습니다.");
			mav.addObject("loc", "/");
			mav.setViewName("common/msg");
			return mav;
		}
		
		
		Map<String, String> board = boardService.selectOne(bno);
		mav.addObject("board", board);
		return mav;
	}
	
	
	
	@RequestMapping("/board/boardDownload.do")
	   public void fileDownload(@RequestParam String oName,
	                     @RequestParam String rName,
	                     HttpServletRequest request,
	                     HttpServletResponse response) {
	      logger.debug("파일 다운로드 페이지["+oName+", "+rName+"]");
	      BufferedInputStream bis = null;
	      ServletOutputStream sos = null;
	      String saveDirectory = request.getSession().getServletContext().getRealPath("/resources/upload/board");
	      
	      File savedFile = new File(saveDirectory+"/"+rName);
	      try {
	         bis = new BufferedInputStream(new FileInputStream(savedFile));
	         sos = response.getOutputStream();
	         
	         //응답 세팅
	         response.setContentType("application/octet-stream; charset=utf-8");
	         
	         //한글 파일명 처리
	         String resFilename = "";
	         boolean isMSIE = request.getHeader("user-agent").indexOf("MSIE") != -1 ||
	                     request.getHeader("user-agent").indexOf("Trident") != -1;
	         
	         if(isMSIE) {
	            //ie는 utf-8 인코딩을 명시적으로 해줌.
	            resFilename = URLEncoder.encode(oName, "utf-8");
	            resFilename = resFilename.replaceAll("\\+", "%20");
	         } else {
	            resFilename = new String(oName.getBytes("utf-8"),"ISO-8859-1");
	         }
	         logger.debug("resFilename="+resFilename);
	         response.addHeader("Content-Disposition", "attachment; filename=\""+resFilename+"\"");
	         
	         //쓰기
	         int read = 0;
	         while((read=bis.read())!=-1) {
	            sos.write(read);
	         }
	         
	      }catch(IOException e) {
	         e.printStackTrace();
	      } finally {
	         try {
	            sos.close();
	            bis.close();
	         } catch(IOException e) {
	            e.printStackTrace();
	         }
	      }
	   }
	
	
	@RequestMapping("/{location}/boardReplyFork")
	public ModelAndView boardReplyFork(@PathVariable(value="location", required=false) String location,
									   @RequestParam (value="map", required=false) Map<String, String> queryMap) {
										
		ModelAndView mav = new ModelAndView();
		
		if(location == null || !(location.equals("admin") || location.equals("board")) ) {
			mav.addObject("msg", "잘못된 경로로 접근 하셨습니다.");
			mav.addObject("loc", "/");
			mav.setViewName("common/msg");
			return mav;
		}
		
		Member member = new Member();
		
		//멤버 아이디로 선택후 현재 포인트를 가져온후 더해서 다시 넣는다 
		member.setMno(Integer.parseInt(queryMap.get("mno")));
		
		int result = boardService.updateBoard(queryMap);
		if(result > 0 ) {
			int mresult =memberService.updateMember(member);
		}
		
		
		return mav;
	}	
}
