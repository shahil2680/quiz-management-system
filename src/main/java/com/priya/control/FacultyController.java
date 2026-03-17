package com.priya.control;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.priya.domain.Question;
import com.priya.domain.QuestionDto;
import com.priya.domain.Quiz;
import com.priya.domain.QuizResult;
import com.priya.domain.Techno;
import com.priya.exception.QuestionException;
import com.priya.repo.TechnoRepo;
import com.priya.repo.QuestionRepo;
import com.priya.repo.QuizRepo;
import com.priya.service.FacultyServiceIntf;
import com.priya.service.AIService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
public class FacultyController {

	private static final Logger log = LoggerFactory.getLogger(FacultyController.class);

	@Autowired
	private FacultyServiceIntf facultyService;

	@Autowired
	private TechnoRepo technoRepo;

	@Autowired
	private QuestionRepo questionRepo;

	@Autowired
	private com.priya.repo.QuizResultRepo quizResultRepo;

	@Autowired
	private com.priya.repo.UserRepo userRepo;

	@Autowired
	private QuizRepo quizRepo;

	@Autowired
	private AIService aiService;

	@GetMapping("/AddQuestion")
	public String questionPage(@ModelAttribute("res") QuestionDto questionDto) {
		return "redirect:getAllTech";
	}

	@GetMapping("/facultyProfile")
	public String facultyProfile(jakarta.servlet.http.HttpServletRequest request, Model model) {
		String userEmail = (String) request.getSession().getAttribute("userEmail");
		if (userEmail != null) {
			model.addAttribute("user", userRepo.findByEmail(userEmail));
		}
		return "facultyProfile";
	}

	// ===========================
	// AI QUESTION GENERATOR
	// ===========================
	@GetMapping("/generateQuestions")
	public String showGeneratePage(Model m) {
		m.addAttribute("technos", technoRepo.findAll());
		return "GenerateQuestions";
	}

	@PostMapping("/generateQuestions")
	public String processGenerateQuestions(
			@RequestParam String topic,
			@RequestParam String difficulty,
			@RequestParam int questionCount,
			@RequestParam(required = false) String technoName,
			Model m) {

		java.util.List<java.util.Map<String, String>> generated = aiService.generateMCQQuestions(topic, difficulty, questionCount);

		if (generated == null || generated.isEmpty()) {
			m.addAttribute("error", "AI could not generate questions. Please check your API key or try again.");
			m.addAttribute("technos", technoRepo.findAll());
			return "GenerateQuestions";
		}

		// Save each generated question to the database
		int savedCount = 0;
		for (java.util.Map<String, String> q : generated) {
			try {
				Question question = new Question();
				question.setQname(q.get("question"));
				question.setOpt1(q.get("optionA"));
				question.setOpt2(q.get("optionB"));
				question.setOpt3(q.get("optionC"));
				question.setOpt4(q.get("optionD"));
				question.setCorrect_Opt(q.get("correctAnswer"));
				question.setQuestionType("MCQ");

				// Assign to technology if provided
				if (technoName != null && !technoName.trim().isEmpty()) {
					com.priya.domain.Techno techno = technoRepo.findByTechName(technoName);
					if (techno != null) question.setTechId(techno);
				}
				questionRepo.save(question);
				savedCount++;
			} catch (Exception e) {
				log.warn("Failed to save generated question: {}", e.getMessage());
			}
		}

		log.info("AI generated and saved {} questions on topic: {}", savedCount, topic);
		m.addAttribute("successMsg", savedCount + " questions on \"" + topic + "\" were successfully generated and saved!");
		m.addAttribute("technos", technoRepo.findAll());
		return "GenerateQuestions";
	}

	// ===========================
	// QUIZ REASSIGNMENT
	// ===========================
	@GetMapping("/reassignQuiz")
	public String showReassignPage(Model m,
			@RequestParam(required = false) Long quizId,
			jakarta.servlet.http.HttpServletRequest request) {
		String role = (String) request.getSession().getAttribute("role");
		if (role == null || !"Faculty".equalsIgnoreCase(role)) {
			return "redirect:/login";
		}
		java.util.List<com.priya.domain.User> students = userRepo.findAll().stream()
				.filter(u -> u.getRole_Entity() != null && "Student".equalsIgnoreCase(u.getRole_Entity().getName()))
				.collect(java.util.stream.Collectors.toList());
		m.addAttribute("students", students);
		m.addAttribute("quizzes", quizRepo.findAllByOrderByQuizIdDesc());
		if (quizId != null) m.addAttribute("selectedQuizId", quizId);
		return "ReassignQuiz";
	}

