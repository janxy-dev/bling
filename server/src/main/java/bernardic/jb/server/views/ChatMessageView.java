package main.java.bernardic.jb.server.views;

import java.util.UUID;

public class ChatMessageView {
	private final UUID groupUUID;
	private final String message;
	private final String sender;
	private final UUID uuid;
	public ChatMessageView(UUID groupUUID, UUID uuid, String message, String sender) {
		this.groupUUID = groupUUID;
		this.message = message;
		this.sender = sender;
		this.uuid = uuid;
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
	public UUID getUuid() {
		return uuid;
	}
}
