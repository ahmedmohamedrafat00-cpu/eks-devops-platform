# ----------- Build Stage -----------
FROM eclipse-temurin:17-jdk-alpine AS build
WORKDIR /app

# Copy Maven wrapper and pom
COPY mvnw pom.xml ./
COPY .mvn/ .mvn/

RUN chmod +x mvnw

# Cache dependencies
RUN ./mvnw dependency:go-offline

# Copy source
COPY src/ src/

# Build jar
RUN ./mvnw package -DskipTests

# ----------- Run Stage -----------
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
