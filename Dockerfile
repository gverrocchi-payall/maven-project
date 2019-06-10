FROM tomcat:8-jdk8-slim

ADD ./webapp/target/*.war /usr/local/tomcat/webapps

# port within the container
EXPOSE 8080 

CMD ['catalina.sh' , 'run']