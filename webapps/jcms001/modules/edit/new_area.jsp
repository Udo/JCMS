<%@ page import="com.trionic.jcms.*"%>
<%@ include file="../../lib/inc_dbconf.jsp"%>
<br>
<br>
<br>
<%
  //
  if (request.getParameter("cmd") == null)
  {
%>
<table width="400" border="0" cellspacing="1" cellpadding="3" bgcolor="#E3E3E3" align="center">
  <tr bgcolor="#C1C6CE">
    <td><b>Create New Content Area</b></td>
  </tr>
  <form action="index.jsp" method="post">
  <input type="hidden" name="m" value="edit/new_area">
  <input type="hidden" name="cmd" value="create">
  <input type="hidden" name="parent" value="<%
    if (request.getParameter("parent")==null)
      { out.print("0"); }
    else
      { out.print(request.getParameter("parent")); }
  %>">
  <tr bgcolor="#FFFFFF">
    <td>
      <table width="100%" border="0">
        <tr>
          <td width="31%">&nbsp;</td>
          <td width="69%">&nbsp;</td>
        </tr>
        <tr>
          <td width="31%">Area Name</td>
          <td width="69%">
            <input type="text" name="area_name">
          </td>
        </tr>
        <tr>
          <td width="31%">&nbsp;</td>
          <td width="69%">
            <input type="submit" name="Submit" value="Create Area" class="inputbutton">
          </td>
        </tr>
        <tr>
          <td width="31%">&nbsp;</td>
          <td width="69%">&nbsp;</td>
        </tr>
      </table>
    </td>
  </tr>
  </form>
  <tr bgcolor="#F0F0F0">
    <td>&nbsp;</td>
  </tr>
</table>
<%
  }
  else
  {
    String areaname = request.getParameter("area_name");
    String parent = request.getParameter("parent");
    if (areaname == null || areaname.equals("")) areaname = "unnamed";
    out.print("Creating Area \""+areaname+"\"<br>Please wait...");

    tDataSource ds = new tDataSource(ConnectorStr);
    String error =
      ds.executeQuery("INSERT INTO "+ds.getTableName("nodes")+
        "(no_name,no_type,no_ref_parent) VALUES ('"+
        areaname+"','area','"+request.getParameter("parent")+"')");

    if (!error.equals(""))
        out.print("<h4>An error has occurred:<br>"+error+"</h4>");
    else
        out.print("<script>window.location='?m=edit/default&anode="+parent+"';</script>");
  }
%>