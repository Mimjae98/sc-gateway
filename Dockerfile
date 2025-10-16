################################################################################
# 1. 빌드 단계 (Build Stage)
################################################################################
FROM openjdk:17-jdk-slim AS build

WORKDIR /app

COPY gradlew ./
COPY gradle gradle
COPY build.gradle settings.gradle ./
COPY src src

RUN ./gradlew bootJar --no-daemon

################################################################################
# 2. 실행 단계 (Run Stage)
################################################################################
FROM openjdk:17-jdk-slim AS final

# 권한 없는 사용자로 실행
RUN groupadd -r spring && useradd -r -g spring spring
USER spring

WORKDIR /app

COPY --from=build /app/build/libs/*.jar app.jar

ENTRYPOINT ["java", "-jar", "/app/app.jar"]

