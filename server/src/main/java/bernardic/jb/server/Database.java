package main.java.bernardic.jb.server;

import java.sql.*;
import java.util.UUID;

public class Database {
	private final String db_url, db_user, db_pass;
	private final Connection getConnection() throws SQLException {return DriverManager.getConnection(db_url, db_user, db_pass);}
	public Database(String url, String user, String pass) {
		this.db_url = url;
		this.db_user = user;
		this.db_pass = pass;
	}
	public void testConnection() {
	    try(Connection conn = getConnection()){
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
		try(Connection conn = getConnection()){
			String sql = "CREATE TABLE IF NOT EXISTS users ("
					+ "token UUID NOT NULL PRIMARY KEY, "
					+ "username VARCHAR(15) NOT NULL UNIQUE, "
					+ "email VARCHAR(254) NOT NULL UNIQUE, "
					+ "password CHAR(60) NOT NULL);";
			Statement stmt = conn.createStatement();
			stmt.executeUpdate(sql);
		}catch(SQLException e) {
			e.printStackTrace();
		}
	}
	public String addUser(String username, String password, String email) {
		UUID token = UUID.randomUUID();
		try(Connection conn = getConnection()){
			PreparedStatement stmt = conn.prepareStatement("INSERT INTO users (token, username, email, password) VALUES ('"+token+"', ?,?,?) ON CONFLICT DO NOTHING;");
			stmt.setString(1, username);
			stmt.setString(2, email);
			stmt.setString(3, password);
			stmt.executeUpdate();
		}catch(SQLException e) {
			e.printStackTrace();
		}
		return token.toString();
	}
	public User getUser(String token) {
		try(Connection conn = getConnection()){
			Statement stmt = conn.createStatement();
			String sql = "SELECT * FROM users WHERE token='" + token + "';";
			ResultSet res = stmt.executeQuery(sql);
			res.next();
			return new User(token, res.getString(2), res.getString(3), res.getString(4));
		}catch(SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
	public String authUser(String username, String password) {
		try(Connection conn = getConnection()){
			Statement stmt = conn.createStatement();
			String sql = "SELECT password, token FROM users WHERE username='" + username + "';";
			ResultSet res = stmt.executeQuery(sql);
			if(res.next() && res.getString(1).strip().equals(password)) {
				return res.getString(2);
			}
		}catch(SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
	public boolean hasEmail(String email) {
		try(Connection conn = getConnection()){
			Statement stmt = conn.createStatement();
			String sql = "SELECT EXISTS(SELECT 1 FROM users WHERE email='"+email+"')";
			ResultSet res = stmt.executeQuery(sql);
			if(res.next()) {
				return res.getBoolean(1);
			}
		}catch(SQLException e) {
			e.printStackTrace();
		}
		return false;
	}
	public boolean hasUsername(String username) {
		try(Connection conn = getConnection()){
			Statement stmt = conn.createStatement();
			String sql = "SELECT EXISTS(SELECT 1 FROM users WHERE username='"+username+"')";
			ResultSet res = stmt.executeQuery(sql);
			if(res.next()) {
				return res.getBoolean(1);
			}
		}catch(SQLException e) {
			e.printStackTrace();
		}
		return false;
	}
	
}
