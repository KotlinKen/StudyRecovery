package com.pure.study.message.model.vo;

public class Message {
	private String type;
	private String sender;
	private String recevier;
	private String msg;

	public Message(String type, String sender, String recevier, String msg) {
		super();
		this.type = type;
		this.sender = sender;
		this.recevier = recevier;
		this.msg = msg;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getSender() {
		return sender;
	}

	public void setSender(String sender) {
		this.sender = sender;
	}

	public String getRecevier() {
		return recevier;
	}

	public void setRecevier(String recevier) {
		this.recevier = recevier;
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}
}
