<%@ page import="com.trionic.jcms.*"%>
<%@ include file="../../lib/inc_dbconf.jsp"%>
<br>
<br>
<br>
<%
  //
  String parent = request.getParameter("parent");
  if (request.getParameter("cmd") == null)
  {
     tDataSource ds = new tDataSource(ConnectorStr);
     java.util.HashMap masternode = new java.util.HashMap();
     masternode = ds.getDataSet("nodes", parent);
     if (parent.equals("0"))
       masternode.put("no_name", "Site Root");
     java.util.ArrayList list = ds.getList("SELECT no_key FROM "+
       ds.getTableName("nodes")+" WHERE no_ref_parent='"+parent+"' AND "+
       " no_type='ds'");
%>
<table width="450" border="0" cellspacing="1" cellpadding="3" bgcolor="#E3E3E3" align="center">
  <tr bgcolor="#C1C6CE">
    <td><b>Create New Dataset in "<i><%
    out.print((String)masternode.get("no_name")); %></i>"</b></td>
  </tr>
  <form action="index.jsp" method="post" name="createdoc">
  <input type="hidden" name="m" value="edit/new_dataset">
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
          <td width="31%" valign="top">Dataset Name</td>
          <td width="69%" nowrap>
            <input type="text" name="ds_name">
            <input type="button" name="btn2" value="&lt; Create Start Page"
              OnClick="document.createdoc.ds_name.value='default';
              document.createdoc.ds_pri.value='0';">
          </td>
        </tr>
        <tr>
          <td width="31%">Priority</td>
          <td width="69%" nowrap>
            <input type="text" name="ds_pri" value="<%= list.size()*10 %>">
            <input type="button" name="btn2" value="&lt; Automatic Priority"
              OnClick="document.createdoc.ds_pri.value='<%= list.size()*10 %>';">
          </td>
        </tr>
        <tr>
          <td width="31%">Dataset Type</td>
          <td width="69%">
            <input type="text" name="ds_type">
          </td>
        </tr>
        <tr>
          <td width="31%">&nbsp;</td>
          <td width="69%">      <br>
            <input type="submit" name="Submit" value="Create Dataset" class="inputbutton">
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
    String areaname = request.getParameter("ds_name");
    if (areaname == null || areaname.equals("")) areaname = "unnamed";
    String priority = request.getParameter("ds_pri");
    if (priority == null || priority.equals("")) priority = "0";
    out.print("Creating Dataset \""+areaname+"\"<br>Please wait...");

    tDataSource ds = new tDataSource(ConnectorStr);
    String error =
      ds.executeQuery("INSERT INTO "+ds.getTableName("nodes")+
        "(no_name,no_type,no_ref_parent,no_xint) VALUES ('"+
        areaname+"','ds','"+request.getParameter("parent")+"',"+
        "'"+priority+"')");

    if (!error.equals(""))
        out.print("<h4>An error has occurred:<br>"+error+"</h4>");
    else
        out.print("<script>window.location='?m=edit/default&anode="+parent+"';</script>");
  }
%>