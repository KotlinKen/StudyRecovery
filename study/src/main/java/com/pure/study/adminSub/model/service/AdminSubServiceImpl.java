package com.pure.study.adminSub.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.pure.study.adminSub.model.dao.AdminSubDAO;

@Service
public class AdminSubServiceImpl implements AdminSubService {
	@Autowired
	AdminSubDAO adminSubDAO;
	
	@Override
	public int instructorSubEnd(Map<String, String> map) {
		return adminSubDAO.instructorSubEnd(map);
	}

	@Override
	public int deleteSubEnd(String subno) {
		return adminSubDAO.deleteSubEnd(subno);
	}

	@Override
	public int updateSubEnd(Map<String, String> map) {
		return adminSubDAO.updateSubEnd(map);
	}

	@Override
	public int instructorKindEnd(Map<String, String> map) {
		return adminSubDAO.instructorKindEnd(map);
	}

	@Override
	public int deleteKindEnd(String kno) {
		return adminSubDAO.deleteKindEnd(kno);
	}

	@Override
	public int instructorTownEnd(Map<String, String> map) {
		return adminSubDAO.instructorTownEnd(map);
	}

	@Override
	public int updateTownEnd(Map<String, String> map) {
		return adminSubDAO.updateTownEnd(map);
	}

	@Override
	public int deleteTowonEnd(String tno) {
		return adminSubDAO.deleteTowonEnd(tno);
	}

	@Override
	public int instructorLocalEnd(String local) {
		return adminSubDAO.instructorLocalEnd(local);
	}

	@Override
	public int deleteLocalEnd(String lno) {
		return adminSubDAO.deleteLocalEnd(lno);
	}

}
