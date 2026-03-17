package com.priya.service;

import java.util.List;
import java.util.Map;

import com.priya.domain.Question;
import com.priya.domain.Techno;
import com.priya.domain.User;

public interface StudentIntf {
	
	public List<Techno> getAllTechno();
	//public List<Question> getQuestion(String name);
	public int calculateScore(List<Integer> questionIds, List<String> selectedAnswers);
	public List<Question> getAllQuestion();
	public Integer getTotalQns();
}
