package main.java.bernardic.jb.server.packets;

import org.json.JSONObject;

public class LoginPacket {
	private final String username;
	private final String password;
	public LoginPacket(String username, String password) {
		this.username = username;
		this.password = password;
	}
	public String getUsername() {
		return username;
	}
	public String getPassword() {
		return password;
	}
	public static LoginPacket fromJson(String jsonString) {
		JSONObject json = new JSONObject(jsonString);
		return new LoginPacket(json.getString("username"), json.getString("password"));
	}
}
