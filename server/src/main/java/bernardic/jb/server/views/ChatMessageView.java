package main.java.bernardic.jb.server.views;

import java.util.UUID;

public class ChatMessageView {
	private final UUID groupUUID;
	private final String message;
	private final String sender;
	public ChatMessageView(UUID groupUUID, String message, String sender) {
		this.groupUUID = groupUUID;
		this.message = message;
		this.sender = sender;
	}
	public UUID getGroupUUID() {
		return groupUUID;
	}
	public String getMessage() {
		return message;
	}
	public String getSender() {
		return sender;
	}
}
