
FROM openjdk:11
#ARG PROJECT_VERSION=0.1.0
RUN mkdir -p /home/app
WORKDIR /home/app
ARG SPRING_PROFILES_ACTIVE=dev
ENV SPRING_PROFILES_ACTIVE=${SPRING_PROFILES_ACTIVE}
#ENV SPRING_PROFILES_ACTIVE dev
#COPY shipping-service/ .
COPY target/shipping-service-v0.1.0.jar shipping-service.jar
EXPOSE 8600
ENTRYPOINT ["java", "-Dspring.profiles.active=${SPRING_PROFILES_ACTIVE}", "-jar", "shipping-service.jar"]


