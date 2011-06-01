<%@ include file="_conf.jsp" %>
<%@ include file="_db_conf.jsp" %>
<%@ page import = "java.io.IOException" %>
<%@ page import = "java.io.PrintWriter" %>
<%@ page import = "javax.mail.Message" %>
<%@ page import = "javax.mail.Session" %>
<%@ page import = "javax.mail.Transport" %>
<%@ page import = "javax.mail.internet.InternetAddress" %>
<%@ page import = "javax.mail.internet.MimeMessage" %>
<%@ page import = "javax.naming.Context" %>
<%@ page import = "javax.naming.InitialContext" %>
<%@ page import = "javax.servlet.RequestDispatcher" %>
<%@ page import = "javax.servlet.ServletException" %>
<%@ page import = "javax.servlet.http.HttpServlet" %>
<%@ page import = "javax.servlet.http.HttpServletRequest" %>
<%@ page import = "javax.servlet.http.HttpServletResponse" %>
<%
//Variable declarations
String back1 = "#FFFFFF";
String back2 = "#EEEEEE";
int sw = 0;
String back = "";
String[] monate = new String[]
{        "Januar","Februar","M&auml;rz","April","Mai","Juni","Juli","August","September","Oktober","November","Dezember" };
String sw2 = "false";
String action = "";
String ID = "";
String mbmdnr = "";
String zielID = "";
String Query = "";
String MC = "";
String datum = "";
String datum1 = "";
String datum2 = "";
String datum3 = "";
String datum4 = "";
String datum5 = "";
String jahr = "";
String monat = "";
Integer Ijahr;
Integer Imonat;
Integer Itag;
int ijahr = 0;
int imonat = 0;
int itag = 0;
String kunde = "";
String query2 = "";
String fields = "";
String values = "";
String maker = "";
String messagetext = "";
String subject = "";
String content = "";
String auftragsnummer = "";
String from2 = "marco.scherer@trionic.de";
String to2 = "marco.scherer@trionic.de";
String cc2 = "marco.scherer@trionic.de";
String subject2, content2, mc2;
String b,c,d,e,f,masterID,auftragsnr,user,complete,fontcolor;
String aktmonat,aktjahr,akttag,maxjahr,maxmonat,minmonat,minjahr;
int iaktmonat,iaktjahr,imaxjahr,imaxmonat,imaxtag,iminmonat,iminjahr;
String j = request.getParameter("j");
String m = request.getParameter("m");
int folgemonat, folgejahr, vormonat, vorjahr;
java.sql.Statement stmt, stmt2, stmt3;
java.sql.ResultSet rs, rs2, rs3;
//Variables are imported
ID = request.getParameter("ID");
if (request.getParameter("action") != null)
action = request.getParameter("action");
//Creating the database connection
Class.forName(DATABASEDRIVER).newInstance();
java.sql.Connection conn;
String url = CONNECTOR+DATABASE;
java.sql.Connection con = java.sql.DriverManager.getConnection(url, USERNAME, PASSWORD);
%>
<%!
public class SendMailServlet extends HttpServlet {
public String error;
public void doPost(HttpServletRequest request,
HttpServletResponse response,
String from, String to, String cc, String subject, String content)
throws IOException, ServletException {
// Acquire request parameters we need
if ((from == null) || (to == null) ||
(subject == null) || (content == null)) {
RequestDispatcher rd =
getServletContext().getRequestDispatcher("sendmail.jsp");
rd.forward(request, response);
return;
  }
PrintWriter writer = response.getWriter();
response.setContentType("text/html");
try {
// Acquire our JavaMail session object
Context initCtx = new InitialContext();
Context envCtx = (Context) initCtx.lookup("java:comp/env");
Session session = (Session) envCtx.lookup("mail/Session");
// Prepare our mail message
Message message = new MimeMessage(session);
message.setFrom(new InternetAddress(from));
InternetAddress dests[] = new InternetAddress[]
{                    new InternetAddress(to) };
message.setRecipients(Message.RecipientType.TO, dests);
String temp;
InternetAddress dests2 = new InternetAddress();
StringTokenizer st = new StringTokenizer(cc);
while (st.hasMoreTokens()) {
dests2 = new InternetAddress(st.nextToken());
message.addRecipient(Message.RecipientType.CC, dests2);
  }
message.setSubject(subject);
message.setContent(content, "text/html");
// Send our mail message
Transport.send(message);
} catch (Throwable t) {
error = t.getMessage();
  }
  }
  }
