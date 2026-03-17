package com.priya.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;

import com.priya.domain.Role;
import com.priya.domain.Techno;
import com.priya.domain.User;
import com.priya.repo.RoleRepo;
import com.priya.repo.TechnoRepo;
import com.priya.repo.UserRepo;

@Component
public class DataSeeder implements CommandLineRunner {

    private static final Logger log = LoggerFactory.getLogger(DataSeeder.class);

    @Autowired
    private UserRepo userRepo;

    @Autowired
    private RoleRepo roleRepo;

    @Autowired
    private TechnoRepo technoRepo;

    @Autowired
    private BCryptPasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {
        log.info("Checking for database roles and mock users...");

        // Ensure roles exist
        Role studentRole = roleRepo.findByName("student");
        if (studentRole == null) {
            studentRole = new Role();
            studentRole.setName("student");
            studentRole = roleRepo.save(studentRole);
        }

        Role facultyRole = roleRepo.findByName("faculty");
        if (facultyRole == null) {
            facultyRole = new Role();
            facultyRole.setName("faculty");
            facultyRole = roleRepo.save(facultyRole);
        }

        Role adminRole = roleRepo.findByName("admin");
        if (adminRole == null) {
            adminRole = new Role();
            adminRole.setName("admin");
            adminRole = roleRepo.save(adminRole);
        }

        // Seed Students
        seedUser("alice.student@example.com", "Alice Smith", "password123", studentRole);
        seedUser("bob.student@example.com", "Bob Jones", "password123", studentRole);
        seedUser("charlie.student@example.com", "Charlie Brown", "password123", studentRole);
        seedUser("david.student@example.com", "David Lee", "password123", studentRole);
        seedUser("eve.student@example.com", "Eve Davis", "password123", studentRole);

        // Seed Faculty
        seedUser("prof.miller@example.com", "Dr. Miller", "faculty123", facultyRole);
        seedUser("prof.wilson@example.com", "Dr. Wilson", "faculty123", facultyRole);
        seedUser("prof.taylor@example.com", "Dr. Taylor", "faculty123", facultyRole);

        // Seed Admin if missing
        seedUser("admin@example.com", "Super Admin", "admin123", adminRole);

        // Seed Technologies
        seedTechnology("Core Java");
        seedTechnology("Spring Boot");
        seedTechnology("Python");
        seedTechnology("SQL Database");
        seedTechnology("Frontend (HTML/CSS)");

        log.info("Mock users and technologies checked and loaded.");
    }

    private void seedUser(String email, String username, String rawPassword, Role role) {
        if (userRepo.findByEmail(email) == null) {
            User user = new User();
            user.setEmail(email);
            user.setUsername(username);
            user.setPassword(passwordEncoder.encode(rawPassword));
            user.setRole_Entity(role);
            userRepo.save(user);
            log.info("Created mock {}: {} ({})", role.getName(), username, email);
        }
    }

    private void seedTechnology(String techName) {
        if (technoRepo.findByTechName(techName) == null) {
            Techno tech = new Techno();
            tech.setTechName(techName);
            technoRepo.save(tech);
            log.info("Seeded technology: {}", techName);
        }
    }
}
