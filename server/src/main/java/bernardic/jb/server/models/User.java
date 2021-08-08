package main.java.bernardic.jb.server.models;

import java.util.UUID;

import org.json.JSONArray;

public class User {
	private final UUID token;
	private final String username;
	private final String email;
	private final String password;
	private final UUID[] groups;
	private final JSONArray messages;
	public User(UUID token, String username, String email, String password, UUID[] groups, JSONArray messages) {
		this.token = token;
		this.username = username;
		this.email = email;
		this.password = password;
		this.groups = groups;
		this.messages = messages;
	}
	public UUID getToken() {
		return token;
	}
	public String getUsername() {
		return username;
	}
	public String getEmail() {
		return email;
	}
	public String getPassword() {
		return password;
	}
	public UUID[] getGroups() {
		return groups;
	}
	public JSONArray getMessages() {
		return messages;
	}
}