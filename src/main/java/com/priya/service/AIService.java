package com.priya.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.*;

/**
 * AIService - Handles all interactions with the Google Gemini API.
 * Used for: AI Question Generation, Automated Subjective Grading.
 */
@Service
public class AIService {

    private static final Logger log = LoggerFactory.getLogger(AIService.class);

    @Value("${gemini.api.key:YOUR_GEMINI_API_KEY_HERE}")
    private String apiKey;

    private static final String GEMINI_URL =
            "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=";

    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper = new ObjectMapper();

    /**
     * Generates multiple-choice questions on a given topic using Gemini AI.
     * Returns list of maps, each with keys: question, optionA, optionB, optionC, optionD, correctAnswer
     */
    public List<Map<String, String>> generateMCQQuestions(String topic, String difficulty, int count) {
        String prompt = String.format(
                "Generate exactly %d multiple choice questions about \"%s\" at %s difficulty level. " +
                "Return ONLY a valid JSON array (no markdown, no extra text). Each element must have these EXACT fields: " +
                "\"question\", \"optionA\", \"optionB\", \"optionC\", \"optionD\", \"correctAnswer\". " +
                "The correctAnswer must be the EXACT TEXT of the correct option (e.g., 'Paris', not 'optionB'). " +
                "Example: [{\"question\":\"What is 2+2?\",\"optionA\":\"3\",\"optionB\":\"4\",\"optionC\":\"5\",\"optionD\":\"6\",\"correctAnswer\":\"4\"}]",
                count, topic, difficulty);

        try {
            String rawJson = callGemini(prompt);
            if (rawJson == null) return Collections.emptyList();

            // Parse the JSON array from the response
            JsonNode node = objectMapper.readTree(rawJson);
            List<Map<String, String>> result = new ArrayList<>();
            if (node.isArray()) {
                for (JsonNode item : node) {
                    Map<String, String> q = new HashMap<>();
                    q.put("question", item.path("question").asText());
                    q.put("optionA", item.path("optionA").asText());
                    q.put("optionB", item.path("optionB").asText());
                    q.put("optionC", item.path("optionC").asText());
                    q.put("optionD", item.path("optionD").asText());
                    q.put("correctAnswer", item.path("correctAnswer").asText());
                    result.add(q);
                }
            }
            log.info("Generated {} questions on topic: {}", result.size(), topic);
            return result;
        } catch (Exception e) {
            log.error("Error generating questions: {}", e.getMessage());
            return Collections.emptyList();
        }
    }

    /**
     * Grades a subjective student answer against a reference answer.
     * Returns a score from 0 to 100 representing the accuracy/similarity.
     */
    public int gradeSubjectiveAnswer(String studentAnswer, String referenceAnswer, String questionText) {
        if (studentAnswer == null || studentAnswer.trim().isEmpty()) return 0;

        String prompt = String.format(
                "You are a strict but fair professor. Grade this student answer strictly.\n" +
                "Question: \"%s\"\n" +
                "Reference Answer: \"%s\"\n" +
                "Student Answer: \"%s\"\n\n" +
                "Evaluate the student answer based on: correctness, completeness, and relevance. " +
                "Return ONLY a single integer score from 0 to 100 (no text, no explanation, just the number).",
                questionText, referenceAnswer, studentAnswer);

        try {
            String response = callGemini(prompt);
            if (response == null) return 0;
            // Extract just the number from response
            String cleaned = response.trim().replaceAll("[^0-9]", "");
            if (cleaned.isEmpty()) return 0;
            int score = Integer.parseInt(cleaned.substring(0, Math.min(cleaned.length(), 3)));
            return Math.min(Math.max(score, 0), 100); // Clamp to 0-100
        } catch (Exception e) {
            log.error("Error grading answer: {}", e.getMessage());
            return 0;
        }
    }

    /**
     * Core method to call the Gemini API and extract the text content from the response.
     */
    private String callGemini(String prompt) {
        if (apiKey == null || apiKey.trim().isEmpty() || apiKey.equals("YOUR_GEMINI_API_KEY_HERE")) {
            log.warn("Gemini API key not configured. Returning mock response.");
            return getMockResponse(prompt);
        }

        try {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.set("Accept", "application/json");

            // Build proper Gemini API request body
            String requestBody = String.format(
                    "{\"contents\":[{\"parts\":[{\"text\":%s}]}],\"generationConfig\":{\"temperature\":0.7,\"maxOutputTokens\":2048}}",
                    objectMapper.writeValueAsString(prompt));

            log.info("Calling Gemini API with key ending: ...{}", apiKey.length() > 6 ? apiKey.substring(apiKey.length() - 6) : "???");

            HttpEntity<String> entity = new HttpEntity<>(requestBody, headers);

            try {
                ResponseEntity<String> response = restTemplate.postForEntity(
                        GEMINI_URL + apiKey, entity, String.class);

                log.info("Gemini response status: {}", response.getStatusCode());

                if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                    log.debug("Gemini raw response: {}", response.getBody().substring(0, Math.min(200, response.getBody().length())));
                    JsonNode root = objectMapper.readTree(response.getBody());
                    JsonNode candidates = root.path("candidates");
                    if (candidates.isArray() && candidates.size() > 0) {
                        return candidates.get(0)
                                .path("content").path("parts").get(0)
                                .path("text").asText();
                    } else {
                        log.error("Gemini response had no candidates. Body: {}", response.getBody());
                    }
                }
            } catch (org.springframework.web.client.HttpClientErrorException e) {
                log.error("Gemini API HTTP error {}: {}", e.getStatusCode(), e.getResponseBodyAsString());
                // Fall through to return mock if API fails
            }
        } catch (Exception e) {
            log.error("Gemini API call failed: {}", e.getMessage(), e);
        }
        log.warn("Gemini call failed — using mock response as fallback.");
        return getMockResponse(prompt);
    }

    /**
     * Returns mock data when API key is not set, for demonstration/testing.
     */
    private String getMockResponse(String prompt) {
        if (prompt.contains("Generate exactly")) {
            return "[{\"question\":\"What is JVM?\",\"optionA\":\"Java Virtual Machine\",\"optionB\":\"Java Visual Module\",\"optionC\":\"Javascript Virtual Machine\",\"optionD\":\"Java Version Manager\",\"correctAnswer\":\"Java Virtual Machine\"}," +
                   "{\"question\":\"Which keyword is used for inheritance in Java?\",\"optionA\":\"implements\",\"optionB\":\"extends\",\"optionC\":\"inherits\",\"optionD\":\"super\",\"correctAnswer\":\"extends\"}," +
                   "{\"question\":\"What does OOP stand for?\",\"optionA\":\"Object Oriented Programming\",\"optionB\":\"Open Online Protocol\",\"optionC\":\"Object Offer Package\",\"optionD\":\"None\",\"correctAnswer\":\"Object Oriented Programming\"}]";
        }
        return "65"; // default grade for subjective answers
    }
}
