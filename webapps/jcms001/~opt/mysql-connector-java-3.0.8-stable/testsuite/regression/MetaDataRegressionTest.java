/*
   Copyright (C) 2002 MySQL AB

      This program is free software; you can redistribute it and/or modify
      it under the terms of the GNU General Public License as published by
      the Free Software Foundation; either version 2 of the License, or
      (at your option) any later version.

      This program is distributed in the hope that it will be useful,
      but WITHOUT ANY WARRANTY; without even the implied warranty of
      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
      GNU General Public License for more details.

      You should have received a copy of the GNU General Public License
      along with this program; if not, write to the Free Software
      Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

 */
package testsuite.regression;

import testsuite.BaseTestCase;

import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

import com.mysql.jdbc.Driver;


/**
 * Regression tests for DatabaseMetaData
 *
 * @author Mark Matthews
 * @version $Id: MetaDataRegressionTest.java,v 1.3.2.3 2003/04/25 14:43:06 mmatthew Exp $
 */
public class MetaDataRegressionTest extends BaseTestCase {
    /**
     * Creates a new MetaDataRegressionTest.
     *
     * @param name the name of the test
     */
    public MetaDataRegressionTest(String name) {
        super(name);
    }

    /**
     * Tests char/varchar bug
     * 
     * @throws Exception if any errors occur
     */
    public void testCharVarchar() throws Exception {
        try {
            stmt.execute("DROP TABLE IF EXISTS charVarCharTest");
            stmt.execute("CREATE TABLE charVarCharTest ("
                + "  TableName VARCHAR(64)," + "  FieldName VARCHAR(64),"
                + "  NextCounter INTEGER);");

            String query = "SELECT TableName, FieldName, NextCounter FROM charVarCharTest";
            rs = stmt.executeQuery(query);

            ResultSetMetaData rsmeta = rs.getMetaData();

            assertTrue(rsmeta.getColumnTypeName(1).equalsIgnoreCase("VARCHAR"));

            //			 is "CHAR", expected "VARCHAR"
            assertTrue(rsmeta.getColumnType(1) == 12);

            //			 is 1 (java.sql.Types.CHAR), expected 12 (java.sql.Types.VARCHAR)
        } finally {
            stmt.execute("DROP TABLE IF EXISTS charVarCharTest");
        }
    }

    /**
     * Tests bug reported by OpenOffice team with getColumns and LONGBLOB
     *
     * @throws Exception if any errors occur
     */
    public void testGetColumns() throws Exception {
        try {
            stmt.execute(
                "CREATE TABLE IF NOT EXISTS longblob_regress(field_1 longblob)");

            DatabaseMetaData dbmd = conn.getMetaData();
            ResultSet dbmdRs = null;

            try {
                dbmdRs = dbmd.getColumns("", "", "longblob_regress", "%");

                while (dbmdRs.next()) {
                    dbmdRs.getInt(7);
                }
            } finally {
                if (dbmdRs != null) {
                    try {
                        dbmdRs.close();
                    } catch (SQLException ex) {
                        ;
                    }
                }
            }
        } finally {
            stmt.execute("DROP TABLE IF EXISTS longblob_regress");
        }
    }
    
    /**
     * Tests for types being returned correctly
     * 
     * @throws Exception if an error occurs.
     */
    public void testTypes() throws Exception {
    	try {
    		stmt.execute("DROP TABLE IF EXISTS typesRegressTest");
    		stmt.execute("CREATE TABLE typesRegressTest ("
			+ "varcharField VARCHAR(32),"
			+ "charField CHAR(2),"
			+ "enumField ENUM('1','2'),"
			+ "setField  SET('1','2','3'),"
			+ "tinyblobField TINYBLOB,"
			+ "mediumBlobField MEDIUMBLOB,"
			+ "longblobField LONGBLOB,"
			+ "blobField BLOB)");
			
			rs = stmt.executeQuery("SELECT * from typesRegressTest");
			
			ResultSetMetaData rsmd = rs.getMetaData();
			
			int numCols = rsmd.getColumnCount();
			
			for (int i = 0; i < numCols; i++) {
				String columnName = rsmd.getColumnName(i + 1);
				String columnTypeName = rsmd.getColumnTypeName(i + 1);
				System.out.println(columnName + " -> " + columnTypeName);
			}
    	} finally {
			stmt.execute("DROP TABLE IF EXISTS typesRegressTest");
    	}
    
    }
    
    /**
     * Tests whether bogus parameters break Driver.getPropertyInfo().
     * @throws Exception if an error occurs.
     */
    public void testGetPropertyInfo() throws Exception {
    	new Driver().getPropertyInfo("", null);
    }
}
