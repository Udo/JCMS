<%
  String ConnectorStr =
    "jdbc:mysql://"+getServletContext().getInitParameter("mysql_server")+
    "/"+getServletContext().getInitParameter("mysql_database")+
    "?user="+getServletContext().getInitParameter("mysql_user")+
    "&password="+getServletContext().getInitParameter("mysql_password");

%>