%>
<%
//If selected action is "kill" delete ID from any table
if (action.length()>3 && action.substring(0,4).equals("kill")) {
String killID = action.substring(4,action.length());
Query = QUERY001402 + killID + ";";
stmt = con.createStatement();
rs = stmt.executeQuery(Query);
Query = QUERY001403 + killID + ";";
stmt = con.createStatement();
rs = stmt.executeQuery(Query);
Query = QUERY001404 + killID + ";";
stmt = con.createStatement();
rs = stmt.executeQuery(Query);
Query = QUERY001405 + killID + ";";
stmt = con.createStatement();
rs = stmt.executeQuery(Query);
Query = QUERY001406 + killID + ";";
stmt = con.createStatement();
rs = stmt.executeQuery(Query);
Query = QUERY001407 + killID + ";";
stmt = con.createStatement();
rs = stmt.executeQuery(Query);
Query = QUERY001408 + killID + ";";
stmt = con.createStatement();
rs = stmt.executeQuery(Query);
Query = QUERY001409 + killID + ";";
stmt = con.createStatement();
rs = stmt.executeQuery(Query);
Query = QUERY001410 + killID + ";";
stmt = con.createStatement();
rs = stmt.executeQuery(Query);
Query = QUERY001411 + killID + ";";
stmt = con.createStatement();
rs = stmt.executeQuery(Query);
action = "";
  }
