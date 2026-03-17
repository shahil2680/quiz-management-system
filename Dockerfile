# Stage 1: Build the application
FROM eclipse-temurin:17-jdk-alpine as builder
WORKDIR /app

# Install Maven
RUN apk add --no-cache maven

# Copy pom.xml
COPY pom.xml .

# Download dependencies (this caches them if pom.xml doesn't change)
RUN mvn dependency:go-offline -B

# Copy source code and build
COPY src src
RUN mvn package -DskipTests

# Stage 2: Run the application
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Copy the built WAR from the builder stage
COPY --from=builder /app/target/*.war app.war

# Expose port (Render automatically maps this if needed, but good practice)
EXPOSE 8085

# Set the command to run the application
ENTRYPOINT ["java", "-jar", "app.war"]
