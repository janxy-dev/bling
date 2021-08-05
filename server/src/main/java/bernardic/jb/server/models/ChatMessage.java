package main.java.bernardic.jb.server.models;

import java.util.UUID;

public class ChatMessage {
	private final int id;
	private final int seens;
	private final UUID groupUUID;
	private final String message;
	public ChatMessage(int id, int seens, UUID groupUUID, String message) {
		this.id = id;
		this.seens = seens;
		this.groupUUID = groupUUID;
		this.message = message;
	}
	public int getId() {
		return id;
	}
	public int getSeens() {
		return seens;
	}
	public UUID getGroupUUID() {
		return groupUUID;
	}
	public String getMessage() {
		return message;
	}
}
