killall java -9
cd /opt/jakarta/tomcat/webapps/jcms001/WEB-INF/classes/com/trionic/jcms/
javac tDataSource.java
/etc/init.d/tomcat restart