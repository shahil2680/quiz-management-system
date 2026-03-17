package com.priya.repo;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.priya.domain.Question;
import com.priya.domain.Techno;

public interface QuestionRepo extends JpaRepository<Question, Integer> {

	@Query("select count(q) from Question q")
	public Integer countQuestion();

	@Query("select q from Question q where q.techId.techId=:id")
	public List<Question> getTech(Integer id);

	@Query(value = "SELECT * FROM Question ORDER BY RANDOM()", nativeQuery = true)
	List<Question> getRandomQuestions();

	// Search by keyword in question text
	@Query("select q from Question q where lower(q.qname) like lower(concat('%', :keyword, '%'))")
	List<Question> searchByKeyword(@Param("keyword") String keyword);

	// Search + filter by subject
	@Query("select q from Question q where lower(q.qname) like lower(concat('%', :keyword, '%')) and q.techId.techId = :techId")
	List<Question> searchByKeywordAndTech(@Param("keyword") String keyword, @Param("techId") Integer techId);

	// Paginated all questions
	Page<Question> findAll(Pageable pageable);
}
