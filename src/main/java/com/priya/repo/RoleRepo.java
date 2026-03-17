package com.priya.repo;


import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.priya.domain.Role;

public interface RoleRepo extends JpaRepository<Role, Long> {

	Role findByName(String s);
	
	
}
