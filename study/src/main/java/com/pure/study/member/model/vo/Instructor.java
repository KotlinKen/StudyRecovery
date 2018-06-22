package com.pure.study.member.model.vo;

import java.util.Date;

public class Instructor {
	private int ino;
	private int mno;
	private String portpolio;
	private String selfintroduction;
	private int kno;
	private int sno;
	private Date applicationdate;
	public Instructor() {
		super();
		// TODO Auto-generated constructor stub
	}
	public Instructor(int ino, int mno, String portpolio, String selfintroduction, int kno, int sno,
			Date applicationdate) {
		super();
		this.ino = ino;
		this.mno = mno;
		this.portpolio = portpolio;
		this.selfintroduction = selfintroduction;
		this.kno = kno;
		this.sno = sno;
		this.applicationdate = applicationdate;
	}
	public int getIno() {
		return ino;
	}
	public void setIno(int ino) {
		this.ino = ino;
	}
	public int getMno() {
		return mno;
	}
	public void setMno(int mno) {
		this.mno = mno;
	}
	public String getPortpolio() {
		return portpolio;
	}
	public void setPortpolio(String portpolio) {
		this.portpolio = portpolio;
	}
	public String getSelfintroduction() {
		return selfintroduction;
	}
	public void setSelfintroduction(String selfintroduction) {
		this.selfintroduction = selfintroduction;
	}
	public int getKno() {
		return kno;
	}
	public void setKno(int kno) {
		this.kno = kno;
	}
	public int getSno() {
		return sno;
	}
	public void setSno(int sno) {
		this.sno = sno;
	}
	public Date getApplicationdate() {
		return applicationdate;
	}
	public void setApplicationdate(Date applicationdate) {
		this.applicationdate = applicationdate;
	}
	@Override
	public String toString() {
		return "Instructor [ino=" + ino + ", mno=" + mno + ", portpolio=" + portpolio + ", selfintroduction="
				+ selfintroduction + ", kno=" + kno + ", sno=" + sno + ", applicationdate=" + applicationdate + "]";
	}
	
	
}
