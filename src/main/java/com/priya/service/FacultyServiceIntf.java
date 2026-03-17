package com.priya.service;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import com.priya.domain.Question;
import com.priya.domain.QuestionDto;
import com.priya.domain.Quiz;

public interface FacultyServiceIntf {

	public String setData(QuestionDto questionDto);

	public Page<Question> getAllQuestion(Pageable pageable);

	public void deleteQ(Integer qid);

	public String newTech(String tech);

	public List<String> getAllTechName();

	public List<com.priya.domain.QuizResult> getAllResults();

	// Quiz management
	public Quiz saveQuiz(Quiz quiz);

	public List<Quiz> getAllQuizzes();

	public Quiz getQuizById(Long id);

	public void deleteQuiz(Long id);

	public List<Question> getQuestionsByTechName(String techName);
}
