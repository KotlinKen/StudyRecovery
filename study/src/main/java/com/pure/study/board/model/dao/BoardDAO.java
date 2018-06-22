package com.pure.study.board.model.dao;

import java.util.List;
import java.util.Map;

import com.pure.study.board.model.vo.Board;
import com.pure.study.board.model.vo.Reply;

public interface BoardDAO {

	List<Map<String, String>> selectBoardList(int cPage, int numPerPage);

	int selectCount();

	int insertBoard(Board board);


	List<Map<String, String>> selectOne(int bNo);

	int selectOneAttachCount(int bNo);

	List<Map<String, String>> selectOneAttach(int bNo);

	Board selectOneBoard(int bNo);

/*	List<Attachment> selectAttachmentList(int bNo);
*/
	Board selectOneBoardFix(int bNo);

/*	int updateAttachment(Attachment a);
*/
	int updateBoard(Board board);

	int deleteBoard(int bNo);

	int replyInsert(Reply reply);


	


}
