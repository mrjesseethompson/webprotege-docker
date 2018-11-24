# reference https://github.com/protegeproject/webprotege/wiki/WebProt%C3%A9g%C3%A9-3.0.0-Installation
FROM tomcat:9-jre8-alpine
LABEL maintainer="Jesse Thompson <mr.jesse.e.thompson@gmail.com>"

# Apache Tomcat configuration
# The servlet container MUST be running in a JVM with file encoding set to UTF8
COPY ./assets/setenv.sh /usr/local/tomcat/bin/setenv.sh
RUN chmod 700 /usr/local/tomcat/bin/setenv.sh

# Create the data and logs directories for WebProtégé
RUN mkdir -p /srv/webprotege \
    && mkdir -p /var/log/webprotege

# Create and include configuration files
# https://github.com/protegeproject/webprotege/blob/master/webprotege-server-core/src/main/resources/webprotege.properties
COPY ./assets/webprotege.properties /etc/webprotege/webprotege.properties
# https://github.com/protegeproject/webprotege/blob/master/webprotege-server-core/src/main/resources/mail.properties
COPY ./assets/mail.properties /etc/webprotege/mail.properties

# Download WebProtégé and install to Tomcat webapps folder
ENV WEBPROTEGE_VERSION="3.0.0"
WORKDIR /usr/local/tomcat/webapps
RUN rm -rf -- * \
    && wget -q -O webprotege.war https://github.com/protegeproject/webprotege/releases/download/v${WEBPROTEGE_VERSION}/webprotege-${WEBPROTEGE_VERSION}.war \
    && mkdir ROOT \
    && unzip -q webprotege.war -d ROOT \
    && rm webprotege.war

# Download and install the WebProtégé cli
RUN mkdir -p /usr/local/webprotege/bin \
    && wget -q -O /usr/local/webprotege/bin/webprotege-cli.jar https://github.com/protegeproject/webprotege/releases/download/v${WEBPROTEGE_VERSION}/webprotege-${WEBPROTEGE_VERSION}-cli.jar \
    && chmod 700  /usr/local/webprotege/bin/webprotege-cli.jar

# Persist data, configuration, and log folders as volumes
VOLUME /srv/webprotege
VOLUME /etc/webprotege
VOLUME /var/log/webprotege
EXPOSE 8080

CMD ["catalina.sh", "run"]
