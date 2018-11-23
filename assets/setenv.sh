#!/usr/bin/env bash

# Apache Tomcat - the servlet container running WebProtégé MUST be running in a JVM with file encoding set to UTF8
export CATALINA_OPTS="$CATALINA_OPTS -Dfile.encoding=UTF-8"