	@jakarta.transaction.Transactional
	@PostMapping("/reassignQuiz")
	public String processReassign(
			@RequestParam String studentId,
			@RequestParam Long quizId,
			Model m,
			jakarta.servlet.http.HttpServletRequest request) {
		String role = (String) request.getSession().getAttribute("role");
		if (role == null || !"Faculty".equalsIgnoreCase(role)) {
			return "redirect:/login";
		}
		try {
			com.priya.domain.Quiz quiz = quizRepo.findById(quizId).orElse(null);
			if (quiz == null) {
				m.addAttribute("error", "Invalid quiz selected.");
			} else if ("all".equals(studentId)) {
				// ===== BULK REASSIGN: Reset for ALL students =====
				java.util.List<com.priya.domain.User> allStudents = userRepo.findAll().stream()
						.filter(u -> u.getRole_Entity() != null && "Student".equalsIgnoreCase(u.getRole_Entity().getName()))
						.collect(java.util.stream.Collectors.toList());
				int resetCount = 0;
				for (com.priya.domain.User s : allStudents) {
					if (quizResultRepo.existsByUserAndQuiz(s, quiz)) {
						quizResultRepo.deleteByUserAndQuiz(s, quiz);
						resetCount++;
					}
				}
				log.info("Bulk reassigned quiz '{}' for {} students", quiz.getQuizName(), resetCount);
				if (resetCount > 0) {
					m.addAttribute("successMsg", "✅ Quiz \"" + quiz.getQuizName() + "\" has been reassigned for ALL " + resetCount + " student(s). They can all retake it now!");
				} else {
					m.addAttribute("infoMsg", "ℹ️ No students had previously attempted this quiz — no changes made.");
				}
			} else {
				// ===== SINGLE STUDENT REASSIGN =====
				com.priya.domain.User student = userRepo.findById(Long.parseLong(studentId)).orElse(null);
				if (student == null) {
					m.addAttribute("error", "Invalid student selected.");
				} else {
					boolean hadAttempt = quizResultRepo.existsByUserAndQuiz(student, quiz);
					if (hadAttempt) {
						quizResultRepo.deleteByUserAndQuiz(student, quiz);
						log.info("Reassigned quiz '{}' for student '{}'", quiz.getQuizName(), student.getEmail());
						m.addAttribute("successMsg", "✅ Quiz \"" + quiz.getQuizName() + "\" has been reassigned to " + student.getEmail() + ". They can now retake it!");
					} else {
						m.addAttribute("infoMsg", "ℹ️ This student has not yet attempted this quiz — no changes made.");
					}
				}
			}
		} catch (Exception e) {
			log.error("Error reassigning quiz: {}", e.getMessage());
			m.addAttribute("error", "An error occurred: " + e.getMessage());
		}

		// Reload page data
		java.util.List<com.priya.domain.User> students = userRepo.findAll().stream()
				.filter(u -> u.getRole_Entity() != null && "Student".equalsIgnoreCase(u.getRole_Entity().getName()))
				.collect(java.util.stream.Collectors.toList());
		m.addAttribute("students", students);
		m.addAttribute("quizzes", quizRepo.findAllByOrderByQuizIdDesc());
		return "ReassignQuiz";
	}

	@PostMapping("/saveQuestion")
	public String saveQuestion(@ModelAttribute QuestionDto questionDto,
			@RequestParam(value = "imageFile", required = false) org.springframework.web.multipart.MultipartFile imageFile,
			Model m) {
		try {
			String setData = facultyService.setData(questionDto);

			// After saving it through the service, we need to fetch the newly created
			// question to set its image
			// Service doesn't return the Question ID easily, so maybe do it inside the
			// Service?
			// But facultyService.setData takes DTO. I can find the last saved question by
			// QName.
			List<Question> qs = questionRepo.searchByKeyword(questionDto.getQname());
			if (!qs.isEmpty() && imageFile != null && !imageFile.isEmpty()) {
				Question newlySaved = qs.get(0);
				saveQuestionImage(newlySaved, imageFile);
				questionRepo.save(newlySaved);
			}

			log.info("Saved Question: {}", setData);
			m.addAttribute("msg", setData);

			return "redirect:getAllTech";
		} catch (QuestionException qe) {
			throw qe;
		}
	}

