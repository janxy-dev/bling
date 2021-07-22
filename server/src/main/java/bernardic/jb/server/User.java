package main.java.bernardic.jb.server;

public class User {
	private final String token;
	private final String username;
	private final String email;
	private final String password;
	public User(String token, String username, String email, String password) {
		this.token = token;
		this.username = username;
		this.email = email;
		this.password = password;
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
}