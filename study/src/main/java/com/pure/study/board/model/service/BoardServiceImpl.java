package com.pure.study.board.model.service;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.pure.study.board.model.dao.BoardDAO;
import com.pure.study.board.model.vo.Board;
import com.pure.study.board.model.vo.Reply;
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
	public int insertBoard(Board board) {
		int result = 0;
		
	
			result = boardDAO.insertBoard(board);
			
			int bNo = board.getbNo();

		return result;
	}

	@Override
	public List<Map<String, String>> selectOne(int bNo) {
		
		List<Map<String, String>> one;
		int count=0;
		
		try {
			count = boardDAO.selectOneAttachCount(bNo);
			if(count > 0) {
				one = boardDAO.selectOneAttach(bNo);
			}else {
				one = boardDAO.selectOne(bNo);
			}
		}catch(Exception e ) {
			e.printStackTrace();
			throw e;
		}
		
		return one;
		
	}

	@Override
	public Board selectOneBoard(int bNo) {
		// TODO Auto-generated method stub
		return boardDAO.selectOneBoard(bNo);
	}

/*	@Override
	public List<Attachment> selectAttachmentList(int bNo) {
		// TODO Auto-generated method stub
		return boardDAO.selectAttachmentList(bNo);
	}*/

	@Override
	public Board selectOneBoardFix(int bNo) {
		// TODO Auto-generated method stub
		return boardDAO.selectOneBoardFix(bNo);
	}

	@Override
	public int updateBoard(Board board) {
	int result = 0;
		
		
			result = boardDAO.updateBoard(board);
			
			int bNo = board.getbNo();
	
			
		return result;
	}

	@Override
	public int deleteBoard(int bNo) {
int result = 0;
		
		try {
			result = boardDAO.deleteBoard(bNo);
		}catch(Exception e ) {
			e.printStackTrace();
			throw e;
		}
		return result;

	}

	@Override
	public int replyInsert(Reply reply) {
		int result = 0;
		result = boardDAO.replyInsert(reply);
				return result;
	
	}

	@Override
	public List<Reply> replyListService() {
		// TODO Auto-generated method stub
		return null;
	}

	

}

	

