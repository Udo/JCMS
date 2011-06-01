<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<%@ page import="com.heidelberg.common.gui.Translator"%>
<%@ page import="com.heidelberg.common.utils.ApplicationLocaleServiceIntf"%>
<%@ page import="com.heidelberg.common.profile.FWProfile"%>
<%@ page import="com.heidelberg.common.profile.FWProfiles"%>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="javax.mail.Message" %>
<%@ page import="javax.mail.Session" %>
<%@ page import="javax.mail.Transport" %>
<%@ page import="javax.mail.internet.InternetAddress" %>
<%@ page import="javax.mail.internet.MimeMessage" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.servlet.RequestDispatcher" %>
<%@ page import="javax.servlet.ServletException" %>
<%@ page import="javax.servlet.http.HttpServlet" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>
<%@ page import="com.heidelberg.demofragebogen.Dfbc"%>
<dsp:page>
<dsp:droplet name="/com/heidelberg/common/Renderer">
<% /* -----------------------------------------------------------------
      --    The following line includes the basic properties         --
      -----------------------------------------------------------------*/ %>
<dsp:param name="navConfig" value="/com/heidelberg/example/navigation/basic"/>
<dsp:param name="navConfig" value="/com/navigation/secondNav"/>
<dsp:param name="resources" value="/com/GUIResources"/>
<dsp:param name="queries" value="/com/DbBean"/>
<dsp:param name="breadCrumbKey" value=""/>
<dsp:param name="title" value=""/>
<dsp:oparam name="out">






<%
    //Variables are imported
      String action = "";
      String ID = "";
      String j = "2003";
      String m = "1";
      String aktjahr = "2003";
      String aktmonat = "1";
      
      ID = request.getParameter("ID");
      if (request.getParameter("action") != null) action = request.getParameter("action");
      if (request.getParameter("j ") != null) j = request.getParameter("j");
      if (request.getParameter("m") != null) m = request.getParameter("m");
      if (action==null) action="";
//      kontakt = new SMTPClient();

//      overview();

    //Get user name
      FWProfile user;
      user = FWProfiles.getCurrentProfile(request);
      String usr = user.getDisplayLogin();
      
    java.sql.ResultSet rslist, rslist2, rslist3;
    String dID = "";
    String downer = "";
    String downername = "";
    String dstatus = "";
    String ddatum = "";
    String dmc = "";
    String allowEdit = "";
    String sw3 = "false";
    String back = "";
    String back1 = " bgcolor=E2E9F4";
    String back2 = " bgcolor=C9D5E5";
    String query = "";
%>
<html>
<head>
<title>Demo-Fragebogen</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="fragebogen.css">
</head>
<body bgcolor="#FFFFFF" text="#000000" link="#005E9D" vlink="#005E9D" topmargin=7 marginwidth=0 marginheight=0>
<table width="500" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td width="60" valign="top"> 
            <table width="60" border="0" cellspacing="0" cellpadding="0" vspace="0" hspace="0">
                <tr valign="bottom"> 
                    <td height="80">&nbsp; </td>
                </tr>
            </table>
        </td>
        <td width="403"> 
<%
    if (action.equals(""))
    {
    %> 
            <table border="0" cellpadding="3" cellspacing="0">
                <tr> 
                    <td height="95" width=100>&nbsp;</td>
                    <td class="Text" height="95" width=300> 
                        <div align="center"><br>
                            <br>
                            <b><%=Translator.getString("DFBWelcome")%> <%=usr%></b> 
                            <br>
                            <br>
                            <br>
                        </div>
                    </td>
                </tr>
                <tr> 
                    <td>&nbsp;</td>
                    <td class="Text" valign="top"> 
                        <div> <a href="Overview.jsp?action=show&ID=<%= ID %>&j=<%= aktjahr %>&m=<%= aktmonat %>"><img src="images/i_ansehen.gif" border=0 hspace=8 align=middle><%=Translator.getString("DFBShowDFB")%></a> 
                            <br>
                            <br>
                            <a href="A1.jsp" target="_parent"><img src="images/i_neu.gif" border=0 hspace=8 align=middle><%=Translator.getString("DFBAddDFB")%></a> 
                            <br>
                            <br>
                            <br>
                            <%
                        rslist = Dfbc.getList(Dfbc.getQuery("QUERY000507")+usr+Dfbc.getQuery("QUERY000508"));
				                    if (rslist.next())
				                    {
			                         String userpos = rslist.getString("MC");
			                         if (userpos.equals("Coordinator")) 
			                         {
				                            out.print("<a href=\"backend/users.jsp\"><img src=\"images/i_neu.gif\" border=0 hspace=8 align=middle>"+Translator.getString("DFBUsers")+"</a><br><br>");
                                out.print("<a href=\"backend/edit_machines.jsp\"><img src=\"images/i_neu.gif\" border=0 hspace=8 align=middle>"+Translator.getString("DFBEditMachines")+"</a>");
                            }
		                      }                        
                    %> <br>
                            <br>
                            <br>
                            <br>
                        </div>
                    </td>
                </tr>
            </table>
            <%
    } //endif


