package com.priya.control;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.priya.domain.Question;
import com.priya.domain.Quiz;
import com.priya.domain.User;
import com.priya.domain.QuizResult;
import com.priya.repo.UserRepo;
import com.priya.repo.QuestionRepo;
import com.priya.repo.QuizRepo;
import com.priya.repo.QuizResultRepo;
import com.priya.service.StudentIntf;
import jakarta.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;

@Controller
public class StudentControl {

	@Autowired
	private StudentIntf stdService;

	@Autowired
	private UserRepo userRepo;

	@Autowired
	private QuizResultRepo quizResultRepo;

	@Autowired
	private QuizRepo quizRepo;

	@Autowired
	private QuestionRepo qRepo;

	// Show list of available quizzes
	@GetMapping("/getQuestion")
	public String showQuizList(Model m, HttpServletRequest request) {
		List<Quiz> quizzes = quizRepo.findAllByOrderByQuizIdDesc();

		// Check which quizzes the user has already attempted
		String userEmail = (String) request.getSession().getAttribute("userEmail");
		User user = userEmail != null ? userRepo.findByEmail(userEmail) : null;

		Map<Long, Boolean> attemptedQuizzes = new java.util.HashMap<>();
		if (user != null) {
			for (Quiz q : quizzes) {
				boolean attempted = quizResultRepo.existsByUserAndQuiz(user, q);
				attemptedQuizzes.put(q.getQuizId(), attempted);
			}
		}

		m.addAttribute("quizzes", quizzes);
		m.addAttribute("attemptedQuizzes", attemptedQuizzes);
		return "quizList";
	}

	// Start a specific quiz
	@GetMapping("/startQuiz")
	public String startQuiz(@RequestParam("quizId") Long quizId, Model m, HttpServletRequest request) {
		String userEmail = (String) request.getSession().getAttribute("userEmail");
		User user = userEmail != null ? userRepo.findByEmail(userEmail) : null;

		Quiz quiz = quizRepo.findById(quizId).orElse(null);

		// Redirect if quiz is empty or doesn't exist
		if (quiz == null || quiz.getQuestions().isEmpty()) {
			return "redirect:/getQuestion";
		}

		// Prevent re-attempts
		if (user != null && quizResultRepo.existsByUserAndQuiz(user, quiz)) {
			// Already attempted, redirect back to list
			return "redirect:/getQuestion?error=alreadyAttempted";
		}

		// Shuffle question order for randomization
		List<com.priya.domain.Question> shuffledQuestions = new ArrayList<>(quiz.getQuestions());
		java.util.Collections.shuffle(shuffledQuestions);

		m.addAttribute("Questions", shuffledQuestions);
		m.addAttribute("quizId", quiz.getQuizId());
		m.addAttribute("quizName", quiz.getQuizName());
		m.addAttribute("timeInMinutes", quiz.getTimeInMinutes());
		return "QuestionsQuize";
	}

	@PostMapping("/checkAns")
	public String checkAnswers(@RequestParam List<Integer> questionIds,
			@RequestParam Map<String, String> allParams,
			@RequestParam(value = "quizId", required = false) Long quizId,
			Model model, HttpServletRequest request) {
		List<String> selectedAnswers = new ArrayList<>();

		for (Integer qid : questionIds) {
			String key = String.valueOf(qid);
			if (allParams.containsKey(key)) {
				selectedAnswers.add(allParams.get(key));
			} else {
				selectedAnswers.add("");
			}
		}

		int score = stdService.calculateScore(questionIds, selectedAnswers);
		int totalQuestions = questionIds.size();
		int percentage = totalQuestions > 0 ? (score * 100) / totalQuestions : 0;

		// Build answer breakdown
		List<com.priya.domain.AnswerStatusDto> answerBreakdown = new ArrayList<>();

		for (int i = 0; i < questionIds.size(); i++) {
			Integer qid = questionIds.get(i);
			String selectedAns = selectedAnswers.get(i);
			Question q = qRepo.findById(qid).orElse(null);
			if (q != null) {
				boolean isCorrect = q.getCorrect_Opt().equals(selectedAns);
				answerBreakdown.add(new com.priya.domain.AnswerStatusDto(q, selectedAns, isCorrect));
			}
		}

		model.addAttribute("score", score);
		model.addAttribute("totalQuestions", totalQuestions);
		model.addAttribute("percentage", percentage);
		model.addAttribute("answerBreakdown", answerBreakdown);

		// Save result
		String userEmail = (String) request.getSession().getAttribute("userEmail");
		if (userEmail != null) {
			User user = userRepo.findByEmail(userEmail);
			if (user != null) {
				QuizResult result = new QuizResult();
				result.setUser(user);
				result.setScore(score);
				result.setTotalQuestions(totalQuestions);
				result.setPercentage(percentage);
				result.setAttemptDate(LocalDateTime.now());

				// Link to quiz if available
				if (quizId != null) {
					Quiz quiz = quizRepo.findById(quizId).orElse(null);
					if (quiz != null) {
						result.setQuiz(quiz);
						result.setQuizName(quiz.getQuizName());
					}
				}

				quizResultRepo.save(result);
			}
		}

		return "result";
	}

	@GetMapping("/resultHistory")
	public String resultHistory(HttpServletRequest request, Model model) {
		String userEmail = (String) request.getSession().getAttribute("userEmail");
		if (userEmail != null) {
			User user = userRepo.findByEmail(userEmail);
			if (user != null) {
				List<QuizResult> history = quizResultRepo.findByUserOrderByAttemptDateDesc(user);
				model.addAttribute("history", history);
			}
		}
		return "resultHistory";
	}

	@GetMapping("/studentProfile")
	public String studentProfile(HttpServletRequest request, Model model) {
		String userEmail = (String) request.getSession().getAttribute("userEmail");
		if (userEmail == null)
			return "redirect:/login";

		User user = userRepo.findByEmail(userEmail);
		if (user == null)
			return "redirect:/login";

		List<QuizResult> history = quizResultRepo.findByUserOrderByAttemptDateDesc(user);

		int totalTaken = 0;
		int bestScore = 0;
		int totalPercentage = 0;

		if (history != null) {
			totalTaken = history.size();
			for (QuizResult r : history) {
				if (r != null) {
					int pct = r.getPercentage() != null ? r.getPercentage() : 0;
					if (pct > bestScore) {
						bestScore = pct;
					}
					totalPercentage += pct;
				}
			}
		}

		int avgScore = totalTaken > 0 ? totalPercentage / totalTaken : 0;

		model.addAttribute("user", user);
		model.addAttribute("history", history);
		model.addAttribute("totalTaken", totalTaken);
		model.addAttribute("bestScore", bestScore);
		model.addAttribute("avgScore", avgScore);

		return "studentProfile";
	}

}
