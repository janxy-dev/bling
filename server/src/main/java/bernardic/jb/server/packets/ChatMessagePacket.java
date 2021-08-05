package main.java.bernardic.jb.server.packets;

import org.json.JSONObject;

public class ChatMessagePacket {
	private final String userToken;
	private final String groupUUID;
	private final String message;
	public ChatMessagePacket(String userToken, String groupUUID, String message) {
		this.userToken = userToken;
		this.groupUUID = groupUUID;
		this.message = message;
	}
	public String getUserToken() {
		return userToken;
	}
	public String getGroupUUID() {
		return groupUUID;
	}
	public String getMessage() {
		return message;
	}
	public static ChatMessagePacket fromJson(String jsonString) {
		JSONObject json = new JSONObject(jsonString);
		return new ChatMessagePacket(json.getString("userToken"), json.getString("groupUUID"), json.getString("message"));
	}
}
