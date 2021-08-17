package main.java.bernardic.jb.server;

import java.sql.*;
import java.util.UUID;

import org.json.JSONArray;
import org.json.JSONObject;
import org.mindrot.jbcrypt.BCrypt;

import main.java.bernardic.jb.server.models.Group;
import main.java.bernardic.jb.server.models.User;
import main.java.bernardic.jb.server.views.ChatMessageView;

public class Database {
	private final String db_url, db_user, db_pass;
	private final Connection getConnection() throws SQLException {return DriverManager.getConnection(db_url, db_user, db_pass);}
	public Database(String url, String user, String pass) {
		this.db_url = url;
		this.db_user = user;
		this.db_pass = pass;
	}
	public void init() {
		testConnection();
		createFunctions();
		createTables();
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
	public void createFunctions() {
		try(Connection conn = getConnection()){
			String inviteCodeFunction = "CREATE OR REPLACE FUNCTION update_invite_code(group_uuid UUID) RETURNS text AS $$" + 
					"DECLARE" + 
					"    code text;" + 
					"    done bool;" + 
					"BEGIN" + 
					"    done := false;" + 
					"    WHILE NOT done LOOP" + 
					"        code := substring(md5(''||now()::text||random()::text) for 7);" + 
					"        done := NOT exists(SELECT 1 FROM groups WHERE invite_code=code);" + 
					"    END LOOP;" + 
					"    UPDATE groups SET invite_code = code WHERE groups.uuid = group_uuid;" + 
					"    RETURN code;" + 
					"END;" + 
					"$$ LANGUAGE PLPGSQL VOLATILE;";
	    	conn.createStatement().execute(inviteCodeFunction);
		}catch(SQLException e) {
			e.printStackTrace();
		}
	}
	public void createTables() {
		//Create users table if doesn't exist
		try(Connection conn = getConnection()){
			String users = "CREATE TABLE IF NOT EXISTS users ("
					+ "token UUID PRIMARY KEY, "
					+ "username VARCHAR(15) NOT NULL UNIQUE, "
					+ "email VARCHAR(254) NOT NULL UNIQUE, "
					+ "password VARCHAR(60) NOT NULL, "
					+ "groups UUID[], "
					+ "messages JSONB DEFAULT '[]'::jsonb"
					+ ");";
			String groups = "CREATE TABLE IF NOT EXISTS groups ("
					+ "uuid UUID PRIMARY KEY, "
					+ "name VARCHAR(30) NOT NULL, "
					+ "members UUID[], "
					+ "invite_code CHAR(7) UNIQUE"
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
	public User getUser(UUID token) {
		try(Connection conn = getConnection()){
			Statement stmt = conn.createStatement();
			String sql = "SELECT * FROM users WHERE token='" + token + "';";
			ResultSet res = stmt.executeQuery(sql);
			if(res.next()) {
				UUID[] groups = null;
 				if(res.getArray(5) != null) groups =(UUID[])res.getArray(5).getArray();
				return new User(token, res.getString(2), res.getString(3), res.getString(4), groups, new JSONArray(res.getString(6)));	
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
	public Group createGroup(String groupName) {
		Group group = new Group(UUID.randomUUID(), groupName, new UUID[] {});
		try(Connection conn = getConnection()){
			PreparedStatement stmt = conn.prepareStatement("INSERT INTO groups (uuid, name) VALUES ('" + group.getGroupUUID() + "',?) ON CONFLICT DO NOTHING;");
			stmt.setString(1, groupName);
			stmt.executeUpdate();
			conn.createStatement().execute("SELECT update_invite_code('"+ group.getGroupUUID() +"');");
		}catch(Exception e) {
			e.printStackTrace();
		}
		return group;
	}
	public void addUserToGroup(User user, Group group) {
		try(Connection conn = getConnection()){
			PreparedStatement stmt = conn.prepareStatement("UPDATE groups SET members = array_append(members, ?) WHERE groups.uuid = '"+ group.getGroupUUID() +"';");
			stmt.setObject(1, user.getToken());
			stmt.executeUpdate();
			PreparedStatement stmt2 = conn.prepareStatement("UPDATE users SET groups = array_append(groups, ?) WHERE users.token = '" + user.getToken() + "';");
			stmt2.setObject(1, group.getGroupUUID());
			stmt2.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	public Group getGroup(UUID groupId) {
		try(Connection conn = getConnection()){
			Statement stmt = conn.createStatement();
			String sql = "SELECT * FROM groups WHERE uuid='" + groupId + "';";
			ResultSet res = stmt.executeQuery(sql);
			UUID[] members = null;
			if(res.next()) {
				if(res.getArray(3) != null) members = (UUID[])res.getArray(3).getArray();
				Group group = new Group((UUID)res.getObject(1), res.getString(2), members);
				return group;	
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	public Group getGroup(String inviteCode) {
		try(Connection conn = getConnection()){
			Statement stmt = conn.createStatement();
			String sql = "SELECT * FROM groups WHERE invite_code='" + inviteCode + "';";
			ResultSet res = stmt.executeQuery(sql);
			UUID[] members = null;
			if(res.next()) {
				if(res.getArray(3) != null) members = (UUID[])res.getArray(3).getArray();
				Group group = new Group((UUID)res.getObject(1), res.getString(2), members);
				return group;	
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	public boolean isUserInGroup(User user, Group group) {
		try(Connection conn = getConnection()){
			ResultSet res = conn.createStatement().executeQuery("SELECT EXISTS(SELECT 1 FROM users WHERE token = '"+ user.getToken() +"' AND '"+ group.getGroupUUID() +"' = ANY(groups))");
			if(res.next()) {
				return res.getBoolean(1);
			}
		}catch(SQLException e) {
			e.printStackTrace();
		}
		return false;
	}
	public void addMessage(UUID recieverToken, ChatMessageView msg) {
		try(Connection conn = getConnection()){
			PreparedStatement stmt = conn.prepareStatement("UPDATE users SET messages = messages || ?::jsonb WHERE users.token = '"+ recieverToken +"';");
			stmt.setString(1, new JSONObject(msg).toString());
			stmt.executeUpdate();
		}catch(SQLException e) {
			e.printStackTrace();
		}
	}
	public void deleteMessages(User user) {
		try(Connection conn = getConnection()){
			conn.createStatement().executeUpdate("UPDATE users SET messages = '[]'::jsonb WHERE users.token = '"+ user.getToken() +"';");
		}catch(SQLException e) {
			e.printStackTrace();
		}
	}
	public void deleteMessage(User user, int index) {
		try(Connection conn = getConnection()){
			conn.createStatement().executeUpdate("UPDATE users SET messages = messages - "+ index +" WHERE users.token = '"+ user.getToken() +"';");
		}catch(SQLException e) {
			e.printStackTrace();
		}
	}
	
}
