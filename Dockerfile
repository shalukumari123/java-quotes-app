# ---------- Stage 1: Build ----------
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# Copy pom.xml and download dependencies first (cache layer)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code and build
COPY src ./src
COPY quotes.txt ./   # include your resource file
RUN mvn clean package -DskipTests

# ---------- Stage 2: Runtime ----------
FROM eclipse-temurin:17-jre AS runtime

WORKDIR /app

# Copy the built jar from Stage 1
COPY --from=build /app/target/java-quotes-app-1.0.0.jar app.jar
COPY --from=build /app/quotes.txt ./quotes.txt

EXPOSE 8000

CMD ["java", "-jar", "app.jar"]