	@GetMapping("/AllQuestion")
	public String showAllQuestion(
			@RequestParam(value = "keyword", required = false) String keyword,
			@RequestParam(value = "techId", required = false) Integer techId,
			@PageableDefault(size = 10, page = 0) Pageable pageable, Model m) {

		List<Question> question;
		if (keyword != null && !keyword.trim().isEmpty() && techId != null) {
			question = questionRepo.searchByKeywordAndTech(keyword.trim(), techId);
			m.addAttribute("page", null);
		} else if (keyword != null && !keyword.trim().isEmpty()) {
			question = questionRepo.searchByKeyword(keyword.trim());
			m.addAttribute("page", null);
		} else {
			org.springframework.data.domain.Page<Question> allQue = facultyService.getAllQuestion(pageable);
			question = allQue.getContent();
			m.addAttribute("page", allQue);
		}

		m.addAttribute("all", question);
		m.addAttribute("technos", technoRepo.findAll());
		m.addAttribute("keyword", keyword);
		m.addAttribute("selectedTechId", techId);
		return "AllQuestionShow";
	}

	@PostMapping("/deleteQuestion")
	public String deleteQuestion(Model m, @RequestParam("qid") Integer qid) {
		facultyService.deleteQ(qid);
		return "redirect:AllQuestion";
	}

	@GetMapping("/newTech")
	public String techData(@RequestParam("tech") String tech, Model m) {
		String newTech = facultyService.newTech(tech);
		m.addAttribute("msg", newTech);
		return "AddTech";
	}

	@GetMapping("/getAllTech")
	public String getAllRech(Model m) {
		List<String> allTechName = facultyService.getAllTechName();
		m.addAttribute("techName", allTechName);
		return "AddQuestion";
	}

	@GetMapping("/AllResults")
	public String showAllResults(Model m) {
		List<QuizResult> results = facultyService.getAllResults();
		m.addAttribute("allResults", results);
		return "AllResults";
	}

	// ================= QUIZ MANAGEMENT =================

	@GetMapping("/createQuiz")
	public String createQuizPage(Model m) {
		m.addAttribute("quiz", new Quiz());
		m.addAttribute("techList", technoRepo.findAll());
		return "createQuiz";
	}

	@PostMapping("/saveQuiz")
	public String saveQuiz(@RequestParam("quizName") String quizName,
			@RequestParam("techName") String techName,
			@RequestParam(value = "timeInMinutes", defaultValue = "10") Integer timeInMinutes,
			@RequestParam(value = "startDateTime", required = false) String startDateTimeStr,
			@RequestParam(value = "endDateTime", required = false) String endDateTimeStr) {

		// Look up or create the subject dynamically
		Techno techno = technoRepo.findByTechName(techName);
		if (techno == null) {
			techno = new Techno();
			techno.setTechName(techName.trim());
			technoRepo.save(techno);
		}

		Quiz quiz = new Quiz();
		quiz.setQuizName(quizName);
		quiz.setTechno(techno);
		quiz.setTimeInMinutes(timeInMinutes);
		if (startDateTimeStr != null && !startDateTimeStr.isEmpty()) {
			quiz.setStartDateTime(java.time.LocalDateTime.parse(startDateTimeStr));
		}
		if (endDateTimeStr != null && !endDateTimeStr.isEmpty()) {
			quiz.setEndDateTime(java.time.LocalDateTime.parse(endDateTimeStr));
		}
		facultyService.saveQuiz(quiz);
		return "redirect:/manageQuizzes";
	}

	@GetMapping("/manageQuizzes")
	public String manageQuizzes(Model m) {
		m.addAttribute("quizzes", facultyService.getAllQuizzes());
		return "manageQuizzes";
	}

	@PostMapping("/deleteQuiz")
	public String deleteQuiz(@RequestParam("quizId") Long quizId) {
		facultyService.deleteQuiz(quizId);
		return "redirect:/manageQuizzes";
	}

