package main.java.bernardic.jb.server;

import java.sql.*;

public class Database {
	private final String url, user, pass;
	public Database(String url, String user, String pass) {
		this.url = url;
		this.user = user;
		this.pass = pass;
	}
	public void testConnection() {
	    try(Connection conn = DriverManager.getConnection(url, user, pass);){
	    	if(conn == null) {
	    		System.out.println("Failed to connect to PostgreSQL Server");
	    		return;
	    	}
	    	System.out.println("Connected to PostgreSQL Server successfully!");
	    }catch(SQLException e) {
	    	e.printStackTrace();
	    }
	}
	public int executeUpdate(String sql) {
	      try(Connection conn = DriverManager.getConnection(url, user, pass);){
  			Statement stmt = conn.createStatement();
			return stmt.executeUpdate(sql);
	      }catch(SQLException e) {
	    	  e.printStackTrace();
	      }
		return 0;
	}
	public ResultSet executeQuery(String sql) {
	      try(Connection conn = DriverManager.getConnection(url, user, pass);){
			Statement stmt = conn.createStatement();
			return stmt.executeQuery(sql);
	      }catch(SQLException e) {
	    	  e.printStackTrace();
	      }
		return null;
	}
	
}
