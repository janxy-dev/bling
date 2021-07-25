package main.java.bernardic.jb.server;

import java.sql.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

import org.json.JSONArray;
import org.mindrot.jbcrypt.BCrypt;

import main.java.bernardic.jb.server.models.GroupModel;

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
			String users = "CREATE TABLE IF NOT EXISTS users ("
					+ "token UUID PRIMARY KEY, "
					+ "username VARCHAR(15) NOT NULL UNIQUE, "
					+ "email VARCHAR(254) NOT NULL UNIQUE, "
					+ "password CHAR(60) NOT NULL, "
					+ "groups CHAR(36)[]"
					+ ");";
			String groups = "CREATE TABLE IF NOT EXISTS groups ("
					+ "group_uuid UUID PRIMARY KEY, "
					+ "name VARCHAR(30) NOT NULL, "
					+ "members CHAR(36)[]"
					+ ");";
			conn.createStatement().executeUpdate(users);
			conn.createStatement().executeUpdate(groups);
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
			stmt.setString(3, BCrypt.hashpw(password, BCrypt.gensalt()));
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
			if(res.next()) {
				List<String> groups = new ArrayList<String>();
				if(res.getArray(5) != null) groups = new ArrayList<String>(Arrays.asList((String[])res.getArray(5).getArray()));
				return new User(token, res.getString(2), res.getString(3), res.getString(4), groups);	
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	public String authUser(String username, String password) {
		try(Connection conn = getConnection()){
			PreparedStatement stmt = conn.prepareStatement("SELECT password, token FROM users WHERE username=? OR email=?");
			stmt.setString(1, username);
			stmt.setString(2, password);
			ResultSet res = stmt.executeQuery();
			if(res.next() && BCrypt.checkpw(password, res.getString(1))) {
				return res.getString(2);
			}
		}catch(SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
	public boolean hasEmail(String email) {
		try(Connection conn = getConnection()){
			PreparedStatement stmt = conn.prepareStatement("SELECT EXISTS(SELECT 1 FROM users WHERE email=?)");
			stmt.setString(1, email);
			ResultSet res = stmt.executeQuery();
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
			PreparedStatement stmt = conn.prepareStatement("SELECT EXISTS(SELECT 1 FROM users WHERE username=?)");
			stmt.setString(1, username);
			ResultSet res = stmt.executeQuery();
			if(res.next()) {
				return res.getBoolean(1);
			}
		}catch(SQLException e) {
			e.printStackTrace();
		}
		return false;
	}
	public boolean validateToken(String token) {
		try(Connection conn = getConnection()){
			Statement stmt = conn.createStatement();
			String sql = "SELECT EXISTS(SELECT 1 FROM users WHERE token='"+token+"')";
			ResultSet res = stmt.executeQuery(sql);
			if(res.next()) {
				return res.getBoolean(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	public void createGroup(GroupModel group) {
		try(Connection conn = getConnection()){
			PreparedStatement stmt = conn.prepareStatement("INSERT INTO groups (group_uuid, name) VALUES ('" + group.getGroupUUID() + "',?) ON CONFLICT DO NOTHING;");
			stmt.setString(1, group.getName());
			stmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	public void addUserToGroup(User user, GroupModel group) {
		try(Connection conn = getConnection()){
			PreparedStatement stmt = conn.prepareStatement("UPDATE groups SET members = ? WHERE groups.group_uuid = '"+ group.getGroupUUID() +"';");
			group.getMembers().add(user.getToken());
			stmt.setArray(1, conn.createArrayOf("UUID", group.getMembers().toArray()));
			stmt.executeUpdate();
			PreparedStatement stmt2 = conn.prepareStatement("UPDATE users SET groups = ? WHERE users.token = '" + user.getToken() + "';");
			user.getGroups().add(group.getGroupUUID());
			System.out.println(user.getGroups());
			stmt2.setArray(1, conn.createArrayOf("UUID", user.getGroups().toArray()));
			stmt2.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	public GroupModel getGroup(String groupId) {
		try(Connection conn = getConnection()){
			Statement stmt = conn.createStatement();
			String sql = "SELECT * FROM groups WHERE group_uuid='" + groupId + "';";
			ResultSet res = stmt.executeQuery(sql);
			if(res.next()) {
				GroupModel group = new GroupModel();
				group.setGroupUUID(res.getString(1));
				group.setName(res.getString(2));
				group.setMembers((String[])res.getArray(3).getArray());
				group.setAdmins(new JSONArray(new String[] {group.getMembers().get(0)}));//change later
				return group;	
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
}
