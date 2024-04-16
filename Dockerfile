FROM openjdk:11
CMD ["sudo","./mvnw", "clean", "package"]
ARG JAR_FILE=demo/target/*.jar
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]