//If selected action is "copy" copy ID to new entry
if (action.length()>3 && action.substring(0,4).equals("copy")) {
int i;
String copyID = action.substring(4,action.length());
//Select data from master table where ID = copyID
Query = QUERY001424 + copyID;
stmt = con.createStatement();
rs = stmt.executeQuery(Query);
rs.next();
b = rs.getString("B");
c = rs.getString("C");
d = rs.getString("D");
e = rs.getString("E");
f = rs.getString("F");
MC = rs.getString("MC");
auftragsnr = rs.getString("mbmdauftragsnummer");
datum = rs.getString("datum");
user = rs.getString("user");
complete = rs.getString("complete");
//Insert data as new entry in master table
Query = QUERY001425+b+"','"+c+"','"+d+"','"+e+"','"+f+"','"+auftragsnr+"','"+datum+"','"+user+"','"+complete+"','"+MC+"')";
stmt = con.createStatement();
stmt.executeQuery(Query);
//Get ID of new entry
stmt = con.createStatement();
rs = stmt.executeQuery(QUERY001426);
rs.next();
masterID = rs.getString("ID");
String TableArr [] = new String [10];
TableArr[0] = "kundenprofil";
TableArr[1] = "cauftrag";
TableArr[2] = "datenhandling";
TableArr[3] = "dauftrag";
TableArr[4] = "digitalprinting";
TableArr[5] = "postpress";
TableArr[6] = "prepress";
TableArr[7] = "press";
TableArr[8] = "prinect";
int felder = 0;
String fArr [] = new String[230];
for (i=0;i<8;i++) {
stmt = con.createStatement();
rs = stmt.executeQuery(QUERY001427 + TableArr[i]);
felder = 0;
fields = "";
values = "";
while (rs.next()) {
felder = felder + 1;
fArr[felder] = rs.getString("field");
  }
//Selecting and inserting data
Query = QUERY001420 + TableArr[i] + QUERY001421 + copyID;
stmt = con.createStatement();
rs = stmt.executeQuery(Query);
if (rs.next()) {
for (x=1;x<=felder;x++) {
if ( (!fArr[x].equals("ID")) && (!fArr[x].equals("master")) ) {
fields = fields + fArr[x] + ",";
values = values + "'" + rs.getString(fArr[x]) + "',";
  }
if (fArr[x].equals("master")) {
fields = fields + "master,";
values = values + masterID + ",";
   }
   }
fields = fields.substring(0,fields.length()-1);
values = values.substring(0,values.length()-1);
Query = QUERY001422 + TableArr[i] + "(" + fields + ")" + QUERY001423 + values + ")";
stmt = con.createStatement();
stmt.executeQuery(Query);
  }
}//for
action="";
}//end action copy
//If action is "save" set complete flag of ID to "true"
if (action.length()>3 && action.substring(0,4).equals("save")) {
//Set field "complete" to "true";
Query = QUERY001430 + ID;
stmt = con.createStatement();
stmt.executeQuery(Query);
//Get field "message" for email
Query = QUERY001424 + ID;
stmt = con.createStatement();
rs = stmt.executeQuery(Query);
rs.next();
messagetext = rs.getString("message");
//Get "FROM" email
Query = QUERY001432 + session.getAttribute("user") + "';";
stmt = con.createStatement();
rs = stmt.executeQuery(Query);
rs.next();
from2 = rs.getString("email");
mc2 = rs.getString("marketcenter");
if (from2.equals("")) {
from2="demofragebogen@wsp-design.de";
  }
to2="sven.bott@trionic.de";
//to2="thomas.linkenheil@heidelberg.com";
cc2="";
//Send EMail
SendMailServlet sms = new SendMailServlet();
sms.doPost(request,response,from2,to2,cc2,"1 Demofragebogen Auftragsnummer "+ID,messagetext);
out.print("ERROR["+sms.error+"]<br>");
//to2="bernhard.nahm@heidelberg.com";
cc2="";
//Send EMail
sms = new SendMailServlet();
sms.doPost(request,response,from2,to2,cc2,"2 Demofragebogen Auftragsnummer "+ID,messagetext);
//to2="mc.weber@wsp-design.de";
cc2="";
//Send EMail
sms = new SendMailServlet();
sms.doPost(request,response,from2,to2,cc2,"3 Demofragebogen Auftragsnummer "+ID,messagetext);
//to2="u.schroeter@wsp-design.de";
cc2="";
//Send EMail
sms = new SendMailServlet();
sms.doPost(request,response,from2,to2,cc2,"4 Demofragebogen Auftragsnummer "+ID,messagetext);
out.print("Request: "+request+"<br>");
out.print("Response: "+response+"<br>");
out.print("From: "+from2+"<br>");
out.print("To: "+to2+"<br>");
out.print("CC: "+cc2+"<br>");
out.print("Message: "+messagetext+"<br>");
}//action save
%>
<html>
<head>
<title>Demo-Fragebogen</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="fragebogen.css"></head>
<body bgcolor="#FFFFFF" text="#000000" link="#005E9D" vlink="#005E9D" topmargin=7 marginwidth=0 marginheight=0>
<table width="800" border="0" cellspacing="0" cellpadding="0">
<tr>
<td width="60" valign="top">
<table width="60" border="0" cellspacing="0" cellpadding="0" vspace="0" hspace="0">
<tr bgcolor="#f03f22" valign="bottom">
<td height="80">
<div align="center"><b><font size="7" color="#FFFFFF" face="Arial, Helvetica, sans-serif">O</font></b></div>
</td>
</tr>
</table>
</td>
<td width="703">
<% if (action.equals("ask")) {
Query = "SELECT mbmdauftragsnummer from master where id='"+ID+"';";
stmt = con.createStatement();
rs = stmt.executeQuery(Query);
rs.next();
auftragsnummer = rs.getString("mbmdauftragsnummer");
%>
<table width="700" border="0" cellpadding="0" cellspacing="0">
<tr>
<td height="95">&nbsp;
</td>
<td class="Text" height="95">
<br>
<br>
<b>Der Fragebogen mit der Auftragsnummer <%= auftragsnummer %> wurde nicht vollst&auml;ndig ausgef&uuml;llt.</b>
<br>
<br>
<br>
</td>
<td width="175" height="95">&nbsp;
</td>
</tr>
<tr>
<td width="100">&nbsp;
</td>
<td class="Text" valign="top">
<div>
<a href="index.jsp?page=Overview" target="_parent">Unvollst&auml;ndigen Fragebogen speichern</a>
<br><br>
<a href="index.jsp?page=Overview&action=kill<%= ID%>" target="_parent">Unvollst&auml;ndigen Fragebogen verwerfen</a>
<br><br>
</div>
</td>
<td>&nbsp;
</td>
</tr>
<tr>
<td>&nbsp;
</td>
<td>&nbsp;
</td>
<td>&nbsp;
</td>
</tr>
</table>
<%
 }
