
FROM openjdk:11
#ARG PROJECT_VERSION=0.1.0
ARG SPRING_PROFILES_ACTIVE=dev
ENV SPRING_PROFILES_ACTIVE=${SPRING_PROFILES_ACTIVE}
RUN mkdir -p /home/app
WORKDIR /home/app
#ENV SPRING_PROFILES_ACTIVE dev
#COPY product-service/ .
COPY target/product-service-v0.1.0.jar product-service.jar
EXPOSE 8500
ENTRYPOINT ["java","-Dspring.profiles.active=${SPRING_PROFILES_ACTIVE}", "-jar", "product-service.jar"]


