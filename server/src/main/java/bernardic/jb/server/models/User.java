package main.java.bernardic.jb.server.models;

import java.util.UUID;

public class User {
	private final UUID token;
	private final String username;
	private final String email;
	private final String password;
	private final UUID[] groups;
	public User(UUID token, String username, String email, String password, UUID[] groups) {
		this.token = token;
		this.username = username;
		this.email = email;
		this.password = password;
		this.groups = groups;
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
}