package com.pure.study.member.model.vo;


public class Review {
	private String tmno;
	private String sno;
	private String mno;
	private String point;
	private String content;
	public Review() {
		super();
		// TODO Auto-generated constructor stub
	}
	public Review(String tmno, String sno, String mno, String point, String content) {
		super();
		this.tmno = tmno;
		this.sno = sno;
		this.mno = mno;
		this.point = point;
		this.content = content;
	}
	public String getTmno() {
		return tmno;
	}
	public void setTmno(String tmno) {
		this.tmno = tmno;
	}
	public String getSno() {
		return sno;
	}
	public void setSno(String sno) {
		this.sno = sno;
	}
	public String getMno() {
		return mno;
	}
	public void setMno(String mno) {
		this.mno = mno;
	}
	public String getPoint() {
		return point;
	}
	public void setPoint(String point) {
		this.point = point;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	@Override
	public String toString() {
		return "Review [tmno=" + tmno + ", sno=" + sno + ", mno=" + mno + ", point=" + point + ", content=" + content
				+ "]";
	}
	
	
	
}
