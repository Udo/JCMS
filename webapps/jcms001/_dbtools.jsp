<%

class DfbDataHandler
{

    String DATABASEDRIVER = "oracle.jdbc.driver.OracleDriver";
    String CONNECTOR = "jdbc:oracle:thin:@riesensokur:1521:orcl";
    String USERNAME = "system";
    String PASSWORD = "manager";
    String fieldlog = "";
    boolean isFileBased = false;

    private java.sql.Connection sqlcon;

    public DfbDataHandler()
    {
        // init stuff
    }

    protected String readFile(String filename)
    {
        String result = "";
        try
        {
            FileReader fr     = new
                FileReader(filename);
            BufferedReader br = new BufferedReader(fr);
            String record = new String();
            while ((record = br.readLine()) != null) {
                result = result + " " +record;
            }
        } catch (IOException ee) {
            // catch possible io errors from readLine()
            result = ee.toString();
        }
        return result;
    }

    protected void writeFile(String filename, String content)
    {
        String result = "";
        try
        {
            FileWriter fw     = new FileWriter(filename);
            BufferedWriter bw = new BufferedWriter(fw);
            bw.write(content,0,content.length());
            bw.close();
        } catch (IOException ee) {
            // catch possible io errors from readLine()
            result = ee.toString();
        }
    }

    public String urlencode(String raw)
    {
        return java.net.URLEncoder.encode(raw);
    }

    public String urldecode(String raw)
    {
        return java.net.URLDecoder.decode(raw);
    }

    protected String HashMapToString(HashMap fieldcontent)
    {
        String result = "";
        ByteArrayOutputStream bufout = new ByteArrayOutputStream();
        java.beans.XMLEncoder XMLEnc = new java.beans.XMLEncoder(bufout);
        XMLEnc.writeObject(fieldcontent);
        XMLEnc.close();
        result = new String(bufout.toByteArray());
        return result;
    }

    protected oracle.sql.BLOB HashMapToBlob(HashMap fieldcontent, oracle.sql.BLOB blob) throws SQLException
    {
        ByteArrayOutputStream bufout = new ByteArrayOutputStream();
        java.beans.XMLEncoder XMLEnc = new java.beans.XMLEncoder(bufout);
        XMLEnc.writeObject(fieldcontent);
        XMLEnc.close();
        //blob.setBytes(0,  bufout.toByteArray());
        blob.putBytes(1, bufout.toByteArray());
        return blob;
    }

    protected HashMap BlobToHashMap(java.sql.Blob blob) throws SQLException
    {
        HashMap result = new HashMap();
        try
        {
            ByteArrayInputStream bufin = new ByteArrayInputStream(
                    blob.getBytes((long)1, (int)blob.length()));

            java.beans.XMLDecoder XMLDec = new java.beans.XMLDecoder(bufin);

            result = (HashMap)XMLDec.readObject();

            //if (result == null) result = new HashMap();
            String str = result.toString();

        }
        catch (java.util.NoSuchElementException nse)
        {
            result.put("Error", nse.toString());
        }
        return result;
    }

    protected HashMap StringToHashMap(String raw)
    {
        HashMap result = new HashMap();
        try
        {
            if (raw != null)
                {
                ByteArrayInputStream bufin = new ByteArrayInputStream(raw.getBytes());

                java.beans.XMLDecoder XMLDec = new java.beans.XMLDecoder(bufin);

                result = (HashMap)XMLDec.readObject();

                if (result == null) result = new HashMap();
        }}
        catch (java.util.NoSuchElementException nse)
        {

        }
        return result;
    }

    protected HashMap LoadHashMap(String filename)
    {
        HashMap result = new HashMap();
        try
        {
            java.beans.XMLDecoder XMLDec = new java.beans.XMLDecoder(
                    new BufferedInputStream(
                        new FileInputStream(filename)));

            result = (HashMap)XMLDec.readObject();

            if (result == null) result = new HashMap();
        }
        catch (java.io.FileNotFoundException nse)
        {

        }
        return result;
    }

    public String getOrderID()
    {
        java.util.Random rnd = new java.util.Random();
        return rnd.nextInt(1000)+""+rnd.nextInt(1000);
    }

