package main.java.bernardic.jb.server.views;

import main.java.bernardic.jb.server.models.User;

public class LocalUserView {
	private final String username;
	private final Object[] messages;
	public LocalUserView(User user) {
		username = user.getUsername();
		messages = user.getMessages().toList().toArray();
	}
	public String getUsername() {
		return username;
	}
	public Object[] getMessages() {
		return messages;
	}
}
