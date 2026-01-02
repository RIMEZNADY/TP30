FROM eclipse-temurin:17-jdk

WORKDIR /app

COPY target/*.jar app.jar

EXPOSE 8282

ENTRYPOINT ["java", "-jar", "app.jar", "--server.port=8282"]
