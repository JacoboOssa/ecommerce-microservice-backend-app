
FROM openjdk:11
#ARG PROJECT_VERSION=0.1.0
RUN mkdir -p /home/app
WORKDIR /home/app
#ENV SPRING_PROFILES_ACTIVE dev
#COPY user-service/ .
COPY target/user-service-v0.1.0.jar user-service.jar
EXPOSE 8700
ENTRYPOINT ["java", "-jar", "user-service.jar"]


