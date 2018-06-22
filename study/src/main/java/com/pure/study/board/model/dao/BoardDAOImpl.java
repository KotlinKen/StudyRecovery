package com.pure.study.board.model.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.pure.study.board.model.vo.Board;
import com.pure.study.board.model.vo.Reply;
@Repository
public class BoardDAOImpl implements BoardDAO {

	
	@Autowired
	SqlSessionTemplate sqlSession;
	
	@Override
	public List<Map<String, String>> selectBoardList(int cPage, int numPerPage) {
		
		return sqlSession.selectList("board.boardList", null, new RowBounds((cPage-1)*numPerPage, numPerPage));
	}

	@Override
	public int selectCount() {
		return sqlSession.selectOne("board.boardCount"); 
	}

	@Override
	public int insertBoard(Board board) {
		return sqlSession.insert("board.insertBoard", board);
	}



	@Override
	public List<Map<String, String>> selectOne(int bNo) {
		return sqlSession.selectList("board.selectOne", bNo);
	}

	@Override
	public int selectOneAttachCount(int bNo) {
		return sqlSession.selectOne("board.selectOneAttachCount", bNo);
	}

	@Override
	public List<Map<String, String>> selectOneAttach(int bNo) {
		return sqlSession.selectList("board.selectOneAttach", bNo); 
	}

	@Override
	public Board selectOneBoard(int bNo) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("board.selectOneBoard", bNo);
	}

	/*@Override
	public List<Attachment> selectAttachmentList(int bNo) {
		// TODO Auto-generated method stub
		return sqlSession.selectList("board.selectAttachmentList", bNo);
	}*/

	@Override
	public Board selectOneBoardFix(int bNo) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("board.selectOneBoardFix", bNo);
	}


	@Override
	public int updateBoard(Board board) {
		// TODO Auto-generated method stub
		return sqlSession.update("board.updateBoard", board);
	}

	@Override
	public int deleteBoard(int bNo) {
		// TODO Auto-generated method stub
		return sqlSession.delete("board.deleteBoard", bNo);
	}

	@Override
	public int replyInsert(Reply reply) {
		return sqlSession.insert("reply.replyInsert", reply);
	}





}
