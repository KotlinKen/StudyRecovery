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
		return boardDAO.selectBoardList(cPage, numPerPage);
	}

	@Override
	public int selectCount() {
		return boardDAO.selectCount();
	}
	
	@Override
	public int selectCount(Map<String, String> queryMap) {
		return boardDAO.selectCount(queryMap);
	}

	@Override
/*	@Transactional(rollbackFor = {RuntimeException.class})*/
	public int insertBoard(Board board) {
		int result = 0;
		
		try {
			result = boardDAO.insertBoard(board);
		}catch(Exception e ) {
			e.printStackTrace();
			throw e;
		}
		return result;
	}

	@Override
	public Map<String, String> selectOne(int boardNo) {
		
		Map<String, String> one;
		
		try {
			one = boardDAO.selectOne(boardNo);
		}catch(Exception e ) {
			e.printStackTrace();
			throw e;
		}
		
		return one;
		
	}

	@Override
	public List<Map<String, String>> selectBoardList(int cPage, int numPerPage, Map<String, String> params) {
		return boardDAO.selectBoardList(cPage, numPerPage, params);
	}

	@Override
	public int updateBoard(Map<String, String> queryMap) {
		return boardDAO.updateBoard(queryMap);
	}


	
	
}
