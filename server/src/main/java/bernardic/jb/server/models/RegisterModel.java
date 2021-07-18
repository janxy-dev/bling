package main.java.bernardic.jb.server.models;

import org.json.JSONObject;

public class RegisterModel {
	private final String username;
	private final String email;
	private final String password;
	private final String conPassword;
	public RegisterModel(String username, String email, String password, String conPassword) {
		this.username = username;
		this.email = email;
		this.password = password;
		this.conPassword = conPassword;
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

	public String getConfirmedPassword() {
		return conPassword;
	}

	public static RegisterModel fromJson(String jsonString) {
		JSONObject json = new JSONObject(jsonString);
		return new RegisterModel(json.getString("username"), json.getString("email"), json.getString("password"), json.getString("conPassword"));
	}
}