if (action.equals("show"))
{

    String strmonat="";	
    int monat = 0;
    int jahrm = 0;
    String jahrmod = "";
	
    if (request.getParameter("jahrmod") != null && !jahrmod.equals("")) 
	{
		jahrmod=request.getParameter("jahrmod");
		Integer didnow = Integer.valueOf(jahrmod);
        jahrm = didnow.intValue();
    }
    
	if (request.getParameter("monat") != null) 
	{
		strmonat=request.getParameter("monat");
		Integer cidnow = Integer.valueOf(strmonat);
        monat = cidnow.intValue();
    }
    else
    {
	    monat = new Date().getMonth() + 1;
    }
	
	String mod = "";	
	int modint = 0;

	int jahr = new Date().getYear() + 1900 + jahrm;
	
	if (request.getParameter("mod") != null) {mod=request.getParameter("mod");}	

	if (mod != null && !mod.equals(""))
	{
		Integer idnow = Integer.valueOf(mod);
        modint = idnow.intValue();
	}
			
	monat=monat+modint;
	if (monat==0) 
	{
		monat=12;
		jahr=jahr-1;
		jahrm=jahrm-1;
		jahrmod = String.valueOf(jahrm);		
	}
	if (monat==13) 
	{
		monat=1;
		jahr=jahr+1;
		jahrm=jahrm+1;
		jahrmod = String.valueOf(jahrm);
	}
	
	String mmonat = String.valueOf(monat);
	String strjahr = String.valueOf(jahr);
	String monatsname = "";

	if (mmonat.length()==1) {mmonat = "0"+mmonat;}
	
	if (mmonat.equals("01")) {monatsname="Januar";}
	if (mmonat.equals("02")) {monatsname="Februar";}
	if (mmonat.equals("03")) {monatsname="M&auml;rz";}
	if (mmonat.equals("04")) {monatsname="April";}
	if (mmonat.equals("05")) {monatsname="Mai";}
	if (mmonat.equals("06")) {monatsname="Juni";}
	if (mmonat.equals("07")) {monatsname="Juli";}
	if (mmonat.equals("08")) {monatsname="August";}
	if (mmonat.equals("09")) {monatsname="September";}
	if (mmonat.equals("10")) {monatsname="Oktober";}
	if (mmonat.equals("11")) {monatsname="November";}
	if (mmonat.equals("12")) {monatsname="Dezember";}
	
    %> 
            <table border="0" cellpadding="0" cellspacing="0">
                <tr> 
                    <td class="Text" valign="top" width=600> <b><%=Translator.getString("DFBShowDFB")%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="Overview.jsp?action=show&mod=-1&monat=<%=monat%>&jahrmod=<%= jahrmod %>"><<<</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%= monatsname %> <%= jahr %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="Overview.jsp?action=show&mod=1&monat=<%=monat%>&jahrmod=<%= jahrmod %>">>>></a></b>
                        <p><br>
                        <TABLE width=600 border=0 cellpadding=4 cellspacing=0>
                            <TR> 
                                <TD class="Text" width=70><b><%=Translator.getString("DFBDate")%></b></TD>
                                <TD class="Text"><b><%=Translator.getString("DFBOwner")%></b></TD>
                                <TD class="Text"><b><%=Translator.getString("DFBStatus")%></b></TD>
                                <TD class="Text"><b>Marketcenter</b></TD>
                                <TD class="Text" align=center><%=Translator.getString("DFBView")%></TD>
                                <TD class="Text" align=center><%=Translator.getString("DFBDel")%></TD>
                                <TD class="Text" align=center><%=Translator.getString("DFBEdit")%></TD>
                                <TD class="Text" align=center><%=Translator.getString("DFBCopy")%></TD>
                                <TD class="Text" align=center><%=Translator.getString("DFBPrint")%></TD>
                            </TR>
                            <%
				                    //Get User ID
				                      rslist = Dfbc.getList(Dfbc.getQuery("QUERY000507")+usr+Dfbc.getQuery("QUERY000508"));
				                      if (rslist.next())
				                      {
					                         int userno = rslist.getInt("ID");
					                         String usernos = String.valueOf(userno);
					                         String userpos = rslist.getString("MC");
					                         String usermc = rslist.getString("MARKETCENTER");
					                         //Check user status and generate query
					                           if (userpos.equals("SSU")) query = Dfbc.getQuery("QUERY000510")+usernos+Dfbc.getQuery("QUERY000511");
					                           if (userpos.equals("Consultant")) query = Dfbc.getQuery("QUERY000510")+usernos+Dfbc.getQuery("QUERY000512")+usermc+Dfbc.getQuery("QUERY000513");
					                           if (userpos.equals("Coordinator")) query = Dfbc.getQuery("QUERY000514");

				                          //Get data
				                            rslist2 = Dfbc.getList(query);
				                            while (rslist2.next())
				                            {
				                                dstatus = "0";
				                                dmc = "";
					                               dID = rslist2.getString("FM_KEY").trim();
				                                downer = rslist2.getString("FM_OWNER");
				                                if (rslist2.getString("FM_STATUS")!=null) dstatus = rslist2.getString("FM_STATUS").trim();
				                                
				                                java.sql.Date idate = rslist2.getDate("FM_DATE");
				                                if (idate == null) ddatum = "nix";
				                                else ddatum = idate.toString();
				                                
				                                if (rslist2.getString("FM_MC")!=null) dmc = rslist2.getString("FM_MC").trim();
				                                
				                                //Get owner name
				                                  rslist3 = Dfbc.getList(Dfbc.getQuery("QUERY000520")+downer);
				                                  if (rslist3.next()) downername = rslist3.getString("BENUTZERNAME");
				                                
				                                allowEdit = "false";
				                                if (userpos.equals("SSU"))
				                                {
					                                   if (dstatus.equals("0")) allowEdit = "true";
				                                }
				                                if (userpos.equals("Consultant"))
				                                {
					                                   if (dmc.equals(usermc) && !dstatus.equals("2")) allowEdit = "true";		
				                                }
				                                if (userpos.equals("Coordinator"))
				                                {
					                                   allowEdit = "true";
				                                }
				                                
				                                if (sw3.equals("false"))
				                                {
					                                   sw3 = "true";
					                                   back = back2;
				                                }
				                                else
				                                {
					                                   sw3 = "false";
					                                   back = back1;
				                                }
				                                
				                                if (dstatus.equals("0")) dstatus = "SSU";
				                                if (dstatus.equals("1")) dstatus = "Consultant";
				                                if (dstatus.equals("2")) dstatus = "Coordinator";
				                                
				                                
				                                
				                                
				                                
				                                if (mmonat.equals(ddatum.substring(5,7)) && strjahr.equals(ddatum.substring(0,4)))
				                                {
				                                
				                                out.print("<TR"+back+">");
				                                out.print("    <TD>"+ddatum+"</TD>");
				                                out.print("    <TD>"+downername+"</TD>");
				                                out.print("    <TD>"+dstatus+"</TD>");
				                                out.print("    <TD align=center>"+dmc+"</TD>");
				                                out.print("    <TD align=center><a href=\"A1b.jsp?ID="+dID+"\"><img src=\"../img/view.gif\" border=0></a></TD>");
				                                if (allowEdit.equals("true")) 
				                                {
    				                                out.print("    <TD align=center><a href=\"backend/dfb_del.jsp?dID="+dID+"&ddate="+ddatum+"\"><img src=\"../img/trash_ico.gif\" border=0></a></TD>");
					                                out.print("    <TD align=center><a href=\"A1.jsp?ID="+dID+"\"><img src=\"../img/floppy.gif\" border=0></a></TD>");
    				                                out.print("    <TD align=center><a href=\"backend/dfb_copy.jsp?dID="+dID+"\"><img src=\"../img/copy.gif\" border=0></a></TD>");
    				                            }
				                                else
				                                {
					                                   out.print("    <TD>&nbsp;</TD>");
					                                   out.print("    <TD>&nbsp;</TD>");
					                                   out.print("    <TD>&nbsp;</TD>");
				                                }
				                                out.print("    <TD align=center><a href=\"printview3.jsp?ID="+dID+"\" target=\"_blank\"><img src=\"../img/print.gif\" border=0></a></TD>");
				                                out.print("</TR>");
				                                
			                                    }
				                            }
				                      }
				                %> 
                        </TABLE>
                    </td>
                </tr>
            </table>
            <p><br>
            <table width="500" border="0" cellpadding="0" cellspacing="0">
                <tr> 
                    <td width="50">&nbsp;</td>
                    <td class="Text" valign="top"> 
																				<%
																				    if (j != null && m != null && !j.equals("") && !m.equals(""))
																				    {
																				        int ij = Integer.parseInt(j);
																				        int im = Integer.parseInt(m);

																				        //Read Kundenprofil
																				          Dfbc.con = com.heidelberg.common.connector.db.ConnectionPool.getConnection();
																				          Dfbc.stmt = Dfbc.con.createStatement();
																				          Dfbc.rs = Dfbc.stmt.executeQuery(Dfbc.getQuery("QUERY000504"));
																				            //rs = Dfbc.getList("SELECT * FROM DFB_FORMMASTER;");
																				          //rs = stmt.executeQuery("SELECT * FROM DFB_MASTER, DFB_KUNDENPROFIL");
																				          while (Dfbc.rs.next())
																				          {
																				              if (Dfbc.sw2.equals("false"))
																				              {
																				                  out.print("<table border=3>");
																				                  out.print("<tr><td align=left><a title='' coords='' href='index.jsp?page=Overview&action=show&kk=01&ID=&j=");
																				                  if (Integer.parseInt(m)==1)
																				                  {
																				                      m="13";
																				                      j=Integer.toString((Integer.parseInt(j)-1));
																				                  }
																				                  out.print(j);
																				                  out.print("&m=");
																				                  if (Integer.parseInt(m)-1 < 10) out.print("0"+Integer.toString(Integer.parseInt(m)-1));
																				                  else out.print(Integer.toString(Integer.parseInt(m)-1));
																				                  out.print("'  target='_parent'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<<<&nbsp;&nbsp;&nbsp;&nbsp;</a></td><td><font color='ff0000'  size='-1' >");
																				                  if (Integer.parseInt(m)==13)
																				                  {
																				                      m="01";
																				                      j=Integer.toString((Integer.parseInt(j)+1));
																				                  }
																				                  out.print(Dfbc.monate[Integer.parseInt(m)-1]);
																				                  out.print("  "+j);
																				                  out.print("</font><td align=left><a title='' coords='' href='index.jsp?page=Overview&action=show&kk=02&ID=&j=");
																				                  if (Integer.parseInt(m)==12 && Dfbc.kk.equals("02"))
																				                  {
																				                      m="0";
																				                      j=Integer.toString((Integer.parseInt(j)+1));
																				                  }
																				                  out.print(j);
																				                  out.print("&m=");
																				                  if (Integer.parseInt(m)+1 < 10) out.print("0"+Integer.toString(Integer.parseInt(m)+1));
																				                  else out.print(Integer.toString(Integer.parseInt(m)+1));

																				                  out.print("'  target='_parent'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;>>></a></td></tr>");
																				                  out.print("</table><br>");
																				                  out.print("<table cellpadding=4 cellspacing=2 border=2>");
																				                  out.print("<tr><td class=\"text\" bgcolor=8DC2E6><b>AuftragsNr.</td>");
																				                  out.print("<td class=\"text\" align=center bgcolor=8DC2E6><b>Datum</td>");
																				                  out.print("<td class=\"text\" bgcolor=8DC2E6><b>Kunde</td>");
																				                  out.print("<td class=\"text\" bgcolor=8DC2E6><b>Benutzer</td>");
																				                  out.print("<td colspan=5 bgcolor=8DC2E6>&nbsp;</td></tr>");
																				                  Dfbc.sw2="true";
																				              }
																				              String kunde  = Dfbc.rs.getString("firma");
																				              String datum1 = Dfbc.rs.getString("datum01");
																				              String datum2 = Dfbc.rs.getString("datum02");
																				              String datum3 = Dfbc.rs.getString("datum03");
																				              String datum4 = Dfbc.rs.getString("datum04");
																				              String datum5 = Dfbc.rs.getString("datum05");
																				              String master = Dfbc.rs.getString("master");
																				              String zielID = Dfbc.rs.getString("ID");
																				              String mbmdnr = Dfbc.rs.getString("mbmdauftragsnummer");
																				              String maker =  Dfbc.rs.getString("benutzer");
																				              if (datum1 != null && (!datum1.equals("null")) && (datum1.length()==10))
																				              {
																				                  Dfbc.sort_dat[0]=Integer.parseInt(datum1.substring(6,10)+datum1.substring(3,5)+datum1.substring(0,2));
																				                  Dfbc.dat_anzahl++;
																				              }
																				              if (datum2 != null && (!datum2.equals("null")) && (datum2.length()==10))
																				              {
																				                  Dfbc.sort_dat[1]=Integer.parseInt(datum2.substring(6,10)+datum2.substring(3,5)+datum2.substring(0,2));
																				                  Dfbc.dat_anzahl++;
																				              }
																				              if (datum3 != null && (!datum3.equals("null")) && (datum3.length()==10))
																				              {
																				                  Dfbc.sort_dat[2]=Integer.parseInt(datum3.substring(6,10)+datum3.substring(3,5)+datum3.substring(0,2));
																				                  Dfbc.dat_anzahl++;
																				              }
																				              if (datum4 != null && (!datum4.equals("null")) && (datum4.length()==10))
																				              {
																				                  Dfbc.sort_dat[3]=Integer.parseInt(datum4.substring(6,10)+datum4.substring(3,5)+datum4.substring(0,2));
																				                  Dfbc.dat_anzahl++;
																				              }
																				              if (datum5 != null && (!datum5.equals("null")) && (datum5.length()==10))
																				              {
																				                  Dfbc.sort_dat[4]=Integer.parseInt(datum5.substring(6,10)+datum5.substring(3,5)+datum5.substring(0,2));
																				                  Dfbc.dat_anzahl++;
																				              }
																				              while (Dfbc.i_dat < Dfbc.dat_anzahl)     // looking for min Dat
																				              {
																				                  if (Dfbc.sort_dat[Dfbc.i_dat] <  Dfbc.dat_min) Dfbc.dat_min = Dfbc.sort_dat[Dfbc.i_dat];
																				                  Dfbc.i_dat++;
																				              }
																				              String dat_min_str =Integer.toString(Dfbc.dat_min);
																				              Dfbc.jahr_min=dat_min_str.substring(0,4);
																				              Dfbc.monat_min=dat_min_str.substring(4,6);
																				              if ( Dfbc.jahr_min.equals(j) && Dfbc.monat_min.equals(m) )    // show line
																				              {
																				                  Dfbc.merkmal="true";
																				                  
																				                  //Switching Background Colors in Table
																				                    if (Dfbc.sw==0)
																				                    {
																				                        Dfbc.sw=1;
																				                        back = back2;
																				                    }
																				                    else
																				                    {
																				                        Dfbc.sw=0;
																				                        back = back1;
																				                    }
																				                    
																				                  Dfbc.fontcolor = "000000";
																				                  if (Dfbc.complete.equals("false")) Dfbc.fontcolor = "ff0000";
																				                  Dfbc.fontcolor = "ff0000";
																				                  out.print("<tr><td bgcolor="+back+" class=\"text\"><font color=" + Dfbc.fontcolor + ">" + mbmdnr + "</td>");
																				                  String dat_min_str_tmp=dat_min_str.substring(6,8)+"."+dat_min_str.substring(4,6)+"."+dat_min_str.substring(0,4);
																				                  out.print("<td bgcolor="+back+" class=\"text\">" + dat_min_str_tmp + "</td>");
																				                  String datum="";
																				                  out.print("<td bgcolor="+back+" class=\"text\">" + kunde + "</td>");
																				                  out.print("<td bgcolor="+back+" class=\"text\">" + maker + "</td>");
																				                  out.print("<td bgcolor="+back+" class=\"text\"><a href=\"index2.jsp?page=A1&ID="+zielID+"\"target=\"_parent\"><img src=\"images/i_ansehen.gif\"border=0 hspace=3 align=middle>Ansehen</a></td>");

																				                  if (((!session.getAttribute("admin").equals("ja")) && (Dfbc.itag>7)) || (session.getAttribute("admin").equals("ja")))
																				                  {
																				                      out.print("<td bgcolor="+back+" class=\"text\"><a href=\"index.jsp?page=A1&ID="+zielID+"\"target=\"_parent\"><img src=\"images/i_change.gif\" border=0 hspace=3 align=middle>Bearbeiten</a></td>");
																				                  }
																				                  else
																				                  {
																				                      out.print("<td bgcolor="+back+" class=\"text\"><div title=\"Der Fragebogen kann in der Woche vor der Demonstration nicht mehr bearbeitet werden. Setzen Sie sich gegebenenfalls mit Ihrem Administrator in Verbindung.\"><img src=\"images/i_barred.gif\" border=0 hspace=3 align=middle alt=\"Der Fragebogen kann in der Woche vor der Demonstration nicht mehr bearbeitet werden. Setzen Sie sich gegebenenfalls mit Ihrem Administrator in Verbindung.\">Gesperrt</div></td>");
																				                  }
																				                  out.print("<td bgcolor="+back+" class=\"text\"><a href=\"index.jsp?page=Overview&action=copy"+zielID+"&j="+j+"&m="+m+"\"target=\"_parent\"><img src=\"images/i_copy.gif\" border=0 hspace=3 align=middle>Kopieren</a></td>");
																				                  out.print("<td bgcolor="+back+" class=\"text\"><a href=\"index.jsp?page=Overview&action=delete"+zielID+"&j="+j+"&m="+m+"\"target=\"_parent\"><img src=\"images/i_delete.gif\" border=0 hspace=3 align=middle>L&ouml;schen</a></td></tr>");
																				              }
																				              Dfbc.i_dat=0;
																				              Dfbc.dat_anzahl=0;
																				              Dfbc.dat_min= 99999999;
																				          }
																				          Dfbc.con.close();

																				          if (Dfbc.merkmal.equals("true")) out.print("</table>");
																				          else
																				          {
																				              //out.print("<p><br><br><font color=f03f22><b>F&uuml;r diesen Monat liegen keine Eintr&auml;ge vor.</b></font>");
																				          }
																				    }
																				%>                 
                    </td>
                    <td>&nbsp; </td>
                </tr>
                <tr> 
                    <td>&nbsp; </td>
                    <td>&nbsp; </td>
                    <td>&nbsp; </td>
                </tr>
            </table>
            <%
} 


