# Use the official Tomcat image
FROM tomcat:9.0

# Remove the default web app (optional)
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your WAR file into the Tomcat web apps directory
COPY target/mario-game.war /usr/local/tomcat/webapps/ROOT.war

# Expose Tomcat's default port (8080) and the custom port (9073)
EXPOSE 8080 9073

# Start Tomcat
CMD ["catalina.sh", "run"]
