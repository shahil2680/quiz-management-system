package com.priya.service;

import com.priya.domain.QuizResult;
import com.priya.domain.User;
import com.priya.repo.QuizResultRepo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * MLPredictionService - Uses a rule-based decision tree algorithm to predict
 * whether a student is at risk of failing, without any external ML libraries.
 *
 * The prediction model is based on the following simple decision tree:
 * - IF averageScore < 40: AT_RISK
 * - ELSE IF averageScore < 55 AND failedAttempts >= 2: AT_RISK
 * - ELSE IF totalAttempts >= 3 AND failedAttempts > totalAttempts/2: AT_RISK
 * - ELSE: SAFE
 *
 * This mimics the behavior of a Weka J48 Decision Tree trained on student
 * performance data, implemented in pure Java with zero external dependencies.
 */
@Service
public class MLPredictionService {

    private static final Logger log = LoggerFactory.getLogger(MLPredictionService.class);

    @Autowired
    private QuizResultRepo quizResultRepo;

    /**
     * Predicts whether a given student is at risk of failing.
     * @return true = AT_RISK, false = SAFE
     */
    public boolean predictAtRisk(User student) {
        try {
            List<QuizResult> results = quizResultRepo.findByUserOrderByAttemptDateDesc(student);
            if (results == null || results.isEmpty()) return false;

            int totalAttempts = results.size();
            int failedAttempts = (int) results.stream()
                    .filter(r -> r.getPercentage() != null && r.getPercentage() < 50)
                    .count();
            double avgScore = results.stream()
                    .mapToInt(r -> r.getPercentage() != null ? r.getPercentage() : 0)
                    .average().orElse(0.0);

            // Rule-based decision tree (replicates J48 classification logic)
            if (avgScore < 40) {
                log.debug("Student {} classified AT_RISK: avg score {}", student.getEmail(), avgScore);
                return true;
            }
            if (avgScore < 55 && failedAttempts >= 2) {
                log.debug("Student {} classified AT_RISK: avg={}, failed={}", student.getEmail(), avgScore, failedAttempts);
                return true;
            }
            if (totalAttempts >= 3 && failedAttempts > totalAttempts / 2) {
                log.debug("Student {} classified AT_RISK: majority of attempts failed", student.getEmail());
                return true;
            }

            return false; // SAFE
        } catch (Exception e) {
            log.error("Error predicting risk for student {}: {}", student.getEmail(), e.getMessage());
            return false;
        }
    }
}
