package com.pure.study.board.model.service;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.pure.study.board.model.dao.BoardDAO;
import com.pure.study.board.model.vo.Attachment;
import com.pure.study.board.model.vo.Board;
@Service
public class BoardServiceImpl implements BoardService {
	Logger logger = LoggerFactory.getLogger(getClass());
	
	@Autowired
	private BoardDAO boardDAO;

	@Override
	public List<Map<String, String>> selectBoardList(int cPage, int numPerPage) {
		// TODO Auto-generated method stub
		return boardDAO.selectBoardList(cPage, numPerPage);
	}

	@Override
	public int selectCount() {
		return boardDAO.selectCount();
	}

	@Override
/*	@Transactional(rollbackFor = {RuntimeException.class})*/
	public int insertBoard(Board board, List<Attachment> attachList) {
		int result = 0;
		
		try {
			result = boardDAO.insertBoard(board);
			
			int boardNo = board.getBoardNo();
	
			logger.debug("boardNo@service="+boardNo);
			if(attachList.size() > 0 ) {
				for(Attachment a : attachList) {
					a.setBoardNo(boardNo);
					result = boardDAO.inserAttachment(a);
				}
			}else {
				
			}
		}catch(Exception e ) {
			e.printStackTrace();
			throw e;
		}
		return result;
	}

	@Override
	public List<Map<String, String>> selectOne(int boardNo) {
		
		List<Map<String, String>> one;
		int count=0;
		
		try {
			count = boardDAO.selectOneAttachCount(boardNo);
			if(count > 0) {
				one = boardDAO.selectOneAttach(boardNo);
			}else {
				one = boardDAO.selectOne(boardNo);
			}
		}catch(Exception e ) {
			e.printStackTrace();
			throw e;
		}
		
		return one;
		
	}

	
	
}