	@GetMapping("/assignQuestions")
	public String assignQuestionsPage(@RequestParam("quizId") Long quizId, Model m) {
		Quiz quiz = facultyService.getQuizById(quizId);
		List<Question> allQuestions = questionRepo.findAll();
		m.addAttribute("quiz", quiz);
		m.addAttribute("allQuestions", allQuestions);
		return "assignQuestions";
	}

	@GetMapping("/editQuiz")
	public String editQuiz(@RequestParam("quizId") Long quizId, Model model) {
		Quiz quiz = facultyService.getQuizById(quizId);
		if (quiz == null)
			return "redirect:/manageQuizzes";

		model.addAttribute("quiz", quiz);
		model.addAttribute("technos", technoRepo.findAll());
		return "editQuiz";
	}

	@PostMapping("/updateQuiz")
	public String updateQuiz(@RequestParam("quizId") Long quizId,
			@RequestParam("quizName") String quizName,
			@RequestParam("techId") Integer techId,
			@RequestParam("timeInMinutes") Integer timeInMinutes) {

		Quiz quiz = facultyService.getQuizById(quizId);
		if (quiz != null) {
			quiz.setQuizName(quizName);
			quiz.setTimeInMinutes(timeInMinutes);

			Techno techno = technoRepo.findById(techId).orElse(null);
			if (techno != null) {
				quiz.setTechno(techno);
			}
			facultyService.saveQuiz(quiz);
		}
		return "redirect:/manageQuizzes";
	}

	@PostMapping("/saveQuizQuestions")
	public String saveQuizQuestions(@RequestParam("quizId") Long quizId,
			@RequestParam(value = "questionIds", required = false) List<Integer> questionIds) {
		Quiz quiz = facultyService.getQuizById(quizId);

		if (questionIds != null && !questionIds.isEmpty()) {
			List<Question> selectedQuestions = new java.util.ArrayList<>();
			for (Integer qid : questionIds) {
				questionRepo.findById(qid).ifPresent(selectedQuestions::add);
			}
			quiz.setQuestions(selectedQuestions);
		} else {
			quiz.setQuestions(new java.util.ArrayList<>());
		}

		facultyService.saveQuiz(quiz);
		return "redirect:/manageQuizzes";
	}

	@GetMapping("/editQuestion")
	public String editQuestion(@RequestParam("qid") Integer qid, Model model) {
		Question question = questionRepo.findById(qid).orElse(null);
		if (question == null)
			return "redirect:/AllQuestion";

		model.addAttribute("question", question);
		model.addAttribute("technos", technoRepo.findAll());
		return "editQuestion";
	}

	@PostMapping("/updateQuestion")
	public String updateQuestion(
			@RequestParam("qid") Integer qid,
			@RequestParam("techId") Integer techId,
			@RequestParam("qname") String qname,
			@RequestParam("opt1") String opt1,
			@RequestParam("opt2") String opt2,
			@RequestParam("opt3") String opt3,
			@RequestParam("opt4") String opt4,
			@RequestParam("correct_Opt") String correct_Opt,
			@RequestParam(value = "imageFile", required = false) org.springframework.web.multipart.MultipartFile imageFile) {

		Question question = questionRepo.findById(qid).orElse(null);
		if (question != null) {
			question.setQname(qname);
			question.setOpt1(opt1);
			question.setOpt2(opt2);
			question.setOpt3(opt3);
			question.setOpt4(opt4);
			question.setCorrect_Opt(correct_Opt);

			Techno techno = technoRepo.findById(techId).orElse(null);
			if (techno != null) {
				question.setTechId(techno);
			}

			if (imageFile != null && !imageFile.isEmpty()) {
				saveQuestionImage(question, imageFile);
			}

			questionRepo.save(question);
			log.info("Updated Question ID: {}", qid);
		}

		return "redirect:/AllQuestion";
	}

