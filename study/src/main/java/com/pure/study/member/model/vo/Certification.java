package com.pure.study.member.model.vo;

public class Certification {
	private int cno;
	private String email;
	private String certification;
	public Certification() {
		super();
		// TODO Auto-generated constructor stub
	}
	public Certification(int cno, String email, String certification) {
		super();
		this.cno = cno;
		this.email = email;
		this.certification = certification;
	}
	public int getCno() {
		return cno;
	}
	public void setCno(int cno) {
		this.cno = cno;
	}
	public String getEmail() {
		return email;
	}
	public void setAddr(String email) {
		this.email = email;
	}
	public String getCertification() {
		return certification;
	}
	public void setCertification(String certification) {
		this.certification = certification;
	}
	@Override
	public String toString() {
		return "Certification [cno=" + cno + ", email=" + email + ", certification=" + certification + "]";
	}
	
}