if (action.length()>5 && action.substring(0,6).equals("delete")) 
{
%> 
            <table width="400" border="0" cellpadding="0" cellspacing="0">
                <tr> 
                    <td width="100">&nbsp; </td>
                    <td class="Text" valign="top"> 
                        <div align="center"> <b>Demo-Frageb&ouml;gen l&ouml;schen 
                            </b> 
                            <p><br>
                                <%
                                    String deleteID = action.substring(6,action.length());
                                    out.print("Formularbogen mit <b>ID " + deleteID + "</b> wirklich l&ouml;schen?");
                                    out.print("<p><a href=\"index.jsp?page=Overview&ID="+ID+"&action=kill"+deleteID+"&j="+j+"&m="+m+"\" target=\"_parent\">Ja, l&ouml;schen</a>");
                                 %> 
                            <p><br>
                                <a href="index.jsp?page=Overview&ID=<%= ID %>&j=<%= j %>&m=<%= m %>&action=show" target="_parent">Abbrechen</a> 
                        </div>
                    </td>
                    <td>&nbsp; </td>
                </tr>
                <tr> 
                    <td>&nbsp; </td>
                    <td>&nbsp; </td>
                    <td>&nbsp; </td>
                </tr>
            </table>
            <%
} 
%> </td>
    </tr>
</table>
</body>
</html>



</dsp:oparam>
</dsp:droplet>
</dsp:page>