package com.pure.study.board.model.vo;

import java.sql.Date;

public class Board {
	private int bno;
	private int mno;
	private String title;
	private String content;
	private String upfile;
	private String type;
	private String status;
	private String reply;
	private int fork;
	private Date regdate;

	public Board() {
		super();
	}

	public Board(int bno, int mno, String title, String content, String upfile, String type, String status,
			String reply, int fork, Date regdate) {
		super();
		this.bno = bno;
		this.mno = mno;
		this.title = title;
		this.content = content;
		this.upfile = upfile;
		this.type = type;
		this.status = status;
		this.reply = reply;
		this.fork = fork;
		this.regdate = regdate;
	}

	public int getBno() {
		return bno;
	}

	public void setBno(int bno) {
		this.bno = bno;
	}

	public int getMno() {
		return mno;
	}

	public void setMno(int mno) {
		this.mno = mno;
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

	public String getUpfile() {
		return upfile;
	}

	public void setUpfile(String upfile) {
		this.upfile = upfile;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
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

	public Date getRegdate() {
		return regdate;
	}

	public void setRegdate(Date regdate) {
		this.regdate = regdate;
	}

	@Override
	public String toString() {
		return "Board [bno=" + bno + ", mno=" + mno + ", title=" + title + ", content=" + content + ", upfile=" + upfile
				+ ", type=" + type + ", status=" + status + ", reply=" + reply + ", fork=" + fork + ", regdate="
				+ regdate + "]";
	}

}