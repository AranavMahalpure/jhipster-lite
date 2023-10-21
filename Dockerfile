FROM openjdk:17-slim AS build
RUN apt-get update && apt-get -y install git && apt-get clean
COPY . /code/jhipster-app/
WORKDIR /code/jhipster-app/
RUN rm -rf target node_modules
RUN chmod +x mvnw && ./mvnw package -B -DskipTests -Dmaven.javadoc.skip=true -Dmaven.source.skip
RUN mv /code/jhipster-app/target/*.jar /code/ && \
    rm -rf /code/*-tests.jar

FROM openjdk:17-slim
COPY --from=build /code/*.jar /code/
RUN \
    # configure the "jhipster" user
    groupadd jhipster && \
    useradd jhipster -s /bin/bash -m -g jhipster -G sudo && \
    echo 'jhipster:jhipster'|chpasswd
ENV SPRING_OUTPUT_ANSI_ENABLED=ALWAYS \
    JAVA_OPTS="" \
    SPRING_PROFILES_ACTIVE=cloud
USER jhipster
CMD java ${JAVA_OPTS} -Djava.security.egd=file:/dev/./urandom -jar /code/*.jar
EXPOSE 7471
