package com.priya.repo;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.priya.domain.Quiz;
import com.priya.domain.Techno;

public interface QuizRepo extends JpaRepository<Quiz, Long> {

    List<Quiz> findByTechno(Techno techno);

    List<Quiz> findAllByOrderByQuizIdDesc();
}