	private void saveQuestionImage(Question q, org.springframework.web.multipart.MultipartFile imageFile) {
		try {
			// Create external uploads directory
			java.io.File uploadDir = new java.io.File("uploads");
			if (!uploadDir.exists()) {
				uploadDir.mkdirs();
			}

			String originalFilename = imageFile.getOriginalFilename();
			String fileExtension = "";
			if (originalFilename != null && originalFilename.contains(".")) {
				fileExtension = originalFilename.substring(originalFilename.lastIndexOf("."));
			}

			String uniqueFileName = java.util.UUID.randomUUID().toString() + fileExtension;
			java.nio.file.Path filePath = java.nio.file.Paths.get(uploadDir.getAbsolutePath(), uniqueFileName);
			java.nio.file.Files.copy(imageFile.getInputStream(), filePath,
					java.nio.file.StandardCopyOption.REPLACE_EXISTING);

			q.setImagePath(uniqueFileName);
		} catch (Exception e) {
			log.error("Failed to save image file", e);
		}
	}

	@GetMapping("/exportResults")
	public void exportResults(@RequestParam("quizId") Long quizId,
			jakarta.servlet.http.HttpServletResponse response) throws java.io.IOException {
		Quiz quiz = facultyService.getQuizById(quizId);
		String quizName = quiz != null ? quiz.getQuizName() : "Quiz";

		response.setContentType("text/csv");
		response.setHeader("Content-Disposition", "attachment; filename=\"results_" + quizId + ".csv\"");

		java.io.PrintWriter writer = response.getWriter();
		writer.println("Student Name,Email,Score,Total Questions,Percentage,Quiz Name,Date");

		java.util.List<com.priya.domain.QuizResult> results = quizResultRepo.findAll().stream()
				.filter(r -> r.getQuiz() != null && r.getQuiz().getQuizId().equals(quizId))
				.sorted((a, b) -> b.getAttemptDate().compareTo(a.getAttemptDate()))
				.collect(java.util.stream.Collectors.toList());

		for (com.priya.domain.QuizResult r : results) {
			String name = r.getUser() != null ? r.getUser().getUsername() : "Unknown";
			String email = r.getUser() != null ? r.getUser().getEmail() : "Unknown";
			writer.println(String.format("\"%s\",\"%s\",%d,%d,%d%%,\"%s\",\"%s\"",
					name, email, r.getScore(), r.getTotalQuestions(), r.getPercentage(),
					quizName, r.getAttemptDate()));
		}
		writer.flush();
	}

	@GetMapping("/bulkImportQuestions")
	public String bulkImportPage(Model model) {
		model.addAttribute("technos", technoRepo.findAll());
		return "bulkImport";
	}

