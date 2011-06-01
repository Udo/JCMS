package com.trionic.jcms;

public class tDataSource
{
  private String db_connectorstring = "";
  private java.sql.Connection conn;
  public boolean isConnected = false;
  public String connectionError = "";
  public java.util.HashMap prefixes = new java.util.HashMap();
  public String appPrefix = "jcms_";

  public tDataSource(String constr)
  {
      prefixes.put("contentnodes", "cn");
      prefixes.put("dtd", "dt");
      prefixes.put("dtddata", "dd");
      prefixes.put("nodes", "no");
      prefixes.put("templates", "te");
      prefixes.put("users", "us");
      db_connectorstring = constr;
      try
      {
          Class.forName("com.mysql.jdbc.Driver").newInstance();
          conn = java.sql.DriverManager.getConnection(db_connectorstring);
          isConnected = true;
          connectionError = "connected 001";
      }
      catch (java.lang.Exception e)
      {
          connectionError = e.toString();
      }
  }

  public String getTableName(String identifier)
  {
    String result = appPrefix + identifier;
    return result;
  }

  public java.util.ArrayList getList(String query)
  {
      java.util.ArrayList result = new java.util.ArrayList();
      try
      {
          java.sql.Statement stmt = conn.createStatement(
                                          java.sql.ResultSet.TYPE_SCROLL_INSENSITIVE,
                                          java.sql.ResultSet.CONCUR_UPDATABLE);
          java.sql.ResultSet rs = stmt.executeQuery(query);

          java.sql.ResultSetMetaData rsmd = rs.getMetaData();
          int colCount = rsmd.getColumnCount();
          int rowCount = 0;
          boolean endReached;
          if (rs.first())
            do      //!rs.isLast() &&
            {
              endReached = false;
              rowCount = rowCount + 1;
              java.util.HashMap dataset = new java.util.HashMap();
              for (int i = 1; i <= colCount; i++)
              {
                dataset.put(
                  rsmd.getColumnName(i),
                  rs.getString(i)
                  );
              }
              dataset.put("rownumber", ""+rowCount);
              result.add(dataset);
              if (!rs.isLast())
                rs.next();
              else
                endReached = true;
            } while (!endReached);
        }
      catch (java.lang.Exception e)
      {
          connectionError = e.toString();
      }

      return result;
  }

  public java.util.HashMap getDataSetWithQuery(String query)
  {
      java.util.HashMap result = new java.util.HashMap();
      java.util.ArrayList arl = new java.util.ArrayList();

      arl = getList(query);
      if (arl.size()>0)
      {
        result = (java.util.HashMap)arl.get(0);
      }

      return result;
  }

  public java.util.HashMap getDataSet(String table, String keyfield)
  {
      java.util.HashMap result = new java.util.HashMap();
      java.util.ArrayList arl = new java.util.ArrayList();

      arl = getList("SELECT * FROM "+getTableName(table)+
        " WHERE "+prefixes.get(table)+"_key='"+keyfield+"'");
      if (arl.size()>0)
      {
        result = (java.util.HashMap)arl.get(0);
      }

      return result;
  }

  public String updateDataSet(String table, String keyfield, java.util.HashMap dataset)
  {
      String result = "";

      return result;
  }

  public String executeQuery(String query)
  {
      String result = "";
      try
      {
          java.sql.Statement stmt = conn.createStatement(
              java.sql.ResultSet.TYPE_SCROLL_INSENSITIVE,
              java.sql.ResultSet.CONCUR_UPDATABLE);
          stmt.executeUpdate(query);
      }
      catch (java.lang.Exception e)
      {
        result = e.toString();
      }
      return result;
  }

  public String executeStatement(String statement, java.util.ArrayList fields)
  {
      String result = "";
      try
      {
        java.sql.PreparedStatement ps =
          conn.prepareStatement(statement);
        for (int i = 1; i<= fields.size(); i++)
        {
          ps.setString(i, (String)fields.get(i-1));
        }
        ps.executeUpdate();
      }
      catch (java.lang.Exception e)
      {
        result = e.toString();
      }
      return result;
  }

  public String removeDataSet(String table, String keyfield)
  {
      String result = "";

      return result;
  }

}