%>
<% if (action.equals("")) {
%>
<table width="700" border="0" cellpadding="0" cellspacing="0">
<tr>
<td height="95">&nbsp;
</td>
<td class="Text" height="95">
<div align="center"><br>
<br>
<b>Willkommen <%= session.getAttribute("user") %>.</b>
<br>
<br>
<br>
</div>
</td>
<td width="175" height="95">&nbsp;
</td>
</tr>
<tr>
<td width="240">&nbsp;
</td>
<td class="Text" valign="top">
<div>
<%
//Getting year and month of today
Date dt = new Date();
SimpleDateFormat df1 = new SimpleDateFormat( "MM" );
SimpleDateFormat df2 = new SimpleDateFormat( "yyyy" );
aktmonat = df1.format(dt);
aktjahr = df2.format(dt);
%>
<a href="index.jsp?page=Overview&action=show&ID=<%= ID %>&j=<%= aktjahr %>&m=<%= aktmonat %>" target="_parent"><img src="images/i_ansehen.gif" border=0 hspace=8 align=middle>Demo-Frageb&ouml;
gen anzeigen</a>
<br><br>
<a href="index.jsp" target="_parent"><img src="images/i_neu.gif" border=0 hspace=8 align=middle>Neuen Demo-Fragebogen anlegen</a>
<br><br><%
if (session.getAttribute("admin").equals("ja")) {
out.print("<a href=\"index.jsp?page=users\" target=\"_parent\"><img src=\"images/i_neu.gif\" border=0 hspace=8 align=middle>Mitarbeiter-Verwaltung</a>");
 }
%><br><br>
<br><br>
</div>
</td>
<td>&nbsp;
</td>
</tr>
<tr>
<td>&nbsp;
</td>
<td>&nbsp;
</td>
<td>&nbsp;
</td>
</tr>
</table>
<%
} //endif
if (action.equals("show")) {
%>
<table width="800" border="0" cellpadding="0" cellspacing="0">
<tr>
<td width="50">&nbsp;
</td>
<td class="Text" valign="top">
<div align="center">
<b>Demo-Frageb&ouml;
gen anzeigen</b>
<p><br>
<%
int ij = Integer.parseInt(j);
int im = Integer.parseInt(m);
//Get minimum possible date and actual as maximum
if (session.getAttribute("admin").equals("ja"))
Query = QUERY001412+session.getAttribute("MC")+"'"+QUERY001414;
else
Query = QUERY001401+session.getAttribute("user") + "'"+QUERY001414;
stmt = con.createStatement();
rs = stmt.executeQuery(Query);
if (rs.next()) {
minjahr = rs.getString("datum").substring(0,4);
iminjahr = Integer.parseInt(minjahr);
minmonat = rs.getString("datum").substring(5,7);
iminmonat = Integer.parseInt(minmonat);
//Getting year and month of today
Date dt = new Date();
SimpleDateFormat df1 = new SimpleDateFormat( "MM" );
SimpleDateFormat df2 = new SimpleDateFormat( "yyyy" );
SimpleDateFormat df3 = new SimpleDateFormat( "dd" );
aktmonat = df1.format(dt);
imaxmonat = Integer.parseInt(aktmonat);
aktjahr = df2.format(dt);
imaxjahr = Integer.parseInt(aktjahr);
akttag = df3.format(dt);
imaxtag = Integer.parseInt(akttag);
ijahr = (imaxjahr*365)+(imaxmonat*31)+imaxtag;
vormonat = im - 1;
vorjahr = ij;
if (vormonat == 0) {
vormonat = 12;
vorjahr = ij - 1;
  }
folgemonat = im + 1;
folgejahr = ij;
if (folgemonat == 13) {
folgemonat = 1;
folgejahr = ij + 1;
 }
out.print("<p><center>");
if ((iminjahr*12 + iminmonat) <= (vorjahr*12 + vormonat))
out.print ("<a href=\"index.jsp?page=Overview&action=show&ID="+ID+"&j="+vorjahr+"&m="+vormonat+"\" target=\"_parent\"><img src=\"images/i_left.gif\" border=0 alt=\""+monate[vormonat-1]+" "+vorjahr+"\"></a>");
out.print("&nbsp;&nbsp; "+monate[im-1]+" "+j+" &nbsp;&nbsp;");
if ((imaxjahr*12 + imaxmonat) >= (folgejahr*12 + folgemonat))
out.print ("<a href=\"index.jsp?page=Overview&action=show&ID="+ID+"&j="+folgejahr+"&m="+folgemonat+"\" target=\"_parent\"><img src=\"images/i_right.gif\" border=0 alt=\""+monate[folgemonat-1]+" "+folgejahr+"\"></a>");
out.print("</center><p><br>");
 }
%>
<%
if (session.getAttribute("admin").equals("ja"))
Query = QUERY001412 + session.getAttribute("MC")+"'"+QUERY001415+im+QUERY001416+ij+"'";
else
Query = QUERY001401 + session.getAttribute("user") + "'"+QUERY001415+im+QUERY001416+ij+"'";
//Executing the SQL query
stmt = con.createStatement();
rs = stmt.executeQuery(Query);
if (rs.next()) {
while (rs.next()) {
if (sw2.equals("false")) {
out.print("<table cellpadding=4 cellspacing=2 border=0>");
out.print("<tr><td class=\"text\" bgcolor=8DC2E6><b>AuftragsNr.</td>");
out.print("<td class=\"text\" align=center bgcolor=8DC2E6><b>Datum</td>");
out.print("<td class=\"text\" bgcolor=8DC2E6><b>Kunde</td>");
out.print("<td class=\"text\" bgcolor=8DC2E6><b>Benutzer</td>");
out.print("<td colspan=5 bgcolor=8DC2E6>&nbsp;</td></tr>");
sw2 = "true";
  }
mbmdnr = rs.getString("mbmdauftragsnummer");
zielID = rs.getString("ID");
complete = rs.getString("complete");
maker = rs.getString("user");
query2 = QUERY000502 + zielID;
stmt2 = con.createStatement();
rs2 = stmt2.executeQuery(query2);
while (rs2.next()) {
kunde = rs2.getString("firma");
datum1 = rs2.getString("datum01");
datum2 = rs2.getString("datum02");
datum3 = rs2.getString("datum03");
datum4 = rs2.getString("datum04");
datum5 = rs2.getString("datum05");
itag = 0;
if (datum1 != null) {
datum=datum1;
  }
if ((datum == null) || (datum.equals(""))) {
if (datum2 != null) {
datum=datum2;
  }
   }
if ((datum == null) || (datum.equals(""))) {
if (datum3 != null) {
datum=datum3;
  }
   }
if ((datum == null) || (datum.equals(""))) {
if (datum4 != null) {
datum=datum4;
   }
    }
if ((datum == null) || (datum.equals(""))) {
if (datum5 != null) {
datum=datum5;
  }
   }
if (datum1.length()==10) {
Ijahr = Integer.valueOf(datum1.substring(6,10));
Imonat = Integer.valueOf(datum1.substring(3,5));
Itag = Integer.valueOf(datum1.substring(0,2));
itag = (Ijahr.intValue()*365)+(Imonat.intValue()*31)+Itag.intValue();
datum=datum1;
  }
if (datum2.length()==10) {
Ijahr = Integer.valueOf(datum2.substring(6,10));
Imonat = Integer.valueOf(datum2.substring(3,5));
Itag = Integer.valueOf(datum2.substring(0,2));
imonat = (Ijahr.intValue()*365)+(Imonat.intValue()*31)+Itag.intValue();
if (itag == 0) {
itag=imonat;
  }
if (imonat<itag) {
itag=imonat;
datum=datum2;
  }
   }
if (datum3.length()==10) {
Ijahr = Integer.valueOf(datum3.substring(6,10));
Imonat = Integer.valueOf(datum3.substring(3,5));
Itag = Integer.valueOf(datum3.substring(0,2));
imonat = (Ijahr.intValue()*365)+(Imonat.intValue()*31)+Itag.intValue();
if (itag == 0) {
itag=imonat;
  }
if (imonat<itag) {
itag=imonat;
datum=datum3;
  }
   }
if (datum4.length()==10) {
Ijahr = Integer.valueOf(datum4.substring(6,10));
Imonat = Integer.valueOf(datum4.substring(3,5));
Itag = Integer.valueOf(datum4.substring(0,2));
imonat = (Ijahr.intValue()*365)+(Imonat.intValue()*31)+Itag.intValue();
if (itag == 0) {
itag=imonat;
  }
if (imonat<itag) {
itag=imonat;
datum=datum4;
  }
   }
if (datum5.length()==10) {
Ijahr = Integer.valueOf(datum5.substring(6,10));
Imonat = Integer.valueOf(datum5.substring(3,5));
Itag = Integer.valueOf(datum5.substring(0,2));
imonat = (Ijahr.intValue()*365)+(Imonat.intValue()*31)+Itag.intValue();
if (itag == 0) {
itag=imonat;
  }
if (imonat<itag) {
itag=imonat;
datum=datum5;
  }
   }
if (datum.length()==10) {
Ijahr = Integer.valueOf(datum.substring(6,10));
Imonat = Integer.valueOf(datum.substring(3,5));
Itag = Integer.valueOf(datum.substring(0,2));
imonat = (Ijahr.intValue()*365)+(Imonat.intValue()*31)+Itag.intValue();
itag = imonat-ijahr;
 }
//Switching Background Colors in Table
if (sw==0) {
sw=1;
back = back2;
} else {
sw=0;
back = back1;
   }
fontcolor = "000000";
if (complete.equals("false"))
fontcolor = "ff0000";
out.print("<tr><td bgcolor="+back+" class=\"text\"><font color=" + fontcolor + ">" + mbmdnr + "</td>");
out.print("<td bgcolor="+back+" class=\"text\">" + datum + "</td>");
out.print("<td bgcolor="+back+" class=\"text\">" + kunde + "</td>");
out.print("<td bgcolor="+back+" class=\"text\">" + maker + "</td>");
out.print("<td bgcolor="+back+" class=\"text\"><a href=\"index2.jsp?page=A1&ID="+zielID+"\" target=\"_parent\"><img src=\"images/i_ansehen.gif\" border=0 hspace=3 align=middle>Ansehen</a></td>");
if (((!session.getAttribute("admin").equals("ja")) && (itag>7)) || (session.getAttribute("admin").equals("ja"))) {
out.print("<td bgcolor="+back+" class=\"text\"><a href=\"index.jsp?page=A1&ID="+zielID+"\" target=\"_parent\"><img src=\"images/i_change.gif\" border=0 hspace=3 align=middle>Bearbeiten</a></td>");
} else {
out.print("<td bgcolor="+back+" class=\"text\"><div title=\"Der Fragebogen kann in der Woche vor der Demonstration nicht mehr bearbeitet werden. Setzen Sie sich gegebenenfalls mit Ihrem Administrator in Verbindung.\"><img src=\"images/i_barred.gif\" border=0 hspace=3 align=middle alt=\"Der Fragebogen kann in der Woche vor der Demonstration nicht mehr bearbeitet werden. Setzen Sie sich gegebenenfalls mit Ihrem Administrator in Verbindung.\">Gesperrt</div></td>");
   }
out.print("<td bgcolor="+back+" class=\"text\"><a href=\"index.jsp?page=Overview&action=copy"+zielID+"\" target=\"_parent\"><img src=\"images/i_copy.gif\" border=0 hspace=3 align=middle>Kopieren</a></td>");
out.print("<td bgcolor="+back+" class=\"text\"><a href=\"index.jsp?page=Overview&action=delete"+zielID+"\" target=\"_parent\"><img src=\"images/i_delete.gif\" border=0 hspace=3 align=middle>L&ouml;schen</a></td></tr>");
  }
   }
  }
if (sw2.equals("true"))
out.print("</table>");
else
out.print("<p><br><br><font color=f03f22><b>F&uuml;r diesen Monat liegen keine Eintr&auml;ge vor.</b></font>");
%>
<p><br><a href="index.jsp?page=Overview&ID=<%= ID %>" target="_parent">Zur&uuml;
ck</a>
</div>
</td>
<td>&nbsp;
</td>
</tr>
<tr>
<td>&nbsp;
</td>
<td>&nbsp;
</td>
<td>&nbsp;
</td>
</tr>
</table>
<%
} //endif
if (action.length()>5 && action.substring(0,6).equals("delete")) {
%>
<table width="700" border="0" cellpadding="0" cellspacing="0">
<tr>
<td width="100">&nbsp;
</td>
<td class="Text" valign="top">
<div align="center">
<b>Demo-Frageb&ouml;
gen l&ouml;
schen</b>
<p><br>
<%
String deleteID = action.substring(6,action.length());
out.print("Formularbogen mit <b>ID " + deleteID + "</b> wirklich l&ouml;schen?");
out.print("<p><a href=\"index.jsp?page=Overview&ID="+ID+"&action=kill"+deleteID+"\" target=\"_parent\">Ja, l&ouml;schen</a>");
%>
<p><br><a href="index.jsp?page=Overview&ID=<%= ID %>" target="_parent">Abbrechen</a>
</div>
</td>
<td>&nbsp;
</td>
</tr>
<tr>
<td>&nbsp;
</td>
<td>&nbsp;
</td>
<td>&nbsp;
</td>
</tr>
</table>
<%
} //endif "delete" %>
<table width="700" border="0" cellspacing="0" cellpadding="0">
<tr valign="top">
<td height="40"><br>
<br>
<br>
</td>
</tr>
</table>
<table width="700" border="0" cellspacing="0" cellpadding="0">
<tr>
<td>&nbsp;
</td>
</tr>
</table>
</td>
<td width="37" valign="top">&nbsp;
</td>
</tr>
</table>
</body>
</html>
