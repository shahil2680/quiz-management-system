package com.priya.exception;


public class QuestionException extends RuntimeException {

	
	
	private static final long serialVersionUID = 1L;
	
	public QuestionException()
	{
		super();
	}
	
	public QuestionException(String msg)
	{
		super(msg);
	}
}
