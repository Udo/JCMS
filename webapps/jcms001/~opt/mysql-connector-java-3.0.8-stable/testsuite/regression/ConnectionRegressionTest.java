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

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

import testsuite.BaseTestCase;

/**
 * Regression tests for Connections
 *
 * @author Mark Matthews
 * @version $Id: ConnectionRegressionTest.java,v 1.1.2.2 2003/04/25 14:43:51 mmatthew Exp $
 */
public class ConnectionRegressionTest extends BaseTestCase {

	/**
	 * @param name the name of the testcase
	 */
	public ConnectionRegressionTest(String name) {
		super(name);
	}

	/**
	 * Tests setReadOnly() being reset during failover
	 * 
	 * @throws Exception if an error occurs.
	 */	
	public void testSetReadOnly() throws Exception {
		Properties props = new Properties();
		props.put("autoReconnect", "true");
		String sepChar = "?";
		
		if (BaseTestCase.dbUrl.indexOf("?") != -1) {
			sepChar = "&";
		}
		
		Connection reconnectableConn = DriverManager.getConnection(BaseTestCase.dbUrl + sepChar + "autoReconnect=true", props);
		
		rs = reconnectableConn.createStatement().executeQuery("SELECT CONNECTION_ID()");
		rs.next();
		String connectionId = rs.getString(1);
		
		reconnectableConn.setReadOnly(true);
		boolean isReadOnly = reconnectableConn.isReadOnly();
		

		System.out.println("You have 30 seconds to kill connection id " + connectionId + "...");
		Thread.sleep(30000);
		System.out.println("Executing statement on reconnectable connection...");
		
		try {
			reconnectableConn.createStatement().executeQuery("SELECT 1");
		} catch (SQLException sqlEx) {
			; // ignore
		}
		
		reconnectableConn.createStatement().executeQuery("SELECT 1");

		assertTrue(reconnectableConn.isReadOnly() == isReadOnly);
		
	}
}
