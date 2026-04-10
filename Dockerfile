FROM tomcat:9.0-jdk17-temurin

# Remove default ROOT app to avoid mixed content.
RUN rm -rf /usr/local/tomcat/webapps/ROOT/*

# Deploy this webapp as ROOT.
COPY . /usr/local/tomcat/webapps/ROOT/

EXPOSE 8080