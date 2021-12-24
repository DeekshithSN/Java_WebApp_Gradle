FROM tomcat:8
WORKDIR webapps 
COPY build/libs/test.war .

