package com.pure.study.board.model.dao;

import java.util.List;
import java.util.Map;

import com.pure.study.board.model.vo.Attachment;
import com.pure.study.board.model.vo.Board;

public interface BoardDAO {

	List<Map<String, String>> selectBoardList(int cPage, int numPerPage);

	int selectCount();

	int insertBoard(Board board);

	int inserAttachment(Attachment a);

	Map<String, String> selectOne(int boardNo);

	int selectOneAttachCount(int boardNo);

	List<Map<String, String>> selectOneAttach(int boardNo);

	List<Map<String, String>> selectBoardList(int cPage, int numPerPage, Map<String, String> params);


}
