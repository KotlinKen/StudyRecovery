package com.pure.study.adversting.model.service;

import java.util.List;
import java.util.Map;

import com.pure.study.adversting.model.vo.Adversting;

public interface AdverstingService {

	List<Map<String, String>> adverstingListPaging(int cPage, int numPerPage, Map<String, String> queryMap);
	
	int insertAdversting(Adversting adversting);

	int adverstingTotalCount(Map<String, String> queryMap);

	Map<String, String> selectAdverstingOne(int ano);

	int updateAdversting(Adversting adversting);

	Map<String, String> adverstingCall(String type);

	int adverstingDelete(int ano);



}
