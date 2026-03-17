package com.priya.service;

import java.util.List;

import com.priya.domain.UserDto;

import jakarta.servlet.http.HttpServletRequest;

public interface ServiceIntf {
	public String saveData(UserDto userDto);

	public String checkLoginService(UserDto dto, HttpServletRequest request);

	public List<UserDto> showAllStudentData(String roleName);

	public String removeOneData(Long id);

	public UserDto editData(Long id, String name);

	public void updateData(UserDto userDto);

	public String addUser(UserDto userDto);

	public Integer countStudent();

	public Integer countFaculty();

	public Integer countQuestions();
	// public Integer countTech();

	public boolean checkEmailExists(String email);

	public void updatePasswordByEmail(String email, String newPassword);
}
