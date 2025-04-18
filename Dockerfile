FROM tomcat:9.0

# Remove default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your WAR file
COPY target/mario-game-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

# Expose Tomcat's default port and your custom port
EXPOSE 8080 9073
