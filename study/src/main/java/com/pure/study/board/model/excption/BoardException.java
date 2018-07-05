package com.pure.study.board.model.excption;

@SuppressWarnings("serial")
public class BoardException extends RuntimeException {

	public BoardException() {
		super();
		// TODO Auto-generated constructor stub
	}

	public BoardException(String message) {
		super(message);
		System.out.println(message);
	}


	
}
