# Use the official Tomcat image as the base image
FROM tomcat:9-jdk11-openjdk

# Copy the ROOT.war file to the correct location in the Tomcat container
COPY target/ROOT.war /opt/tomcat/webapps/ROOT.war

# Expose the port that Tomcat will run on
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
