package main.java.bernardic.jb.server;

import java.util.UUID;

import com.corundumstudio.socketio.AckRequest;
import com.corundumstudio.socketio.SocketIOClient;
import com.corundumstudio.socketio.SocketIOServer;
import com.corundumstudio.socketio.listener.DataListener;

import main.java.bernardic.jb.server.models.GroupModel;

public class GroupHandler {
	SocketIOServer server;
	public GroupHandler(SocketIOServer server) {
		this.server = server;
	}
	
	public void init() {
		handleGroupCreate();
	}
	
	public void handleGroupCreate() {
		server.addEventListener("createGroup", String.class, new DataListener<String>() {
			@Override
			public void onData(SocketIOClient client, String data, AckRequest ackSender) throws Exception {
				GroupModel group = GroupModel.fromJson(data).setGroupUUID(UUID.randomUUID().toString());
				User admin = Server.getDatabase().getUser((String) group.getAdmins().get(0));
				if(!Server.getDatabase().validateToken((String)admin.getToken())) return;
				Server.getDatabase().createGroup(group);
				Server.getDatabase().addUserToGroup(admin, group);
				client.sendEvent("createGroup", group.getGroupUUID());
			}
		});
	}
}
