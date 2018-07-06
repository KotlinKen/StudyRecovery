package com.pure.study.rest.model;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class RestServiceImpl implements RestService{

	@Autowired
	RestDAO restDAO;
	
	@Override
	public List<Map<String, String>> statistics(Map<String, String> queryMap) {
		return restDAO.satistics(queryMap);
	}
	

}
