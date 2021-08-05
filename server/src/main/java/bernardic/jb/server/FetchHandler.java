package main.java.bernardic.jb.server;

import java.util.UUID;

import com.corundumstudio.socketio.AckRequest;
import com.corundumstudio.socketio.SocketIOClient;
import com.corundumstudio.socketio.SocketIOServer;
import com.corundumstudio.socketio.listener.DataListener;

import main.java.bernardic.jb.server.models.User;
import main.java.bernardic.jb.server.views.GroupView;
import main.java.bernardic.jb.server.views.UserView;

public class FetchHandler {
	final SocketIOServer server;
	public FetchHandler(SocketIOServer server) {
		this.server = server;
	}
	public void init() {
		fetchLocalUser();
		fetchGroups();
	}
	private void fetchLocalUser() {
		server.addEventListener("fetchLocalUser", String.class, new DataListener<String>() {
			@Override
			public void onData(SocketIOClient client, String token, AckRequest ackSender) throws Exception {
				User user = Server.getDatabase().getUser(UUID.fromString(token));
				client.sendEvent("fetchLocalUser", new UserView(user));
			}
		});
	}
	private void fetchGroups() {
		server.addEventListener("fetchGroups", String.class, new DataListener<String>() {
			@Override
			public void onData(SocketIOClient client, String token, AckRequest ackSender) throws Exception {
				User user = Server.getDatabase().getUser(UUID.fromString(token));
				UUID[] group_ids = user.getGroups();
				GroupView[] groups = new GroupView[group_ids.length];
				for(int i = 0; i<group_ids.length; i++) {
					groups[i] = new GroupView(Server.getDatabase().getGroup(group_ids[i]));
				}
				client.sendEvent("fetchGroups", (Object[])groups);
			}
		});
	}
}
