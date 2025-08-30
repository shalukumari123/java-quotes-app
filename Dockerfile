# ---------- Stage 1: Build ----------
FROM eclipse-temurin:17-jdk-alpine AS build

WORKDIR /app

# Copy source code and resources
COPY src/Main.java /app/
COPY quotes.txt /app/

# Compile Java source
RUN javac Main.java

# ---------- Stage 2: Runtime ----------
FROM eclipse-temurin:17-jre-alpine   # ✅ lightweight runtime only

WORKDIR /app

# Copy only compiled classes + resources from build stage
COPY --from=build /app/Main.class /app/
COPY --from=build /app/quotes.txt /app/

# Expose port for HTTP server
EXPOSE 8000

# Run the Java application
CMD ["java", "Main"]
