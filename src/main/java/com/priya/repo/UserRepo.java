package com.priya.repo;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.priya.domain.Role;
import com.priya.domain.User;

public interface UserRepo extends JpaRepository<User, Long> {

	User findByEmail(String email);

	@Query("select u.role_Entity from User u where u.email=:email AND u.password=:password")
	public Role findRoleByEmail(@Param("email") String email, @Param("password") String password);

	@Query("select u from User u where u.role_Entity.role_id=:id")
	public List<User> getAllStudentByRoleId(@Param("id") Long id);

	// @Query("select u from User u where u.role_Entity.role_id=2")
	// public List<User> getAllFaculty();

	@Query("select u from User u where u.role_Entity=:entity")
	public List<User> getAllRoleByObject(@Param("entity") Role role);

	// public List<User> findByFacultyName

	@Query("SELECT COUNT(u) FROM User u WHERE u.role_Entity.role_id = :roleId")
	public Integer countUser(@Param("roleId") Integer roleId);

	@Query("SELECT COUNT(u) FROM User u WHERE u.role_Entity.name = :roleName")
	public Integer countUserByRoleName(@Param("roleName") String roleName);

	@Query("select password from User u WHERE u.email=:email")
	public String findPass(@Param("email") String email);

}
