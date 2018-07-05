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
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.ArrayUtils;
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
										@RequestParam (required=false) Map<String, String> queryMap,
										@PathVariable(value="location", required=false) String location, HttpServletRequest request){
		ModelAndView mav = new ModelAndView();
		
		if(location == null || !(location.equals("admin") || location.equals("board"))){
			mav.addObject("msg", "잘못된 경로로 접근 하셨습니다.");
			mav.addObject("loc", "/");
			mav.setViewName("common/msg");
			return mav;
		}
		
		

		if(queryMap.get("type") == null) {
			queryMap.put("type", "일반");
		}
		
		Member m = (Member)request.getSession().getAttribute("memberLoggedIn");
		if(queryMap != null && queryMap.get("type") !=null) {
			if(queryMap.get("type").equals("one")){
				if(m!=null) {
					System.out.println(m.getMno());
					queryMap.put("mno", String.valueOf(m.getMno()));
				}else {
					queryMap.put("mno", "0");
				}
			}
		}
		logger.info("queryMap"+queryMap);
		int numPerPage = 10; 
		


		
		//1. 현재 페이지 컨텐츠 구하기
		List<Map<String, String>> list = boardService.selectBoardList(cPage, numPerPage, queryMap);
		logger.debug("보드 리스트 값을 알려주세요"+list);

		
		//2. 페이지바 처리를 위한 전체 컨텐츠수 구하기
		int totalBoardNumber = boardService.selectCount(queryMap);
		
		mav.addObject("count", totalBoardNumber);
		mav.addObject("list", list);
		mav.addObject("cPage", cPage);
		mav.addObject("numPerPage", numPerPage);
		mav.addObject("queryMap", queryMap);
		
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
			
			
			int result = boardService.insertBoard(board);
			
			
			//3. view단 분기
			String loc = "/";
			String msg = "";
			
			if(result>0) {
				msg = "게시물 등록 성공";
				loc = "/"+location+"/boardList";
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
	public ModelAndView selectOne(@RequestParam int bno, @PathVariable(value="location", required=false) String location, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		
		if(location == null || !(location.equals("admin") || location.equals("board")) ) {
			mav.addObject("msg", "잘못된 경로로 접근 하셨습니다.");
			mav.addObject("loc", "/");
			mav.setViewName("common/msg");
			return mav;
		}
		
		
		Map<String, String> board = boardService.selectOne(bno);
		mav.addObject("board", board);
		logger.info(board.toString());
		return mav;
	}
	@RequestMapping(value="/{location}/boardModify", method=RequestMethod.GET)
	public ModelAndView boardModify(@RequestParam(value="bno", required=true) int bno, 
									@RequestParam Map<String, String> map, 
									@PathVariable(value="location", required=false) String location,
							   	    HttpServletRequest request,
							   	    Board board, @RequestParam(value="upFile", required=false) MultipartFile[] upFiles){	
		
		
		
		ModelAndView mav = new ModelAndView();
		List<String> images = new ArrayList<String>();
		
		
		if(location == null || !(location.equals("admin") || location.equals("board")) ) {
			mav.addObject("msg", "잘못된 경로로 접근 하셨습니다.");
			mav.addObject("loc", "/");
			mav.setViewName("common/msg");
			return mav;
		}
		
		Map<String, String> oldFeed = boardService.selectOne(bno);
		
		HttpSession session = request.getSession();
		Member m = (Member)session.getAttribute("memberLoggedIn");
		String boardWriter = String.valueOf(oldFeed.get("MNO"));
		
		if(m == null) {
			mav.addObject("msg", "로그인 후 이용해주세요");
			mav.addObject("loc", "/");
			mav.setViewName("common/msg");
			return mav;
		}else {
			if(!(String.valueOf(m.getMno()).equals(boardWriter)) && (String.valueOf(m.getMno()).equals("manager"))) {
				System.out.println("내번호"+ m.getMno() + "보드 글 작성자 "+boardWriter );
				mav.addObject("msg", "본인의 글만 수정이 가능합니다.");
				mav.addObject("loc", "/board/boardView?bno="+bno);
				mav.setViewName("common/msg");
				return mav;
			}
		}
		
		mav.addObject("board", oldFeed);
		return mav;
	}


	@RequestMapping(value="/{location}/boardModifyEnd", method=RequestMethod.POST)
	public ModelAndView boardModifyEnd(@RequestParam(value="bno", required=false) int bno,
									   @RequestParam Map<String, String> map, 
									   @PathVariable(value="location", required=false) String location,
								   	   HttpServletRequest request, Board board,  
								   	   @RequestParam(value="upFile", required=false) MultipartFile[] upFiles){
		
		List<String> images = new ArrayList<String>();
		ModelAndView mav = new ModelAndView();
		
		System.out.println("test"+ map.get("oldFileList"));
 		images.add(map.get("oldFileList")); //기존 파일 추가
		
		if(location == null || !(location.equals("admin") || location.equals("board"))) {
			mav.addObject("msg", "잘못된 경로로 접근 하셨습니다.");
			mav.addObject("loc", "/");
			mav.setViewName("common/msg");
			return mav;
		}

		
		try {
			//1.파일업로드 처리
			String saveDirectory = request.getSession().getServletContext().getRealPath("/resources/upload/board");
					
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
			
			map.put("upfile", String.join(",", images));
			int result = boardService.updateBoard(map);
			
			//3. view단 분기
			String loc = "/";
			String msg = "";
			System.out.println(location);
			if(result>0) {
				msg = "게시물 수정 성공 했습니다.";
				loc = "/"+location+"/boardView?bno="+bno;

			}else {
				msg = "게시물 수정실패 실패";
				loc = "/";
			}
			
			mav.addObject("msg", msg);
			mav.addObject("loc", loc);
			mav.setViewName("common/msg");
		} catch(Exception e) {
			throw new BoardException("게시물 DB 등록 오류");
		}
	return mav; 
	}
	
	
	@RequestMapping("/board/boardDownload")
	   public void fileDownload(
	                     @RequestParam String name,
	                     HttpServletRequest request,
	                     HttpServletResponse response) {
	      logger.debug("파일 다운로드 페이지["+name+"]");
	      BufferedInputStream bis = null;
	      ServletOutputStream sos = null;
	      String saveDirectory = request.getSession().getServletContext().getRealPath("/resources/upload/board");
	      
	      File savedFile = new File(saveDirectory+"/"+name);
	      	
	      try {
 
	         bis = new BufferedInputStream(new FileInputStream(savedFile));
	         sos = response.getOutputStream();
	         System.out.println(sos.toString());
	         
	         //응답 세팅
	         response.setContentType("application/octet-stream; charset=utf-8");
	         

	         response.addHeader("Content-Disposition", "attachment; filename=\""+name+"\"");
	         
	         //쓰기
	         int read = 0;
	         while((read=bis.read())!=-1) {
	            sos.write(read);
	         }
	         
	      }catch(IOException e) {
	    	  throw new BoardException("지정된 파일이 삭제되었거나 없습니다.");
	      } finally {
	         try {
	            sos.close();
	            bis.close();
	         } catch(IOException e) {

	        	 throw new BoardException("게시물 호출 에러");
	         }
	      }
	   }
	
	
	@RequestMapping("/{location}/boardReplyFork")
	@ResponseBody
	public ModelAndView boardReplyFork(@PathVariable(value="location", required=false) String location,
									   @RequestParam(value="bno", required=true, defaultValue="") String bno,
									   @RequestParam(value="rno", required=true, defaultValue="") String rno,
									   @RequestParam(value="mno", required=true, defaultValue="") String mno,
									   @RequestParam(required=false) Map<String, String> queryMapString,
									   @RequestParam(required=false) Map<String, Object> queryMapObject) {
										
		ModelAndView mav = new ModelAndView("jsonView");
		
		if(location == null || !(location.equals("admin") || location.equals("board")) ) {
			mav.addObject("msg", "잘못된 경로로 접근 하셨습니다.");
			mav.addObject("loc", "/");
			mav.setViewName("common/msg");
			return mav;
		}
		System.out.println(bno);
		System.out.println(rno);
		System.out.println(mno);
		System.out.println(queryMapString);
		System.out.println(queryMapObject);
		
		int mNumber = 0; 
		try {
			mNumber = Integer.parseInt(mno);
		}catch(NumberFormatException e){
			e.printStackTrace();
			mav.addObject("msg", "멤버넘버 숫자 에러가 났습니다.");
			mav.addObject("loc", "/");
			mav.setViewName("common/msg");
			return mav;
		}
		
		Member member = memberService.selectOneMemberMno(mNumber);
		System.out.println(mNumber);
		
		if(member != null) {
			member.setPoint(1000);
			queryMapObject.put("mno", mno);
			queryMapObject.put("npoint", 1000);
			int result = memberService.updateNpoint(queryMapObject);
			System.out.println(result);
			System.out.println("여기까지");
			
			if(result > 0 ) {
				System.out.println(result+"결과 결과 결과");
				queryMapString.put("bno", bno);
				queryMapString.put("mno", mno);
				queryMapString.put("rno", rno);
				queryMapString.put("fork", rno);
				int updateResult = boardService.updateBoard(queryMapString);
				queryMapString.put("result", String.valueOf(updateResult));
				
				mav.addObject("queryMapString",queryMapString);
				
			}else {
				queryMapString.put("result", result+"멤버 점수 업데이트에 실패하였습니다.");
				mav.addObject("loc", "/");
				mav.setViewName("common/msg");
			}
		}
 
		return mav;
	}
	@RequestMapping("/{location}/uploadImage")
	@ResponseBody
	public ModelAndView sendImage(@PathVariable(value="location", required=false) String location,
										@RequestParam("file") MultipartFile upFile,
										HttpServletRequest request) {
		
		ModelAndView mav = new ModelAndView("jsonView");
		
		if(location == null || !(location.equals("admin") || location.equals("board")) ) {
			mav.addObject("msg", "잘못된 경로로 접근 하셨습니다.");
			mav.addObject("loc", "/");
			mav.setViewName("common/msg");
			return mav;
		}
		
		
		
		String renamedFileName="";
		String saveDirectory="";
		
		try { 
			//1. 파일 업로드 처리 
			saveDirectory = request.getSession().getServletContext().getRealPath("/resources/upload/"+location);		
			if(!upFile.isEmpty()) {
				//파일명 재생성
				String originalFileName = upFile.getOriginalFilename();
				String ext = originalFileName.substring(originalFileName.lastIndexOf(".")+1);
				SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmssSSS");
				int rndNum = (int)(Math.random()*1000); //0~9999
				renamedFileName = sdf.format(new Date(System.currentTimeMillis()))+"_"+rndNum+"."+ext;
				
				try {
					upFile.transferTo(new File(saveDirectory+"/"+renamedFileName)); //실제 저장하는 코드. 
				} catch (IllegalStateException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}
				
			}
		
		}catch(Exception e) {
			throw new RuntimeException("이미지 등록 오류");
		}
		mav.addObject("imageUrl", renamedFileName);
		return mav;
	}
	
	
}
