package com.priya.config;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;

import com.priya.domain.User;
import com.priya.repo.UserRepo;

@Component
public class PasswordMigrationRunner implements CommandLineRunner {

    private static final Logger log = LoggerFactory.getLogger(PasswordMigrationRunner.class);

    @Autowired
    private UserRepo userRepo;

    @Autowired
    private BCryptPasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {
        log.info("Checking for plaintext passwords to migrate to BCrypt...");
        List<User> users = userRepo.findAll();
        int migratedCount = 0;

        for (User user : users) {
            String pass = user.getPassword();
            // Check if password exists and is not already a BCrypt hash
            // BCrypt hashes typically start with $2a$, $2b$, or $2y$ and are 60 characters
            // long
            if (pass != null && !pass.startsWith("$2a$") && !pass.startsWith("$2b$") && !pass.startsWith("$2y$")) {
                log.info("Migrating password for user: {}", user.getEmail());
                user.setPassword(passwordEncoder.encode(pass));
                userRepo.save(user);
                migratedCount++;
            }
        }

        if (migratedCount > 0) {
            log.info("Successfully migrated {} plaintext passwords to BCrypt.", migratedCount);
        } else {
            log.info("No plaintext passwords found. Database is up to date.");
        }
    }
}
