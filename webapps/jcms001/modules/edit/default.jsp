<%@ page import="com.trionic.jcms.*"%>
<%@ include file="../../lib/inc_dbconf.jsp"%>

<%!

    java.util.ArrayList getDirectoryPath(tDataSource ds, String anode)
    {
      java.util.ArrayList result = new java.util.ArrayList();
      String lparent = anode;
      java.util.HashMap ods = new java.util.HashMap();
      result.add(lparent);
      do
      {
        ods = ds.getDataSet("nodes", lparent);
        lparent = (String)ods.get("no_ref_parent");
        if (lparent == null) lparent = "0";
        result.add(lparent);
      } while (!lparent.equals("0"));
      return result;
    }

    String getDirectoryLevel(tDataSource ds,
       java.util.ArrayList dirpath,
       int level)
    {
        java.util.ArrayList list;
        String result = "";
        String indent = "";
        String lparent = "0";
        String anode = "0";

        for (int i = 0; i <= level; i++)
          indent = indent + "&nbsp;&nbsp;&nbsp;&nbsp;";

        lparent = (String)dirpath.get(dirpath.size() - level -1 );
        if (level < dirpath.size()-1)
          anode = (String)dirpath.get(dirpath.size() - level -2 );

        String query = "SELECT * FROM "+ds.getTableName("nodes")+
          " WHERE no_ref_parent='"+lparent+"' AND no_type='area' ORDER BY no_name";

        list = ds.getList(query);

        if (list.size()>0)
        {
          for (int i = 0; i < list.size(); i++)
          {
            java.util.HashMap entry = new java.util.HashMap();
            entry = (java.util.HashMap)list.get(i);
            result = result + (indent + "<a href=\"?m=edit/default&anode="+
              (String)entry.get("no_key")+"\">");
            if (anode.equals((String)entry.get("no_key")))
            {
              result = result + ("<b>");
              result = result + ("<img src=\"images/branch_minus.gif\" border=\"0\""+
                " align=\"absmiddle\">&nbsp;");
            }
            else
            {
              result = result + ("<img src=\"images/branch_plus.gif\" alt=\"\" border=\"0\""+
                " align=\"absmiddle\">&nbsp;");
            }
            result = result + ((String)entry.get("no_name")+"</a><br>");
            if (anode.equals((String)entry.get("no_key")))
              {
              result = result + ("</b>" +getDirectoryLevel(ds, dirpath, level+1) );
              }
          }
        }
        return result;
    }

%>
<table width="100%" border="0" cellspacing="1" cellpadding="3" bgcolor="#E3E3E3">
  <tr bgcolor="#C1C6CE">
    <td width="25%"><b>Site Structure</b></td>
    <td width="35%"><b>Dataset Entries</b></td>
    <td width="40%"><b>Properties</b></td>
  </tr>
  <tr bgcolor="#FFFFFF">
    <td valign="top"><%
    String anode = request.getParameter("anode");
    if (anode == null) anode = "0";
    String dnode = request.getParameter("dnode");
    if (dnode == null) dnode = "0";
    String treestr = "";
    java.util.HashMap cnode = new java.util.HashMap();
    tDataSource ds = new tDataSource(ConnectorStr);
    java.util.ArrayList dirpath = getDirectoryPath(ds, anode);

    int level = 0;

    treestr = "<a href=\"?m=edit/default&anode=0\"><b>"+
              "<img src=\"images/branch_minus.gif\" border=\"0\""+
              " align=\"absmiddle\">&nbsp;Site Root</a><br></b>";

    treestr = treestr + getDirectoryLevel(ds, dirpath, 0);


    out.print(treestr+"<br>");

    %>&nbsp;</td>
    <td valign="top"><%

    java.util.ArrayList dlist = new java.util.ArrayList();
    dlist = ds.getList("SELECT * FROM "+
       ds.getTableName("nodes")+" WHERE no_ref_parent='"+anode+"' AND "+
       " no_type='ds' ORDER BY no_xint");
    for (int i = 0; i<dlist.size(); i++)
    {
      java.util.HashMap dentry = new java.util.HashMap();
      dentry = (java.util.HashMap)dlist.get(i);
      if (dnode.equals((String)dentry.get("no_key")))
        out.print("<b>");
      out.print("<img src=\"images/dataset.png\" border=\"0\" align=\"absmiddle\">&nbsp;");
      out.print("<a href=\"?m=edit/default&anode="+anode+
        "&dnode="+(String)dentry.get("no_key")+"\">");
      out.print((String)dentry.get("no_name")+"<br> ");
      out.print("</a>");
      if (dnode.equals((String)dentry.get("no_key")))
        out.print("</b>");
    }

    %>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr bgcolor="#F0F0F0">
    <td>
    <input type="button" name="btn1" value="Create Area"
    OnClick="window.location='?m=edit/new_area&parent=<%
      out.print(anode);
    %>';" class="inputbutton">
    </td>
    <td>
    <input type="button" name="btn2" value="Create Dataset"
    OnClick="window.location='?m=edit/new_dataset&parent=<%
      out.print(anode);
    %>';" class="inputbutton">
    </td>
    <td>&nbsp;</td>
  </tr>
</table>