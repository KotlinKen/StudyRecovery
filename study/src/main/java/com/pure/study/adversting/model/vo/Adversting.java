package com.pure.study.adversting.model.vo;

import java.sql.Date;

public class Adversting {
	private int ano;
	private String title;
	private String content;
	private String advImg;
	private String url;
	private String position;
	private String status;
	private String backColor;
	private Date startAd;
	private Date endAd;
	private Date regDate;
	
	public Adversting() {
	}
	public Adversting(int ano, String title, String content, String advImg, String url, String position, Date startAd,
			Date endAd, String status, String backColor, Date regDate) {
		super();
		this.ano = ano;
		this.title = title;
		this.content = content;
		this.advImg = advImg;
		this.url = url;
		this.position = position;
		this.startAd = startAd;
		this.endAd = endAd;
		this.status = status;
		this.backColor = backColor;
		this.regDate = regDate;
	}
	public int getAno() {
		return ano;
	}

	public void setAno(int ano) {
		this.ano = ano;
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

	public String getAdvImg() {
		return advImg;
	}

	public void setAdvImg(String advImg) {
		this.advImg = advImg;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getPosition() {
		return position;
	}

	public void setPosition(String position) {
		this.position = position;
	}

	public Date getStartAd() {
		return startAd;
	}

	public void setStartAd(Date startAd) {
		this.startAd = startAd;
	}

	public Date getEndAd() {
		return endAd;
	}

	public void setEndAd(Date endAd) {
		this.endAd = endAd;
	}

	public Date getRegDate() {
		return regDate;
	}

	public void setRegDate(Date regDate) {
		this.regDate = regDate;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getBackColor() {
		return backColor;
	}

	public void setBackColor(String backColor) {
		this.backColor = backColor;
	}

	@Override
	public String toString() {
		return "Adversting [ano=" + ano + ", title=" + title + ", content=" + content + ", advImg=" + advImg + ", url="
				+ url + ", position=" + position + ", startAd=" + startAd + ", endAd=" + endAd + ", status=" + status
				+ ", backColor=" + backColor + ", regDate=" + regDate + "]";
	}

	
	
	
}