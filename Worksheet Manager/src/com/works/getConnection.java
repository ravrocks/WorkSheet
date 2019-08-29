/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.works;

import java.sql.Connection;
import java.sql.DriverManager;

/**
 *
 * @author ravi
 */
public class getConnection {
private String driver = "com.mysql.jdbc.Driver";
private String connectionUrl = "jdbc:mysql://localhost:3306/";
private String database = "lnttic";
private String userid = "root";
private String password = "root";
Connection connection = null;
    public Connection getConnection() {
        try {
        Class.forName(driver);
        connection = DriverManager.getConnection(connectionUrl+database, userid, password);
        return connection;
        } 
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return null;
    }
   
}
