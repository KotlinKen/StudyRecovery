package com.pure.study.common.typehandler;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.apache.ibatis.type.JdbcType;
import org.apache.ibatis.type.TypeHandler;

/**
 * 3개의 getter메소드와 1개의 setter메소드를 오버라이딩해야함.
 * 
 * <h3>getter</h3>
<<<<<<< HEAD
 * <p>1. ResultSet에서 컬럼이름 getter
 * <p>2. ResultSet에서 컬럼인덱스 getter
 * <p>3. 프로시져용 CallableStatement용 getter
 * 
 * <h3>setter</h3>
 * <p>1. setter : String[] => String 
 * 
 *
 */
public class StringArrayTypeHandler implements TypeHandler<String[]> {

	@Override
	public String[] getResult(ResultSet rset, String columnName) throws SQLException {
		return rset.getString(columnName).split(",");
	}

	@Override
	public String[] getResult(ResultSet rset, int columnIndex) throws SQLException {
		return rset.getString(columnIndex).split(",");
	}

	@Override
	public String[] getResult(CallableStatement csmt, int columnIndex) throws SQLException {
		return csmt.getString(columnIndex).split(",");
	}

	@Override
	public void setParameter(PreparedStatement pstmt, int columnIndex, String[] param, JdbcType jdbcType) throws SQLException {
		 if (param != null)
	            pstmt.setString(columnIndex, String.join(",", param));
		 else
				pstmt.setString(columnIndex, "");
 
	}

}
