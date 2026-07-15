# Build stage
FROM eclipse-temurin:17-jdk-alpine AS builder

WORKDIR /app

# Copy project files
COPY demo/gradle gradle
COPY demo/gradlew .
COPY demo/gradlew.bat .
COPY demo/build.gradle.kts .
COPY demo/settings.gradle.kts .
COPY demo/src src

# Make gradle executable
RUN chmod +x gradlew

# Build the application
RUN ./gradlew build -x test --no-daemon -Dorg.gradle.jvmargs="-Xmx512m"

# Runtime stage
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copy the jar from builder
COPY --from=builder /app/build/libs/*.jar app.jar

# Create non-root user for security
RUN addgroup -S appuser && adduser -S appuser -G appuser
USER appuser

# Expose port (Render assigns PORT dynamically)
EXPOSE 8080

# Set environment variables for Render
ENV PORT=8080
ENV JAVA_OPTS="-Xmx512m"

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1

# Run the application
CMD ["sh", "-c", "java ${JAVA_OPTS} -jar app.jar"]