    public HashMap getFormFromRequest(HttpServletRequest request, HashMap formdata)
    {
        String fieldlist = request.getParameter("fieldlist");
        String part;
        String content;

        StringTokenizer st = new StringTokenizer(fieldlist, ",");
        while (st.hasMoreTokens())
        {
            part = st.nextToken();
            content = request.getParameter(part);
            if (content == null) content = "";
            formdata.put(part, content);
        }

        return formdata;
    }

    private Date StringToDate(String raw)
    {
      Date result = new Date();

      SimpleDateFormat sdf = new SimpleDateFormat("dd.mm.yyyy");

      try
      {
          result = sdf.parse(raw);
      } catch (java.text.ParseException e)
      {
          result = new Date();
      }

      return result;
    }

    private Date getEarliestStart(HashMap dataset)
    {
      Date result = new Date();
      Date tmp = new Date();

      tmp = StringToDate(getField(dataset, "DATUM01"));
      if (result.compareTo(tmp) > 0) result = tmp;

      tmp = StringToDate(getField(dataset, "DATUM02"));
      if (result.compareTo(tmp) > 0) result = tmp;

      tmp = StringToDate(getField(dataset, "DATUM03"));
      if (result.compareTo(tmp) > 0) result = tmp;

      tmp = StringToDate(getField(dataset, "DATUM04"));
      if (result.compareTo(tmp) > 0) result = tmp;

      return result;
    }

    private String getLeadingZero(int nr)
    {
      String result = "";

      result = nr+"";
      if (result.length()==1) result = "0" +result;

      return result;
    }

    public String SaveDataset(String table, String keyfield, String key, HashMap dataset)
    {
        java.sql.Statement stmt;
        java.sql.ResultSet rs;
        java.sql.ResultSetMetaData rsmeta;
        int colcount;
        String result = "";
        String query = "";
        String query2 = "";

        try
        {
            java.sql.Connection sqlcon =
                java.sql.DriverManager.getConnection(CONNECTOR, USERNAME, PASSWORD);
            sqlcon.setAutoCommit(false);
            try
            {
                stmt = sqlcon.createStatement(java.sql.ResultSet.TYPE_SCROLL_INSENSITIVE,
                        java.sql.ResultSet.CONCUR_UPDATABLE);
                if (key=="")
                    {
                    java.util.Random rnd = new java.util.Random();
                    key = rnd.nextInt(1000)+"."+rnd.nextInt(1000)+"."+
                        rnd.nextInt(1000)+"."+rnd.nextInt(1000);
                    query =
                        "INSERT INTO "+table+" ("+keyfield+",FM_FORMDATA) VALUES('"+
                        key+"',empty_blob())";
                    stmt.executeUpdate(query);
                }
                query = "SELECT "+table+".* FROM "+table+" WHERE "+keyfield+"='"+key+"' for update";
                rs = stmt.executeQuery(query);
                rs.first();

                try
                  {rs.updateInt("FM_OWNER", Integer.parseInt(getField(dataset, "FM_OWNER")));}
                catch (java.lang.NumberFormatException e)
                  {rs.updateInt("FM_OWNER", 0);}

                rs.updateString("FM_MC", getField(dataset, "MC"));
                //rs.updateDate("FM_DATE", new java.sql.Date(getEarliestStart(dataset).getTime()));
                //rs.updateDate("FM_DATE", new java.sql.Date((long)237486));

                java.util.Date startdate = getEarliestStart(dataset);
                String datestr = "";
                datestr =
                  getLeadingZero(startdate.getDate())+"."+
                  getLeadingZero(startdate.getMonth()+1)+"."+
                  (startdate.getYear()+1900);

                dataset.put("FM_DATE", datestr);

                ((oracle.jdbc.driver.OracleResultSet)rs).updateDate("FM_DATE",
                    new java.sql.Date(getEarliestStart(dataset).getTime()));

                oracle.sql.BLOB blob;
                blob = ((oracle.jdbc.driver.OracleResultSet)rs).getBLOB("FM_FORMDATA");

                blob = HashMapToBlob(dataset, blob);
                ((oracle.jdbc.driver.OracleResultSet)rs).updateBLOB("FM_FORMDATA", blob);

                stmt.executeUpdate("commit");

                query = "UPDATE DFB_FORMMASTER "+
                    "SET FM_DATE=TO_DATE('" +datestr+ "', 'dd.mm.yyyy') " +
                    "WHERE "+keyfield+"='"+key+"'";

                dataset.put("QUERY", query);

                stmt.executeQuery(query);    

                sqlcon.close();

            }
            catch (java.sql.SQLException e)
            {
                key = e.toString()+"//"+query;
                e.printStackTrace();
            }

        }
        catch (java.sql.SQLException e)
        {
            key = e.toString();
        }

        return key;
    }

