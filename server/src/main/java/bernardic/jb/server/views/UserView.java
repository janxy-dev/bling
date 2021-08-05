package main.java.bernardic.jb.server.views;

import main.java.bernardic.jb.server.models.User;

public class UserView {
	private final String username;
	public UserView(User user) {
		this.username = user.getUsername();
	}
	public String getUsername() {
		return username;
	}
	
}
