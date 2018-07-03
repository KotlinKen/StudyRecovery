package com.pure.study.board.model.service;

import java.util.List;
import java.util.Map;


public interface ReplyService {

	int replyCount();
	int replyCount(Map<String, String> queryMap);
	List<Map<String, String>> replyList(int cPage, int numPerPage, Map<String, String> queryMap);
	int replyWrite(Map<String, String> queryMap);
	int replyDelete(Map<String, String> queryMap);
	Map<String, String> replyOne(Map<String, String> queryMap);
	int replyModify(Map<String, String> queryMap);
	List<Map<String, String>> replyDateStatisticsList(Map<String, String> queryMap);


}