    //public void SaveSubDataset(String parentkey, String dsname, HashMap dataset)
    public void SaveSubDataset(String dsname, HashMap dataset, HashMap masterdataset)
    {
        masterdataset.put("SUBDS_"+dsname, dataset);
        /*
        java.sql.Statement stmt;
        java.sql.ResultSet rs;
        java.sql.ResultSetMetaData rsmeta;
        int colcount;
        String result = "";
        String query = "";
        String query2 = "";

        try
        {
            java.sql.Connection sqlcon =
                java.sql.DriverManager.getConnection(CONNECTOR, USERNAME, PASSWORD);
            sqlcon.setAutoCommit(false);
            try
            {
                stmt = sqlcon.createStatement(java.sql.ResultSet.TYPE_SCROLL_INSENSITIVE,
                        java.sql.ResultSet.CONCUR_UPDATABLE);

                query = "SELECT DFB_FORMORDER.* FROM DFB_FORMORDER WHERE "+
                    "FO_REFMASTER='"+parentkey+"' AND FO_KEY='"+dsname+"' for update";

                rs = stmt.executeQuery(query);

                rs.first();
            }
            catch (java.sql.SQLException e)
            {
                stmt = sqlcon.createStatement(java.sql.ResultSet.TYPE_SCROLL_INSENSITIVE,
                        java.sql.ResultSet.CONCUR_UPDATABLE);

                query =
                    "INSERT INTO DFB_FORMORDER (FO_KEY,FO_REFMASTER,FM_FORMDATA) "+
                    "VALUES('"+dsname+"','"+parentkey+"',empty_blob())";
                stmt.executeUpdate(query);

                query = "SELECT DFB_FORMORDER.* FROM DFB_FORMORDER WHERE "+
                    "FO_REFMASTER='"+parentkey+"' AND FO_KEY='"+dsname+"' for update";

                rs = stmt.executeQuery(query);

                rs.first();
            }


            oracle.sql.BLOB blob;
            blob = ((oracle.jdbc.driver.OracleResultSet)rs).getBLOB("FM_FORMDATA");

            blob = HashMapToBlob(dataset, blob);
            ((oracle.jdbc.driver.OracleResultSet)rs).updateBLOB("FM_FORMDATA", blob);

            stmt.executeUpdate("commit");

        }
        catch (java.sql.SQLException e)
        {
        }
        */
    }

    public java.sql.ResultSet getList(String query)
    {
        java.sql.ResultSet rs = null;
        java.sql.Statement stmt;
        try
        {
            sqlcon =
                java.sql.DriverManager.getConnection(CONNECTOR, USERNAME, PASSWORD);

            try
            {
                stmt = sqlcon.createStatement(java.sql.ResultSet.TYPE_SCROLL_INSENSITIVE,
                        java.sql.ResultSet.CONCUR_UPDATABLE);

                rs = stmt.executeQuery(query);

            }
            catch (java.sql.SQLException e)
            {
                e.printStackTrace();
                rs = null;
            }

        }
        catch (java.sql.SQLException e)
        {
            rs = null;
        }
        return rs;
    }

    public HashMap getDataset(String table, String keyfield, String key)
    {
        HashMap result = new HashMap();
        java.sql.Statement stmt;
        java.sql.ResultSet rs;
        java.sql.ResultSetMetaData rsmeta;
        String query = "";
        int colcount;
        try
        {
            sqlcon = com.heidelberg.common.connector.db.ConnectionPool.getConnection();

            try
            {
                stmt = sqlcon.createStatement(java.sql.ResultSet.TYPE_SCROLL_INSENSITIVE,
                        java.sql.ResultSet.CONCUR_UPDATABLE);
                query = "SELECT * FROM "+table+" WHERE "+keyfield+"='"+key+"'";
                rs = stmt.executeQuery(query);
                rs.first();
                result = BlobToHashMap(rs.getBlob("FM_FORMDATA"));
            }
            catch (java.sql.SQLException e)
            {
                result.put("error", e.toString());
                e.printStackTrace();
            }
        }
        finally
        {
    try {sqlcon.close();} catch (java.sql.SQLException e) {e.printStackTrace();}
        }
        return result;
    }

