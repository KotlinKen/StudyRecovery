package com.pure.study.study.model.vo;

import java.sql.Date;

public class Study {
	private int sno;
	private int mno;
	private int subno;
	private int tno;
	private int dno;
	private String title;
	private String freq;
	private String content;
	private String price;
	private String upfile;
	private String recruit;
	private String status;
	private String time;
	private String type;
	private Date ldate;
	private Date sdate;
	private Date edate;
	private Date regDate;
	private String etc;
	
	public Study() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public Study(int sno, int mno, int subno, int tno, int dno, String title, String freq, String content, String price,
			String upfile, String recruit, String status, String time, String type, Date ldate, Date sdate, Date edate,
			Date regDate, String etc) {
		super();
		this.sno = sno;
		this.mno = mno;
		this.subno = subno;
		this.tno = tno;
		this.dno = dno;
		this.title = title;
		this.freq = freq;
		this.content = content;
		this.price = price;
		this.upfile = upfile;
		this.recruit = recruit;
		this.status = status;
		this.time = time;
		this.type = type;
		this.ldate = ldate;
		this.sdate = sdate;
		this.edate = edate;
		this.regDate = regDate;
		this.etc = etc;
	}
	@Override
	public String toString() {
		return "Study [sno=" + sno + ", mno=" + mno + ", subno=" + subno + ", tno=" + tno + ", dno=" + dno + ", title="
				+ title + ", freq=" + freq + ", content=" + content + ", price=" + price + ", upfile="
				+ upfile + ", recruit=" + recruit + ", status=" + status + ", time=" + time + ", type=" + type
				+ ", ldate=" + ldate + ", sdate=" + sdate + ", edate=" + edate + ", regDate=" + regDate + ", etc=" + etc
				+ "]";
	}
	public int getSno() {
		return sno;
	}
	public void setSno(int sno) {
		this.sno = sno;
	}
	public int getMno() {
		return mno;
	}
	public void setMno(int mno) {
		this.mno = mno;
	}
	public int getSubno() {
		return subno;
	}
	public void setSubno(int subno) {
		this.subno = subno;
	}
	public int getTno() {
		return tno;
	}
	public void setTno(int tno) {
		this.tno = tno;
	}
	public int getDno() {
		return dno;
	}
	public void setDno(int dno) {
		this.dno = dno;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getFreq() {
		return freq;
	}
	public void setFreq(String freq) {
		this.freq = freq;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getPrice() {
		return price;
	}
	public void setPrice(String price) {
		this.price = price;
	}
	public String getUpfile() {
		return upfile;
	}
	public void setUpfile(String upfile) {
		this.upfile = upfile;
	}
	public String getRecruit() {
		return recruit;
	}
	public void setRecruit(String recruit) {
		this.recruit = recruit;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getTime() {
		return time;
	}
	public void setTime(String time) {
		this.time = time;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public Date getLdate() {
		return ldate;
	}
	public void setLdate(Date ldate) {
		this.ldate = ldate;
	}
	public Date getSdate() {
		return sdate;
	}
	public void setSdate(Date sdate) {
		this.sdate = sdate;
	}
	public Date getEdate() {
		return edate;
	}
	public void setEdate(Date edate) {
		this.edate = edate;
	}
	public Date getRegDate() {
		return regDate;
	}
	public void setRegDate(Date regDate) {
		this.regDate = regDate;
	}
	public String getEtc() {
		return etc;
	}
	public void setEtc(String etc) {
		this.etc = etc;
	}
	
	

}
