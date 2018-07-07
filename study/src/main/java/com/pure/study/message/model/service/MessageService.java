package com.pure.study.message.model.service;

import java.util.List;
import java.util.Map;

public interface MessageService {

	List<Map<String, String>> messageList();

	List<Map<String, String>> messageList(Map<String, String> queryMap);

	List<Map<String, String>> messageList(int cPage, int numPerPage, Map<String, String> queryMap);

	int messageWrite(Map<String, String> queryMap);

	int messageCount(Map<String, String> queryMap);

}