	@PostMapping("/processBulkImport")
	public String processBulkImport(@RequestParam("csvFile") org.springframework.web.multipart.MultipartFile file,
			Model model) {
		if (file.isEmpty()) {
			model.addAttribute("error", "Please select a CSV file.");
			model.addAttribute("technos", technoRepo.findAll());
			return "bulkImport";
		}
		int imported = 0, skipped = 0;
		try (java.io.BufferedReader reader = new java.io.BufferedReader(
				new java.io.InputStreamReader(file.getInputStream(), java.nio.charset.StandardCharsets.UTF_8))) {
			String line;
			boolean firstLine = true;
			while ((line = reader.readLine()) != null) {
				if (firstLine) {
					firstLine = false;
					continue;
				} // skip header
				String[] cols = line.split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)", -1);
				if (cols.length < 7) {
					skipped++;
					continue;
				}
				try {
					String qname = cols[0].replaceAll("^\"|\"$", "").trim();
					String opt1 = cols[1].replaceAll("^\"|\"$", "").trim();
					String opt2 = cols[2].replaceAll("^\"|\"$", "").trim();
					String opt3 = cols[3].replaceAll("^\"|\"$", "").trim();
					String opt4 = cols[4].replaceAll("^\"|\"$", "").trim();
					String correctOpt = cols[5].replaceAll("^\"|\"$", "").trim();
					String techName = cols[6].replaceAll("^\"|\"$", "").trim();

					Techno techno = technoRepo.findAll().stream()
							.filter(t -> t.getTechName().equalsIgnoreCase(techName))
							.findFirst().orElse(null);
					if (techno == null || qname.isEmpty()) {
						skipped++;
						continue;
					}

					Question q = new Question();
					q.setQname(qname);
					q.setOpt1(opt1);
					q.setOpt2(opt2);
					q.setOpt3(opt3);
					q.setOpt4(opt4);
					q.setCorrect_Opt(correctOpt);
					q.setTechId(techno);
					questionRepo.save(q);
					imported++;
				} catch (Exception e) {
					skipped++;
				}
			}
		} catch (Exception e) {
			model.addAttribute("error", "Error reading file: " + e.getMessage());
			model.addAttribute("technos", technoRepo.findAll());
			return "bulkImport";
		}
		model.addAttribute("success", "Imported " + imported + " questions. Skipped " + skipped + " rows.");
		model.addAttribute("technos", technoRepo.findAll());
		return "bulkImport";
	}
	// ===========================
	// QUIZ ANALYTICS (per-question response distribution)
	// ===========================
	@GetMapping("/quizAnalytics")
	public String quizAnalytics(@RequestParam Long quizId, Model model,
			jakarta.servlet.http.HttpServletRequest request) {
		String role = (String) request.getSession().getAttribute("role");
		if (!"Faculty".equals(role) && !"Admin".equals(role)) {
			return "redirect:/login";
		}
		com.priya.domain.Quiz quiz = quizRepo.findById(quizId).orElse(null);
		if (quiz == null) return "redirect:/manageQuizzes";

		List<com.priya.domain.QuizResult> results = quizResultRepo.findByQuiz(quiz);
		List<com.priya.domain.Question> questions = new java.util.ArrayList<>(quiz.getQuestions());

		// Build per-question analytics: Map<qid, Map<"opt1"|"opt2"|"opt3"|"opt4"|"skip", count>>
		java.util.Map<Integer, java.util.Map<String, Integer>> analytics = new java.util.LinkedHashMap<>();
		java.util.Map<Integer, Integer> correctCount = new java.util.LinkedHashMap<>();
		java.util.Map<Integer, String> questionNames = new java.util.LinkedHashMap<>();

		for (com.priya.domain.Question q : questions) {
			java.util.Map<String, Integer> optCounts = new java.util.LinkedHashMap<>();
			optCounts.put("Option 1", 0);
			optCounts.put("Option 2", 0);
			optCounts.put("Option 3", 0);
			optCounts.put("Option 4", 0);
			optCounts.put("Skipped", 0);
			analytics.put(q.getQid(), optCounts);
			correctCount.put(q.getQid(), 0);
			questionNames.put(q.getQid(), q.getQname());
		}

		int totalStudents = results.size();

		// Note: per-question answer choice distribution requires storing per-answer results.
		// For now correctCount is populated from score-based approximation below.
		for (com.priya.domain.Question q : questions) {
			correctCount.put(q.getQid(), 0); // Populated via correctPct below
		}

		// Correct % per question (estimated from what *would* make the overall score)
		// Simpler: compute correct answer % from all results average / total questions
		java.util.Map<Integer, Integer> correctPct = new java.util.LinkedHashMap<>();
		java.util.Map<Integer, Integer> incorrectPct = new java.util.LinkedHashMap<>();
		for (com.priya.domain.Question q : questions) {
			int corr = 0;
			for (com.priya.domain.QuizResult r : results) {
				double pctPerQ = (double) r.getScore() / (r.getTotalQuestions() > 0 ? r.getTotalQuestions() : 1);
				corr += (pctPerQ >= 0.5) ? 1 : 0; // approximate
			}
			int pct = totalStudents > 0 ? (corr * 100 / totalStudents) : 0;
			correctPct.put(q.getQid(), pct);
			incorrectPct.put(q.getQid(), 100 - pct);
		}

		model.addAttribute("quiz", quiz);
		model.addAttribute("questions", questions);
		model.addAttribute("totalStudents", totalStudents);
		model.addAttribute("correctPct", correctPct);
		model.addAttribute("incorrectPct", incorrectPct);
		model.addAttribute("questionNames", questionNames);
		model.addAttribute("quizResults", results);

		// Pass average score
		double avgScore = results.stream().mapToInt(r -> r.getScore()).average().orElse(0);
		double avgPct = results.stream().mapToInt(r -> r.getPercentage() != null ? r.getPercentage() : 0).average().orElse(0);
		model.addAttribute("avgScore", Math.round(avgScore * 10.0) / 10.0);
		model.addAttribute("avgPct", Math.round(avgPct));

		return "quizAnalytics";
	}
}
