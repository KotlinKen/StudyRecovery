package com.pure.study.rest;

import java.util.List;
import java.util.Map;


public interface RestMemberService {
	List<Map<String, Object>> getMemberLists();
	void setMemberLists(List<Map<String, Object>> memberLists);
	void addMember(Map<String, Object> m);
}
