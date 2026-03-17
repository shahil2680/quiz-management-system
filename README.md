# Quiz Management System

A robust, full-stack Quiz Management System built with Java Spring Boot, designed to facilitate secure and efficient online examinations.

## 🚀 Key Features

*   **Role-Based Access Control**: Secure login and functionality separated for Students, Faculty, and Administrators.
*   **AI-Powered Question Generation**: Integration with the Google Gemini API to automatically generate relevant quiz questions based on topics.
*   **Comprehensive Assessment**: Faculty can create quizzes, add questions, and assign them to specific students or groups.
*   **Automated Evaluation & Analytics**: Instant result calculation and detailed analytics for both students and faculty to track performance.
*   **Secure Authentication**: Secure login mechanism, with password recovery via Email integration.

## 🛠️ Tech Stack

*   **Backend**: Java 17, Spring Boot 3.2, Spring Data JPA, Spring Security, Spring Mail
*   **Database**: PostgreSQL
*   **Frontend**: JSP (JavaServer Pages), JSTL, HTML/CSS
*   **Build Tool**: Maven

## ⚙️ Local Setup & Installation

### Prerequisites

*   Java Development Kit (JDK) 17
*   Maven 3.8+
*   PostgreSQL Server

### Steps

1.  **Clone the repository**
    ```bash
    git clone https://github.com/your-username/OnlineExamSystem.git
    cd OnlineExamSystem
    ```

2.  **Database Setup**
    *   Create a PostgreSQL database named `quizmgmt`.
    *   Ensure PostgreSQL is running on `localhost:5432`.

3.  **Environment Variables**
    For security, set the following environment variables before running the application. You can set these in your IDE run configuration or your OS environment.
    *   `DB_PASSWORD`: Your PostgreSQL password.
    *   `MAIL_USERNAME`: Email address for SMTP (password recovery).
    *   `MAIL_PASSWORD`: App password for theSMTP email address.
    *   `GEMINI_API_KEY`: Your Google Gemini API Key.

    *Note: The application provides fallback defaults for local testing, but it is highly recommended to override them.*

4.  **Build and Run**
    ```bash
    mvn clean install
    mvn spring-boot:run
    ```

5.  **Access the Application**
    Open your browser and navigate to `http://localhost:8085`.

## 📁 Architecture Overview

The system follows a standard MVC (Model-View-Controller) architecture:
*   **Domain Models (`/domain`)**: JPA Entities mapped to database tables (User, Quiz, Question, Result).
*   **Repositories (`/repo`)**: Interfaces extending `JpaRepository` for data access.
*   **Services (`/service`)**: Interfaces and Implementations containing the core business logic (e.g., `AIService` for Gemini integration).
*   **Controllers (`/control`)**: Spring MVC Controllers handling HTTP requests and model binding.
*   **Views (`/webapp/WEB-INF/views`)**: JSP files rendering the dynamic UI.

## 🛡️ Security Note

This project uses Spring Security for authentication and authorization. Sensitive data and API keys are read from environment variables to prevent exposure in version control.
