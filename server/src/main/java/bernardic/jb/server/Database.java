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
	
	public void createUsers() {
		//Create users table if doesn't exist
		try(Connection conn = DriverManager.getConnection(url, user, pass)){
			String sql = "CREATE TABLE IF NOT EXISTS users ("
					+ "token UUID NOT NULL PRIMARY KEY, "
					+ "username VARCHAR(15) NOT NULL, "
					+ "password CHAR(60) NOT NULL, "
					+ "email VARCHAR(254) NOT NULL);";
			Statement stmt = conn.createStatement();
			stmt.executeUpdate(sql);
		}catch(SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void addUser(String username, String password, String email) {
		try(Connection conn = DriverManager.getConnection(url, user, pass)){
			PreparedStatement stmt = conn.prepareStatement("INSERT INTO users (token, username, password, email) VALUES (gen_random_uuid(), ?,?,?)");
			stmt.setString(1, username);
			stmt.setString(2, password);
			stmt.setString(3, email);
			stmt.executeUpdate();
		}catch(SQLException e) {
			e.printStackTrace();
		}
	}
	
}
