package com.pure.study.adminSub.model.dao;

import java.util.List;
import java.util.Map;

public interface AdminSubDAO {

	int instructorSubEnd(Map<String, String> map);

	int deleteSubEnd(String subno);

	int updateSubEnd(Map<String, String> map);

	int instructorKindEnd(Map<String, String> map);

	int deleteKindEnd(String kno);

	int instructorTownEnd(Map<String, String> map);

	int updateTownEnd(Map<String, String> map);

	int deleteTowonEnd(String tno);

	int instructorLocalEnd(String local);

	int deleteLocalEnd(String lno);

}
