package com.pure.study.board.model.vo;

import java.sql.Date;

public class Board {
	public Board() {
		super();
		// TODO Auto-generated constructor stub
	}
	private int bNo;
	private int mNo;
	private String title;
	private String content;
	private String upFile;
	private String type;
	private String reply;
	private int fork;
	private Date regDate;
	@Override
	public String toString() {
		return "Board [bNo=" + bNo + ", mNo=" + mNo + ", title=" + title + ", content=" + content + ", upFile=" + upFile
				+ ", type=" + type + ", reply=" + reply + ", fork=" + fork + ", regDate=" + regDate + "]";
	}
	public int getbNo() {
		return bNo;
	}
	public void setbNo(int bNo) {
		this.bNo = bNo;
	}
	public int getmNo() {
		return mNo;
	}
	public void setmNo(int mNo) {
		this.mNo = mNo;
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
	public String getUpFile() {
		return upFile;
	}
	public void setUpFile(String upFile) {
		this.upFile = upFile;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getReply() {
		return reply;
	}
	public void setReply(String reply) {
		this.reply = reply;
	}
	public int getFork() {
		return fork;
	}
	public void setFork(int fork) {
		this.fork = fork;
	}
	public Date getRegDate() {
		return regDate;
	}
	public void setRegDate(Date regDate) {
		this.regDate = regDate;
	}
	public Board(int bNo, int mNo, String title, String content, String upFile, String type, String reply, int fork,
			Date regDate) {
		super();
		this.bNo = bNo;
		this.mNo = mNo;
		this.title = title;
		this.content = content;
		this.upFile = upFile;
		this.type = type;
		this.reply = reply;
		this.fork = fork;
		this.regDate = regDate;
	}
}