package com.priya.service;

import org.springframework.stereotype.Service;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.Random;

@Service
public class OtpService {

    // Store OTPs temporarily in memory. Format: <Email, OTP>
    // In a real application, consider using Redis or a DB with an expiry time.
    private final Map<String, String> otpStorage = new ConcurrentHashMap<>();

    // Store verified emails that are allowed to reset password. Format: <Email,
    // Boolean>
    private final Map<String, Boolean> verifiedEmails = new ConcurrentHashMap<>();

    public String generateOtp(String email) {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000); // 6-digit OTP
        String otpString = String.valueOf(otp);
        otpStorage.put(email, otpString);
        return otpString;
    }

    public boolean validateOtp(String email, String otp) {
        String storedOtp = otpStorage.get(email);
        if (storedOtp != null && storedOtp.equals(otp)) {
            otpStorage.remove(email); // Invalidate once used
            verifiedEmails.put(email, true); // Mark as verified for password reset
            return true;
        }
        return false;
    }

    public boolean isVerified(String email) {
        return verifiedEmails.getOrDefault(email, false);
    }

    public void clearVerification(String email) {
        verifiedEmails.remove(email);
    }
}
