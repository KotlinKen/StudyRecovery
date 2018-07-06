package com.pure.study.rest.model;

import java.util.List;
import java.util.Map;

public interface RestDAO {

	List<Map<String, String>> satistics(Map<String, String> queryMap);

}
