package com.pure.study.board.model.vo;

import java.sql.Date;

public class Reply {

	private int rNo;
	private int mNo;
	private int bNo;
	private int parentNo;
	private String title;
	private String content;
	private Date regDate;
	public Reply() {
		super();
		// TODO Auto-generated constructor stub
	}
	public Reply(int rNo, int mNo, int bNo, int parentNo, String title, String content, Date regDate) {
		super();
		this.rNo = rNo;
		this.mNo = mNo;
		this.bNo = bNo;
		this.parentNo = parentNo;
		this.title = title;
		this.content = content;
		this.regDate = regDate;
	}
	public int getrNo() {
		return rNo;
	}
	public void setrNo(int rNo) {
		this.rNo = rNo;
	}
	public int getmNo() {
		return mNo;
	}
	public void setmNo(int mNo) {
		this.mNo = mNo;
	}
	public int getbNo() {
		return bNo;
	}
	public void setbNo(int bNo) {
		this.bNo = bNo;
	}
	public int getParentNo() {
		return parentNo;
	}
	public void setParentNo(int parentNo) {
		this.parentNo = parentNo;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public Date getRegDate() {
		return regDate;
	}
	public void setRegDate(Date regDate) {
		this.regDate = regDate;
	}
	@Override
	public String toString() {
		return "Reply [rNo=" + rNo + ", mNo=" + mNo + ", bNo=" + bNo + ", parentNo=" + parentNo + ", title=" + title
				+ ", content=" + content + ", regDate=" + regDate + "]";
	}
	
}
