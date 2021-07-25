package main.java.bernardic.jb.server;

import java.util.List;

public class User {
	private final String token;
	private final String username;
	private final String email;
	private final String password;
	private final List<String> groups;
	public User(String token, String username, String email, String password, List<String> groups) {
		this.token = token;
		this.username = username;
		this.email = email;
		this.password = password;
		this.groups = groups;
	}
	public String getToken() {
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
	public List<String> getGroups() {
		return groups;
	}
}