package com.pure.study.message.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.pure.study.message.model.dao.MessageDAO;

@Service
public class MessageServiceImpl implements MessageService{

	
	@Autowired
	MessageDAO messageDAO;
	
	@Override
	public List<Map<String, String>> messageList() {
		return messageDAO.messageList();
	}

	@Override
	public List<Map<String, String>> messageList(Map<String, String> queryMap) {
		return messageDAO.messageList(queryMap);
	}

	@Override
	public List<Map<String, String>> messageList(int cPage, int numPerPage, Map<String, String> queryMap) {
		return messageDAO.messageList(cPage, numPerPage, queryMap);
	}

	@Override
	public int messageWrite(Map<String, String> queryMap) {
		return messageDAO.messageWrite(queryMap);
	}

	@Override
	public int messageCount(Map<String, String> queryMap) {
		return messageDAO.messageCount(queryMap);
	}

	@Override
	public Map<String, String> messageOne(Map<String, String> queryMap) {
		return messageDAO.messageOne(queryMap);
	}

	@Override
	public int messageReadCheck(Map<String, String> queryMap) {
		return messageDAO.messageReadCheck(queryMap);
	}

}
