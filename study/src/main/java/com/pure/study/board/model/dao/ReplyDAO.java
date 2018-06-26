package com.pure.study.board.model.dao;

import java.util.List;
import java.util.Map;

public interface ReplyDAO {

	int replyCount(Map<String, String> queryMap);
	List<Map<String, String>> replyList(int cPage, int numPerPage, Map<String, String> queryMap);

}
