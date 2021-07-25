package main.java.bernardic.jb.server;

import java.util.List;

import com.corundumstudio.socketio.AckRequest;
import com.corundumstudio.socketio.SocketIOClient;
import com.corundumstudio.socketio.SocketIOServer;
import com.corundumstudio.socketio.listener.DataListener;

import main.java.bernardic.jb.server.models.GroupModel;
import main.java.bernardic.jb.server.models.UserModel;

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
				User user = Server.getDatabase().getUser(token);
				client.sendEvent("fetchLocalUser", new UserModel(user.getUsername()));
			}
		});
	}
	private void fetchGroups() {
		server.addEventListener("fetchGroups", String.class, new DataListener<String>() {
			@Override
			public void onData(SocketIOClient client, String token, AckRequest ackSender) throws Exception {
				User user = Server.getDatabase().getUser(token);
				List<String> group_ids = user.getGroups();
				GroupModel[] groups = new GroupModel[group_ids.size()];
				for(int i = 0; i<group_ids.size(); i++) {
					groups[i] = Server.getDatabase().getGroup(group_ids.get(i));
					groups[i].getMembers().forEach(member->member = Server.getDatabase().getUser((String)member).getUsername());
				}
				client.sendEvent("fetchGroups", (Object[])groups);
			}
		});
	}
}
