package main.java.bernardic.jb.server.packets;

import org.json.JSONObject;

public class ChatMessagePacket {
	private final String token;
	private final String groupUUID;
	private final String message;
	public ChatMessagePacket(String token, String groupUUID, String message) {
		this.token = token;
		this.groupUUID = groupUUID;
		this.message = message;
	}
	public String getToken() {
		return token;
	}
	public String getGroupUUID() {
		return groupUUID;
	}
	public String getMessage() {
		return message;
	}
	public static ChatMessagePacket fromJson(String jsonString) {
		JSONObject json = new JSONObject(jsonString);
		return new ChatMessagePacket(json.getString("token"), json.getString("groupUUID"), json.getString("message"));
	}
}