    public HashMap getSubDataset(String dsname, HashMap masterdataset)
    {
        HashMap result = new HashMap();
        result = (HashMap)masterdataset.get("SUBDS_"+dsname);
        if (result == null) result = new HashMap();
        return result;
        /*
        HashMap result = new HashMap();
        java.sql.Statement stmt;
        java.sql.ResultSet rs;
        java.sql.ResultSetMetaData rsmeta;
        String query = "";
        int colcount;
        try
        {
            sqlcon = com.heidelberg.common.connector.db.ConnectionPool.getConnection();

            try
            {
                stmt = sqlcon.createStatement(java.sql.ResultSet.TYPE_SCROLL_INSENSITIVE,
                        java.sql.ResultSet.CONCUR_UPDATABLE);
                query = "SELECT * FROM DFB_FORMORDER WHERE FO_REFMASTER='"+parentkey+"' "+
                    "AND FO_KEY='"+dsname+"'";
                rs = stmt.executeQuery(query);
                rs.first();
                result = BlobToHashMap(rs.getBlob("FO_FORMDATA"));
            }
            catch (java.sql.SQLException e)
            {
                result.put("error", e.toString());
                e.printStackTrace();
            }
        }
        finally
        {
    try {sqlcon.close();} catch (java.sql.SQLException e) {e.printStackTrace();}
        }
        return result;
        */
    }

    public HashMap getHashMapFromDataset(HashMap dataset, String fieldname)
    {
        HashMap result = new HashMap();
        String serialized;

        serialized = (String)dataset.get(fieldname);
        if (serialized == null) serialized = "";
        dataset = StringToHashMap(serialized);

        return result;
    }

    public void SaveHashMapToDataset(HashMap dataset, HashMap fieldcontent, String fieldname)
    {
        String serialized = HashMapToString(dataset);
        dataset.put(fieldname, serialized);
    }

    public String getField(HashMap dataset, String fieldname)
    {
        String result;
        result = (String)dataset.get(fieldname);
        if (result == null) result = "";
        return result;
    }


    public String getField(HashMap dataset, String fieldname, String emptystr)
    {
        String result;
        result = (String)dataset.get(fieldname);
        if (result == null || result.equals("")) result = emptystr;
        return result;
    }


    public String getFieldL(HashMap dataset, String fieldname)
    {
        String result;
        result = (String)dataset.get(fieldname);
        if (result == null) result = "";
        fieldlog = fieldlog + fieldname +",";
        return result;
    }

}


DfbDataHandler gDBH = new DfbDataHandler();

%>

<%!

String content = "";
String usr ="";

/*
String getMarketCenter(HttpServletRequest request, String usr)
{
    java.sql.Connection con2;
    java.sql.Statement stmt2;
    java.sql.ResultSet rs2;
    String tempMC = "";
    try
    {
        con2 = com.heidelberg.common.connector.db.ConnectionPool.getConnection();
        stmt2 = con2.createStatement();
        rs2 = stmt2.executeQuery(db.QUERY000206+usr+"'");
        rs2.next();
        con2.close();
        tempMC = rs2.getString("marketcenter");
    }
    catch (SQLException ee)
    {
        ee.printStackTrace();
        tempMC = ee.toString();
    }
    return tempMC;
}
*/


HashMap getMachines()
{
    java.sql.Connection con2;
    java.sql.Statement stmt2;
    java.sql.ResultSet rs2;
    HashMap maschinen = new HashMap();
    String dummy;
    int m = 0;
    try
    {
        con2 = com.heidelberg.common.connector.db.ConnectionPool.getConnection();
        stmt2 = con2.createStatement();
        rs2 = stmt2.executeQuery("SELECT * FROM dfb_machines ORDER BY maschinen");
        while (rs2.next())
        {
            m=m+1;
            dummy = Integer.toString(m);
            maschinen.put(dummy,rs2.getString("maschinen"));
        }
        dummy = Integer.toString(m);
        maschinen.put("anzahl",dummy);
        con2.close();
    }
    catch (SQLException ee)
    {
        ee.printStackTrace();
    }
    return maschinen;
}
%>