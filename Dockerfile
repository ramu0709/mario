# Use the official Tomcat base image
FROM tomcat:9.0.104-jdk17

# Set environment variables for Tomcat
ENV CATALINA_HOME /usr/local/tomcat
ENV CATALINA_BASE /usr/local/tomcat

# Remove the default web apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the WAR file into the container and rename it to ROOT.war
COPY target/ROOT.war /usr/local/tomcat/webapps/

# Expose Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
