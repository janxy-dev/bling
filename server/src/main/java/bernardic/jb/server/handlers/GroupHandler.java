package main.java.bernardic.jb.server.handlers;

import java.util.UUID;

import org.json.JSONObject;

import com.corundumstudio.socketio.AckRequest;
import com.corundumstudio.socketio.SocketIOClient;
import com.corundumstudio.socketio.SocketIOServer;
import com.corundumstudio.socketio.listener.DataListener;

import main.java.bernardic.jb.server.Database;
import main.java.bernardic.jb.server.Server;
import main.java.bernardic.jb.server.models.Group;
import main.java.bernardic.jb.server.models.User;
import main.java.bernardic.jb.server.views.ChatMessageView;

public class GroupHandler {
	private SocketIOServer server;
	private Database db = Server.getDatabase();
	public GroupHandler(SocketIOServer server) {
		this.server = server;
	}
	
	public void init() {
		handleGroupCreate();
		handleGroupJoin();
	}
	private void handleGroupCreate() {
		server.addEventListener("createGroup", String.class, new DataListener<String>() {
			@Override
			public void onData(SocketIOClient client, String data, AckRequest ackSender) throws Exception {
				JSONObject json = new JSONObject(data);
				String token = json.getString("token");
				String groupName = json.getString("groupName");
				if(Server.getDatabase().getUser(UUID.fromString(token)) == null) return;
				Group group = Server.getDatabase().createGroup(groupName);
				User user = db.getUser(UUID.fromString(token));
				Server.getDatabase().addUserToGroup(user, group);
				client.joinRoom(group.getGroupUUID().toString());
				client.sendEvent("message", new ChatMessageView(group.getGroupUUID(), UUID.randomUUID(), user.getUsername() + " created group \""+ group.getName() + "\"", ""));
			}
		});
	}
	private void handleGroupJoin() {
		server.addEventListener("joinGroup", String.class, new DataListener<String>() {
			@Override
			public void onData(SocketIOClient client, String data, AckRequest ackSender) throws Exception {
				JSONObject json = new JSONObject(data);
				String token = json.getString("token");
				String inviteCode = json.getString("inviteCode");
				User user = Server.getDatabase().getUser(UUID.fromString(token)); 
				if(user == null) return;
				Group group = Server.getDatabase().getGroup(inviteCode);
				Server.getDatabase().addUserToGroup(db.getUser(UUID.fromString(token)), group);
				client.joinRoom(group.getGroupUUID().toString());
				server.getRoomOperations(group.getGroupUUID().toString()).sendEvent("message", new ChatMessageView(group.getGroupUUID(), UUID.randomUUID(), user.getUsername() + " has joined.", ""));
			}
		});
	}
}
