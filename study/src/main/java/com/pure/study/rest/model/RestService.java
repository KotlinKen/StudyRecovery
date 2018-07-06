package com.pure.study.rest.model;

import java.util.List;
import java.util.Map;

public interface RestService {

	List<Map<String, String>> statistics(Map<String, String> queryMap);

}
