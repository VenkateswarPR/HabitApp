FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /build

COPY pom.xml .
RUN mvn -B dependency:go-offline

COPY src ./src
RUN mvn -B clean package -DskipTests

FROM eclipse-temurin:21-jre-alpine

RUN addgroup -S app && adduser -S -G app -u 10001 app

WORKDIR /app

COPY --from=build --chown=app:app /build/target/habit-tracker.jar app.jar

USER 10001:10001

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
