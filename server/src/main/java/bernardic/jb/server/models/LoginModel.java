package main.java.bernardic.jb.server.models;

import org.json.JSONObject;

public class LoginModel {
	private final String username;
	private final String password;
	public LoginModel(String username, String password) {
		this.username = username;
		this.password = password;
	}
	public String getUsername() {
		return username;
	}

	public String getPassword() {
		return password;
	}

	public static LoginModel fromJson(String jsonString) {
		JSONObject json = new JSONObject(jsonString);
		return new LoginModel(json.getString("username"), json.getString("password"));
	}
}
