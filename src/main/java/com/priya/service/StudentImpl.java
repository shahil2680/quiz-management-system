package com.priya.service;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.priya.domain.Question;
import com.priya.domain.Techno;
import com.priya.repo.QuestionRepo;
import com.priya.repo.TechnoRepo;
import com.priya.repo.UserRepo;

@Service
public class StudentImpl implements StudentIntf {

	@Autowired
	private UserRepo uRepo;

	@Autowired
	private QuestionRepo qRepo;

	@Autowired
	private TechnoRepo tRepo;

	public List<Techno> getAllTechno() {
		List<Techno> trepo = tRepo.findAll();

		return trepo;
	}

	public List<Question> getAllQuestion() {
		List<Question> all = qRepo.getRandomQuestions();
		return all;
	}

	public int calculateScore(List<Integer> questionIds, List<String> selectedAnswers) {
		int score = 0;

		for (int i = 0; i < questionIds.size(); i++) {
			Integer qid = questionIds.get(i);

			// Using Optional to handle missing questions safely
			Optional<Question> questionOpt = qRepo.findById(qid);

			if (questionOpt.isPresent()) {
				Question question = questionOpt.get();

				// Compare selected answer with the correct option stored in the database
				if (question.getCorrect_Opt().equals(selectedAnswers.get(i))) {
					score++;
				}
			}
		}
		return score;
	}

	@Override
	public Integer getTotalQns() {
		return qRepo.countQuestion();
	}

}
