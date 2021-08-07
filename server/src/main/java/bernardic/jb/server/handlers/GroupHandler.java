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
				if(!Server.getDatabase().validateToken(token)) return;
				Group group = Server.getDatabase().createGroup(groupName);
				Server.getDatabase().addUserToGroup(db.getUser(UUID.fromString(token)), group);
				client.sendEvent("createGroup", group.getGroupUUID());
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
				System.out.println(inviteCode);
				if(!Server.getDatabase().validateToken(token)) return;
				Group group = Server.getDatabase().getGroup(inviteCode);
				Server.getDatabase().addUserToGroup(db.getUser(UUID.fromString(token)), group);
				client.sendEvent("createGroup", group.getGroupUUID());
			}
		});
	}
}
