package com.pure.study.board.model.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.pure.study.board.model.vo.Attachment;
import com.pure.study.board.model.vo.Board;
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
	public int selectCount(Map<String, String> queryMap) {
		return sqlSession.selectOne("board.boardCount", queryMap); 
	}

	@Override
	public int insertBoard(Board board) {
		return sqlSession.insert("board.insertBoard", board);
	}

	@Override
	public int inserAttachment(Attachment a) {

		return sqlSession.insert("board.insertAttachment", a);
	}

	@Override
	public Map<String, String> selectOne(int bno) {
		return sqlSession.selectOne("board.selectOne", bno);
	}

	@Override
	public int selectOneAttachCount(int boardNo) {
		return sqlSession.selectOne("board.selectOneAttachCount", boardNo);
	}

	@Override
	public List<Map<String, String>> selectOneAttach(int boardNo) {
		return sqlSession.selectList("board.selectOneAttach", boardNo); 
	}

	@Override
	public List<Map<String, String>> selectBoardList(int cPage, int numPerPage, Map<String, String> params) {
		return sqlSession.selectList("board.boardList", params, new RowBounds((cPage-1)*numPerPage, numPerPage));
	}

	@Override
	public int updateBoard(Map<String, String> queryMap) {
		return sqlSession.update("board.boardUpdate", queryMap);
	}


}
