package com.priya.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.priya.domain.Role;
import com.priya.domain.RoleDto;
import com.priya.domain.User;
import com.priya.domain.UserDto;
import com.priya.repo.QuestionRepo;
import com.priya.repo.RoleRepo;
import com.priya.repo.TechnoRepo;
import com.priya.repo.UserRepo;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ServiceImpl implements ServiceIntf {

	private static final Logger log = LoggerFactory.getLogger(ServiceImpl.class);

	@Autowired
	private UserRepo userRepo;

	@Autowired
	private org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder passwordEncoder;

	@Autowired
	private RoleRepo roleRepo;

	@Autowired
	private QuestionRepo qns;

	@Autowired
	private TechnoRepo TechRepo;

	@Transactional
	public String addUser(UserDto userDto) {
		// Role rolEntity = roleRepo.findById(1L).get();

		User dto = new User();
		log.info("Adding user in admin: {}", userDto.getRole());
		// here i am catching role object by ()
		Role role = roleRepo.findByName(userDto.getRole());

		BeanUtils.copyProperties(userDto, dto);
		dto.setPassword(passwordEncoder.encode(userDto.getPassword()));
		dto.setRole_Entity(role);
		User user = userRepo.save(dto);

		if (user.getId() != null) {
			return "Regester successful";
		} else {
			return "Unable to Regester";
		}
	}

	@Transactional
	public String saveData(UserDto userDto) {

		User dto = new User();

		String roleName = userDto.getRole() != null ? userDto.getRole().toLowerCase() : "student";
		Role roleEntity = roleRepo.findByName(roleName);

		if (roleEntity == null) {
			throw new RuntimeException(
					"Role '" + roleName + "' not found in database. Please seed the roleAuth table.");
		}
		// here i am catching role object by ()

		BeanUtils.copyProperties(userDto, dto);
		dto.setPassword(passwordEncoder.encode(userDto.getPassword()));
		dto.setRole_Entity(roleEntity);
		User user = userRepo.save(dto);

		if (user.getId() != null) {
			return "Regester successful";
		} else {
			return "Unable to Regester";
		}
	}

	public String checkLoginService(UserDto dto, HttpServletRequest request) {

		String roleName = null;

		String redirect = "LoginPage";
		// Getting
		HttpSession session = request.getSession();

		User user = userRepo.findByEmail(dto.getEmail());
		if (user == null || !passwordEncoder.matches(dto.getPassword(), user.getPassword())) {
			request.setAttribute("error", "Invalid email or password");
			return "LoginPage";
		}
		Role role = user.getRole_Entity();
		roleName = role.getName();

		// Ensure that the role selected on the frontend login matches the DB
		if (dto.getRole() != null && !dto.getRole().equalsIgnoreCase("Any")
				&& !roleName.equalsIgnoreCase(dto.getRole())) {
			request.setAttribute("error", "This account is registered as " + roleName + ", not " + dto.getRole() + ".");
			return "LoginPage";
		}
		if (roleName.equalsIgnoreCase("student")) {
			session.setAttribute("role", "Student");
			session.setAttribute("userEmail", user.getEmail());
			redirect = "redirect:Student";
		}

		if (roleName.equalsIgnoreCase("faculty")) {
			session.setAttribute("role", "Faculty");
			session.setAttribute("userEmail", user.getEmail());
			redirect = "redirect:Faculty";
		}

		if (roleName.equalsIgnoreCase("admin")) {
			session.setAttribute("role", "Admin");
			session.setAttribute("userEmail", user.getEmail());
			redirect = "redirect:Admin";
		}
		return redirect;

	}

	public List<UserDto> showAllStudentData(String roleName) {
		Role roleObject = roleRepo.findByName(roleName);

		List<User> studentList = userRepo.getAllRoleByObject(roleObject);

		List<UserDto> studentDtoList = new ArrayList<>();

		for (User user : studentList) {
			UserDto userDto = new UserDto();
			BeanUtils.copyProperties(user, userDto);
			roleObject = user.getRole_Entity();

			RoleDto roleDto = new RoleDto();

			BeanUtils.copyProperties(roleObject, roleDto);

			userDto.setRole_Entity(roleDto);
			studentDtoList.add(userDto);
		}

		return studentDtoList;

	}

	@Transactional
	public String removeOneData(Long id) {
		User user = userRepo.findById(id).orElseThrow(() -> new RuntimeException("User with ID " + id + " not found"));
		Role role = user.getRole_Entity();
		String name = role.getName();

		userRepo.deleteById(id);

		return name;
	}

	public UserDto editData(Long id, String name) {
		/*
		 * User user=new User(); BeanUtils.copyProperties(userDto, user);
		 */

		User oneUser = userRepo.findById(id)
				.orElseThrow(() -> new RuntimeException("User with ID " + id + " not found"));

		Role role = roleRepo.findByName(name);

		UserDto userDto = new UserDto();

		RoleDto roleD = new RoleDto();
		roleD.setName(role.getName());
		roleD.setRole_id(role.getRole_id());

		userDto.setRole_Entity(roleD);

		BeanUtils.copyProperties(oneUser, userDto);
		return userDto;
	}

	@Transactional
	public void updateData(UserDto userDto) {
		User user = new User();
		BeanUtils.copyProperties(userDto, user);

		Role role = roleRepo.findByName(userDto.getRole());
		user.setRole_Entity(role);

		// User oneUser=userRepo.findById(user.getId()).get();
		userRepo.save(user);

		// return ""; ALL SET

	}

	public Integer countStudent() {
		Integer countStd = userRepo.countUserByRoleName("student");

		return countStd;
	}

	public Integer countFaculty() {
		Integer countStaff = userRepo.countUserByRoleName("faculty");

		return countStaff;
	}

	public Integer countQuestions() {
		Integer count = qns.countQuestion();
		return count;
	}

	/*
	 * public Integer countTech()
	 * {
	 * Integer tech=TechRepo.countTech();
	 * return tech;
	 * }
	 */

	public boolean checkEmailExists(String email) {
		return userRepo.findByEmail(email) != null;
	}

	@Transactional
	public void updatePasswordByEmail(String email, String newPassword) {
		User user = userRepo.findByEmail(email);
		if (user != null) {
			user.setPassword(passwordEncoder.encode(newPassword));
			userRepo.save(user);
			log.info("Password successfully updated securely for user {}", email);
		}
	}

}
