FROM eclipse-temurin:18-jdk-jammy

ARG JMETER_VERSION="5.6.3"
ARG CMDRUNNER_JAR_VERSION="2.2.1"
ARG JMETER_PLUGINS_MANAGER_VERSION="1.9"
ENV JMETER_HOME=/opt/apache-jmeter-${JMETER_VERSION}
ENV JMETER_BIN=${JMETER_HOME}/bin
ENV JMETER_LIB=${JMETER_HOME}/lib
ENV JMETER_EXT=${JMETER_HOME}/lib/ext
ENV JMETER_DOWNLOAD_URL=https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz
ENV PATH=$PATH:$JMETER_BIN
ENV JMETER_PLUGINS=jpgc-casutg,jpgc-dummy,jpgc-tst,jpgc-perfmon,jpgc-functions,jpgc-ffw,jpgc-casutg,jpgc-graphs-additional,jpgc-fifo

# Dependencies
RUN apt-get update && apt-get install -y curl unzip \
    && rm -rf /var/lib/apt/lists/*

# Install JMeter
RUN curl -L --silent ${JMETER_DOWNLOAD_URL} -o /tmp/apache-jmeter.tgz \
    && tar -xzf /tmp/apache-jmeter.tgz -C /opt \
    && rm -rf /tmp/apache-jmeter.tgz

# Install cmd_runner
WORKDIR ${JMETER_LIB}
RUN curl -L --silent https://repo1.maven.org/maven2/kg/apc/cmdrunner/${CMDRUNNER_JAR_VERSION}/cmdrunner-${CMDRUNNER_JAR_VERSION}.jar \
    -o ${JMETER_LIB}/cmdrunner-${CMDRUNNER_JAR_VERSION}.jar

# Install Plugins Manager
WORKDIR ${JMETER_EXT}
RUN curl -L --silent https://repo1.maven.org/maven2/kg/apc/jmeter-plugins-manager/${JMETER_PLUGINS_MANAGER_VERSION}/jmeter-plugins-manager-${JMETER_PLUGINS_MANAGER_VERSION}.jar \
    -o ${JMETER_EXT}/jmeter-plugins-manager.jar
RUN echo "Plugins to install: ${JMETER_PLUGINS}"

# Install Plugins
WORKDIR ${JMETER_LIB}
RUN java -jar ${JMETER_LIB}/cmdrunner-${CMDRUNNER_JAR_VERSION}.jar --tool org.jmeterplugins.repository.PluginManagerCMD install ${JMETER_PLUGINS}

# Create dirs
WORKDIR ${JMETER_HOME}
COPY entrypoint.sh /
RUN chmod a+x /entrypoint.sh
ENTRYPOINT ["bash", "-c", "while true; do echo 'Press [CTRL+C] to stop..'; sleep 60; done"]
