package com.pure.study.board.model.vo;

import java.sql.Date;

public class Reply {
	private int rno;
	private int mno;
	private int bno;
	private int parentno;
	private String title;
	private String content;
	private String status;
	private Date regdate;
	public Reply() {
		super();
	}
	public Reply(int rno, int mno, int bno, int parentno, String title, String content, String status, Date regdate) {
		super();
		this.rno = rno;
		this.mno = mno;
		this.bno = bno;
		this.parentno = parentno;
		this.title = title;
		this.content = content;
		this.status = status;
		this.regdate = regdate;
	}
	public int getRno() {
		return rno;
	}
	public void setRno(int rno) {
		this.rno = rno;
	}
	public int getMno() {
		return mno;
	}
	public void setMno(int mno) {
		this.mno = mno;
	}
	public int getBno() {
		return bno;
	}
	public void setBno(int bno) {
		this.bno = bno;
	}
	public int getParentno() {
		return parentno;
	}
	public void setParentno(int parentno) {
		this.parentno = parentno;
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
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public Date getRegdate() {
		return regdate;
	}
	public void setRegdate(Date regdate) {
		this.regdate = regdate;
	}
	@Override
	public String toString() {
		return "Reply [rno=" + rno + ", mno=" + mno + ", bno=" + bno + ", parentno=" + parentno + ", title=" + title
				+ ", content=" + content + ", status=" + status + ", regdate=" + regdate + "]";
	}
	
}