FROM openjdk:17-slim
COPY . /code/jhipster-app/
RUN \
    # configure the "jhipster" user
    groupadd jhipster && \
    useradd jhipster -s /bin/bash -m -g jhipster -G sudo && \
    echo 'jhipster:jhipster'|chpasswd && \
    # build project
    cd /code/jhipster-app/ && \
    rm -rf target node_modules && \
    chmod +x mvnw && \
    apt-get update && apt-get -y install git && apt-get clean && \
    ./mvnw package -DskipTests -Dmaven.javadoc.skip=true -Dmaven.source.skip && \
    # copy jar and clean unused files and folders
    mv /code/jhipster-app/target/*.jar /code/ && \
    rm -rf /code/*-javadoc.jar /code/*-sources.jar /code/*-tests.jar && \
    rm -rf /code/jhipster-app/ /root/.m2 /root/.cache /tmp/* /var/tmp/*
ENV SPRING_OUTPUT_ANSI_ENABLED=ALWAYS \
    JAVA_OPTS="" \
    SPRING_PROFILES_ACTIVE=cloud
USER jhipster
CMD java ${JAVA_OPTS} -Djava.security.egd=file:/dev/./urandom -jar /code/*.jar
EXPOSE 7471
