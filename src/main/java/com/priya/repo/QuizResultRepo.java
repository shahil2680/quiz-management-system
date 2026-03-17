package com.priya.repo;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import com.priya.domain.QuizResult;
import com.priya.domain.User;

public interface QuizResultRepo extends JpaRepository<QuizResult, Long> {
    List<QuizResult> findByUserOrderByAttemptDateDesc(User user);

    List<QuizResult> findAllByOrderByAttemptDateDesc();

    boolean existsByUserAndQuiz(User user, com.priya.domain.Quiz quiz);

    java.util.Optional<QuizResult> findByUserAndQuiz(User user, com.priya.domain.Quiz quiz);

    void deleteByUserAndQuiz(User user, com.priya.domain.Quiz quiz);

    List<QuizResult> findByQuiz(com.priya.domain.Quiz quiz);
}
