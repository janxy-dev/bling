package main.java.bernardic.jb.server.models;

import org.json.JSONObject;

public class UserModel {
	private final String username;
	public UserModel(String username) {
		this.username = username;
	}
	public String getUsername() {
		return username;
	}
	public String toJson() {
		JSONObject json = new JSONObject(this);
		return json.toString();
	}
}
