package com.priya.control;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.priya.domain.UserDto;
import com.priya.domain.Quiz;
import com.priya.service.ServiceIntf;
import com.priya.service.EmailService;
import com.priya.service.OtpService;
import com.priya.service.MLPredictionService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class MyControl {

    @Autowired
    private ServiceIntf service;

    @Autowired
    private com.priya.repo.QuizRepo quizRepo;

    @Autowired
    private com.priya.repo.QuizResultRepo quizResultRepo;

    @Autowired
    private com.priya.repo.UserRepo userRepo;

    @Autowired
    private EmailService emailService;

    @Autowired
    private OtpService otpService;

    @Autowired
    private MLPredictionService mlPredictionService;

    // ================= HOME =================
    @GetMapping("/")
    public String home() {
        return "redirect:/login";
    }

    // ================= SIGN UP =================
    @GetMapping("/signUp")
    public String signUp(@RequestParam(value = "role", required = false, defaultValue = "student") String role,
            Model model) {
        UserDto dto = new UserDto();
        dto.setRole(role);
        model.addAttribute("signUpDto", dto);

        String displayRole = role.substring(0, 1).toUpperCase() + role.substring(1).toLowerCase();
        model.addAttribute("displayRole", displayRole);
        return "signUp";
    }

    @PostMapping("/saveData")
    public String storeUser(@ModelAttribute("signUpDto") UserDto userDto,
            Model model) {

        String msg = service.saveData(userDto);
        model.addAttribute("message", msg);

        return "signUp"; // OR use: redirect:/login
    }

    // ================= LOGIN =================
    @GetMapping("/login")
    public String login(Model model) {
        model.addAttribute("result", new UserDto());
        return "LoginPage";
    }

    @PostMapping("/checkLogin")
    public String checkLogin(@ModelAttribute("result") UserDto userDto,
            HttpServletRequest request) {

        String page = service.checkLoginService(userDto, request);

        // service should return:
        // "Student" or "Faculty" or "Admin"
        return page;
    }

    // ================= STUDENT =================
    @GetMapping("/Student")
    public String studentDashBoard(HttpServletRequest request, Model model) {
        String userEmail = (String) request.getSession().getAttribute("userEmail");
        if (userEmail != null) {
            com.priya.domain.User user = userRepo.findByEmail(userEmail);
            if (user != null) {
                List<com.priya.domain.QuizResult> history = quizResultRepo.findByUserOrderByAttemptDateDesc(user);

                // create labels and data points for chart
                java.util.List<String> quizLabels = new java.util.ArrayList<>();
                java.util.List<Integer> quizScores = new java.util.ArrayList<>();

                // Clone the list to safely reverse it for a left-to-right timeline
                List<com.priya.domain.QuizResult> chronologicalHistory = new java.util.ArrayList<>(history);
                java.util.Collections.reverse(chronologicalHistory);

                for (com.priya.domain.QuizResult r : chronologicalHistory) {
                    quizLabels.add(r.getQuizName() != null ? r.getQuizName() : "Quiz " + r.getResultId());
                    quizScores.add(r.getPercentage() != null ? r.getPercentage() : 0);
                }

                model.addAttribute("quizLabels", quizLabels);
                model.addAttribute("quizScores", quizScores);

                // ===== PERSONALIZED LEARNING RECOMMENDATIONS =====
                // Find the quiz with the lowest score in their history to target weak areas
                java.util.List<Quiz> recommendedQuizzes = new java.util.ArrayList<>();
                if (!history.isEmpty()) {
                    // Find the quiz name with the worst score
                    com.priya.domain.QuizResult worstResult = history.stream()
                            .filter(r -> r.getPercentage() != null)
                            .min(java.util.Comparator.comparingInt(com.priya.domain.QuizResult::getPercentage))
                            .orElse(null);

                    // Get IDs of quizzes the student has already attempted
                    java.util.Set<Long> attemptedQuizIds = new java.util.HashSet<>();
                    for (com.priya.domain.QuizResult r : history) {
                        if (r.getQuiz() != null) attemptedQuizIds.add(r.getQuiz().getQuizId());
                    }

                    // Find quizzes the student hasn't tried yet
                    List<Quiz> allQuizzes = quizRepo.findAllByOrderByQuizIdDesc();
                    for (Quiz q : allQuizzes) {
                        if (!attemptedQuizIds.contains(q.getQuizId())) {
                            recommendedQuizzes.add(q);
                            if (recommendedQuizzes.size() >= 3) break; // Limit to top 3 recommendations
                        }
                    }

                    // Add context for the recommendation message
                    if (worstResult != null && worstResult.getPercentage() < 60) {
                        model.addAttribute("weakArea", worstResult.getQuizName());
                        model.addAttribute("weakScore", worstResult.getPercentage());
                    }
                }
                model.addAttribute("recommendedQuizzes", recommendedQuizzes);
            }
        }
        return "Student";
    }

    // ================= FACULTY =================
    @GetMapping("/Faculty")
    public String facultyDashBoard(Model model) {

        model.addAttribute("studentCount", service.countStudent());
        model.addAttribute("Staffs", service.countFaculty());
        model.addAttribute("qnCount", service.countQuestions());
        model.addAttribute("quizCount", quizRepo.count());

        // Calculate Average Scores per Quiz for Chart.js
        List<com.priya.domain.QuizResult> allResults = quizResultRepo.findAll();
        java.util.Map<String, List<Integer>> scoresMap = new java.util.HashMap<>();

        for (com.priya.domain.QuizResult result : allResults) {
            String qName = result.getQuizName() != null ? result.getQuizName() : "Unknown";
            int pct = result.getPercentage() != null ? result.getPercentage() : 0;
            scoresMap.computeIfAbsent(qName, k -> new java.util.ArrayList<>()).add(pct);
        }

        java.util.List<String> quizLabels = new java.util.ArrayList<>();
        java.util.List<Double> quizAverages = new java.util.ArrayList<>();
        java.util.List<Integer> quizAttempts = new java.util.ArrayList<>();

        for (java.util.Map.Entry<String, List<Integer>> entry : scoresMap.entrySet()) {
            quizLabels.add(entry.getKey());
            double avg = entry.getValue().stream().mapToInt(Integer::intValue).average().orElse(0.0);
            quizAverages.add(Math.round(avg * 10.0) / 10.0); // Round to 1 decimal
            quizAttempts.add(entry.getValue().size());
        }

        model.addAttribute("quizLabels", quizLabels);
        model.addAttribute("quizAverages", quizAverages);
        model.addAttribute("quizAttempts", quizAttempts);

        return "Faculty";
    }

    // ================= ADMIN =================
    @GetMapping("/Admin")
    public String adminDashBoard(Model model) {

        model.addAttribute("studentCount", service.countStudent());
        model.addAttribute("Staffs", service.countFaculty());
        model.addAttribute("qnCount", service.countQuestions());
        model.addAttribute("quizCount", quizRepo.count());

        return "Admin";
    }

    @GetMapping("/adminProfile")
    public String adminProfile(HttpServletRequest request, Model model) {
        String userEmail = (String) request.getSession().getAttribute("userEmail");
        if (userEmail != null) {
            model.addAttribute("user", userRepo.findByEmail(userEmail));
        }
        return "adminProfile";
    }

    // ================= SHOW ALL USERS =================
    @GetMapping("/ShowAllStudent")
    public String showAllStudent(@RequestParam("name") String name,
            Model model) {

        List<UserDto> list = service.showAllStudentData(name);

        // ===== AT-RISK PREDICTION (WEKA ML) =====
        // Only run prediction when viewing students, not faculty/admin lists
        if ("student".equalsIgnoreCase(name)) {
            java.util.Set<Long> atRiskIds = new java.util.HashSet<>();
            for (UserDto u : list) {
                try {
                    com.priya.domain.User student = userRepo.findByEmail(u.getEmail());
                    if (student != null && mlPredictionService.predictAtRisk(student)) {
                        atRiskIds.add(u.getId());
                    }
                } catch (Exception e) {
                    // Silently skip prediction errors
                }
            }
            model.addAttribute("atRiskIds", atRiskIds);
        }

        model.addAttribute("users", list);
        model.addAttribute("name", name);

        return "ShowAllData";
    }

    // ================= DELETE =================
    @PostMapping("/delete")
    public String deleteOne(@RequestParam("id") Long id) {

        String role = service.removeOneData(id);

        return "redirect:/ShowAllStudent?name=" + role;
    }

    // ================= UPDATE =================
    @GetMapping("/update")
    public String updateData(@RequestParam("id") Long id,
            @RequestParam("roleName") String role,
            Model model) {

        UserDto user = service.editData(id, role);
        user.setRole(role);

        model.addAttribute("student", user);

        return "editPage";
    }

    @PostMapping("/updateSubmit")
    public String updateSubmit(@ModelAttribute UserDto userDto) {

        service.updateData(userDto);

        return "redirect:/ShowAllStudent?name=" + userDto.getRole();
    }

    // ================= ADD USER (ADMIN) =================
    @GetMapping("/AddUser")
    public String addUserPage(Model model) {
        model.addAttribute("AdminSignUpDto", new UserDto());
        return "AddUser";
    }

    @PostMapping("/AdminAddUser")
    public String addUserAdmin(@ModelAttribute("AdminSignUpDto") UserDto userDto,
            Model model) {

        service.addUser(userDto);

        return "redirect:/AddUser";
    }

    // ================= LOGOUT =================
    @GetMapping("/logout")
    public String logout(HttpServletRequest request) {

        request.getSession().invalidate();
        return "redirect:/login";
    }

    // ================= FORGET PASSWORD =================
    @GetMapping("/forget")
    public String forgetPassword() {
        return "forget";
    }

    @PostMapping("/getPassword")
    public String getPassword(@RequestParam("email") String mail,
            Model model, HttpSession session) {

        if (!service.checkEmailExists(mail)) {
            model.addAttribute("error", "No account found with this email.");
            return "forget";
        }

        String otp = otpService.generateOtp(mail);
        boolean sent = emailService.sendSimpleEmail(mail, "Your Password Recovery Code",
                "Your password recovery OTP is: " + otp
                        + "\n\nThis code is valid for a single use to reset your account password.\nIf you did not request a password reset, you can safely ignore this email.");

        if (!sent) {
            model.addAttribute("error", "Failed to send email. Please check the server's SMTP configuration.");
            return "forget";
        }

        session.setAttribute("resetEmail", mail);
        return "redirect:/enterOtp";
    }

    // ================= ENTER OTP =================
    @GetMapping("/enterOtp")
    public String enterOtpPage(HttpSession session) {
        if (session.getAttribute("resetEmail") == null) {
            return "redirect:/forget";
        }
        return "enterOtp";
    }

    @PostMapping("/verifyOtp")
    public String verifyOtp(@RequestParam("otp") String otp, HttpSession session, Model model) {
        String email = (String) session.getAttribute("resetEmail");
        if (email == null) {
            return "redirect:/forget";
        }

        if (otpService.validateOtp(email, otp)) {
            return "redirect:/resetPassword";
        } else {
            model.addAttribute("error", "Invalid or expired OTP.");
            return "enterOtp";
        }
    }

    // ================= RESET PASSWORD =================
    @GetMapping("/resetPassword")
    public String resetPasswordPage(HttpSession session) {
        String email = (String) session.getAttribute("resetEmail");
        if (email == null || !otpService.isVerified(email)) {
            return "redirect:/forget";
        }
        return "resetPassword";
    }

    @PostMapping("/updatePassword")
    public String updatePassword(@RequestParam("newPassword") String newPassword, HttpSession session, Model model) {
        String email = (String) session.getAttribute("resetEmail");
        if (email == null || !otpService.isVerified(email)) {
            return "redirect:/forget";
        }

        service.updatePasswordByEmail(email, newPassword);
        otpService.clearVerification(email);
        session.removeAttribute("resetEmail");

        model.addAttribute("message", "Password reset successfully. Please login.");
        model.addAttribute("result", new UserDto());
        return "LoginPage";
    }
}