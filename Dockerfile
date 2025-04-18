FROM tomcat:9.0

RUN rm -rf /usr/local/tomcat/webapps/*

COPY target/mario-game.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080 9073

CMD ["catalina.sh", "run"]
