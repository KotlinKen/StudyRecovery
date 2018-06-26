package com.pure.study.board.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.pure.study.board.model.dao.ReplyDAO;

@Service
public class ReplyServiceImpl implements ReplyService {

	@Autowired
	ReplyDAO replyDao;
	
	@Override
	public int replyCount(Map<String, String> queryMap) {
		return replyDao.replyCount(queryMap);
	}

	@Override
	public List<Map<String, String>> replyList(int cPage, int numPerPage, Map<String, String> queryMap) {
		return replyDao.replyList(cPage, numPerPage, queryMap);
	}
	

}
