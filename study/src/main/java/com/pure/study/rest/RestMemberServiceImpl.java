package com.pure.study.rest;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service
public class RestMemberServiceImpl implements RestMemberService {
	
	private static List<Map<String, Object>> memberLists;
	
	public RestMemberServiceImpl() {
		memberLists = new ArrayList<>();
	}

	public List<Map<String, Object>> getMemberLists() {
		return memberLists;
	}

	public void setMemberLists(List<Map<String, Object>> memberLists) {
		RestMemberServiceImpl.memberLists = memberLists;
	}
	
	public void addMember(Map<String, Object> m) {
		memberLists.add(m);
	}
	
}
