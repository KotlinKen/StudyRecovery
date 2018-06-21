package com.pure.study.adversting.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;

import com.pure.study.adversting.model.dao.AdverstingDao;
import com.pure.study.adversting.model.vo.Adversting;

@Service
public class AdverstingServiceImpl implements AdverstingService {

	@Autowired
	private AdverstingDao adverstingDao;

	@Override
	public List<Map<String, String>> adverstingListPaging(int cPage, int numPerPage, Map<String, String> queryMap) {
		return adverstingDao.adverstingListPaging(cPage, numPerPage, queryMap);
	}

	@Override
	public int insertAdversting(Adversting adversting) {
		try {
			return adverstingDao.insertAdversting(adversting);
		}catch(DuplicateKeyException  e) {
			return -1;
		}
	}

	@Override
	public int adverstingTotalCount(Map<String, String> queryMap) {
		return adverstingDao.adverstingTotalCount(queryMap);
	}

	@Override
	public Map<String, String> selectAdverstingOne(int ano) {
		return adverstingDao.selectAdverstingOne(ano); 
	}

	@Override
	public int updateAdversting(Adversting adversting) {
		return adverstingDao.updateAdversting(adversting);
	}

	@Override
	public Map<String, String> adverstingCall(String type) {
		return adverstingDao.adverstingCall(type); 
	}

	@Override
	public int adverstingDelete(int ano) {
		return adverstingDao.adverstingDelete(ano);
		
	}
	

}
