package com.priya.repo;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.priya.domain.Techno;

public interface TechnoRepo extends JpaRepository<Techno, Integer> {

	Techno findByTechName(String name);
	
	/*
	@Query("select count(t) from Techno t")
	public Integer countTech();
	*/
	
	@Query("select t.techName from Techno t")
	public List<String> getAllName();

	@Query("select t.techId from Techno t where t.techName=:name")
	public Integer getTechId(@Param("name")String name);
	
}
