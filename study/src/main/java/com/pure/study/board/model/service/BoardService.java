package com.pure.study.board.model.service;

import java.util.List;
import java.util.Map;

import com.pure.study.board.model.vo.Attachment;
import com.pure.study.board.model.vo.Board;


public interface BoardService {

	List<Map<String, String>> selectBoardList(int cPage, int numPerPage);
	int selectCount();
	int selectCount(Map<String, String> queryMap);
	int insertBoard(Board board);
	Map<String, String> selectOne(int boardNo);
	List<Map<String, String>> selectBoardList(int cPage, int numPerPage, Map<String, String> params);
	int updateBoard(Map<String, String> queryMap);
	
}
