package com.priya.service;

import java.util.List;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.priya.domain.Question;
import com.priya.domain.QuestionDto;
import com.priya.domain.Quiz;
import com.priya.domain.Techno;
import com.priya.exception.QuestionException;
import com.priya.repo.QuestionRepo;
import com.priya.repo.QuizRepo;
import com.priya.repo.QuizResultRepo;
import com.priya.repo.TechnoRepo;

@Service
public class FacultyServiceImpl implements FacultyServiceIntf {

	@Autowired
	private QuestionRepo qRepo;

	@Autowired
	private TechnoRepo tRepo;

	@Autowired
	private QuizResultRepo quizResultRepo;

	@Autowired
	private QuizRepo quizRepo;

	public String setData(QuestionDto questionDto) {
		Question question = new Question();

		BeanUtils.copyProperties(questionDto, question);

		Techno techno = tRepo.findByTechName(questionDto.getTechnoName());
		question.setTechId(techno);

		Question save = qRepo.save(question);
		if (save != null) {
			return "Question Saved Sucessfully";
		} else {
			throw new QuestionException("Problem occured");
		}

	}

	@Override
	public Page<Question> getAllQuestion(Pageable pageable) {
		Page<Question> all = qRepo.findAll(pageable);
		return all;
	}

	public void deleteQ(Integer qid) {
		qRepo.deleteById(qid);
	}

	public String newTech(String name) {
		Techno techDto = new Techno();
		techDto.setTechName(name);

		Techno saved = tRepo.save(techDto);

		if (saved != null) {
			return "Technology Added";
		} else {
			return "Did't Add Technology";
		}
	}

	@Override
	public List<String> getAllTechName() {
		List<String> allName = tRepo.getAllName();
		return allName;
	}

	@Override
	public List<com.priya.domain.QuizResult> getAllResults() {
		return quizResultRepo.findAllByOrderByAttemptDateDesc();
	}

	// ============= Quiz Management =============

	@Override
	public Quiz saveQuiz(Quiz quiz) {
		return quizRepo.save(quiz);
	}

	@Override
	public List<Quiz> getAllQuizzes() {
		return quizRepo.findAllByOrderByQuizIdDesc();
	}

	@Override
	public Quiz getQuizById(Long id) {
		return quizRepo.findById(id).orElseThrow(() -> new RuntimeException("Quiz not found with ID " + id));
	}

	@Override
	public void deleteQuiz(Long id) {
		quizRepo.deleteById(id);
	}

	@Override
	public List<Question> getQuestionsByTechName(String techName) {
		Techno techno = tRepo.findByTechName(techName);
		if (techno == null)
			return List.of();
		return qRepo.getTech(techno.getTechId());
	}
}
