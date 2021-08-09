package main.java.bernardic.jb.server.handlers;

import java.util.UUID;

import org.json.JSONObject;

import com.corundumstudio.socketio.AckRequest;
import com.corundumstudio.socketio.SocketIOClient;
import com.corundumstudio.socketio.SocketIOServer;
import com.corundumstudio.socketio.listener.DataListener;

import main.java.bernardic.jb.server.Server;
import main.java.bernardic.jb.server.models.Group;
import main.java.bernardic.jb.server.models.User;
import main.java.bernardic.jb.server.views.GroupView;
import main.java.bernardic.jb.server.views.LocalUserView;
public class FetchHandler {
	final SocketIOServer server;
	public FetchHandler(SocketIOServer server) {
		this.server = server;
	}
	public void init() {
		fetchLocalUser();
		fetchAllGroups();
		fetchGroup();
	}
	private void fetchLocalUser() {
		server.addEventListener("fetchLocalUser", String.class, (client, data, ackSender) -> {
			try {
				User user = Server.getDatabase().getUser(UUID.fromString(data));
				ackSender.sendAckData(new LocalUserView(user));
			}catch(Exception e) {
				e.printStackTrace();
			}
		});
	}
	private void fetchAllGroups() {
		server.addEventListener("fetchAllGroups", String.class, new DataListener<String>() {
			@Override
			public void onData(SocketIOClient client, String token, AckRequest ackSender) throws Exception {
				User user = Server.getDatabase().getUser(UUID.fromString(token));
				if(user == null) return;
				UUID[] group_ids = user.getGroups();
				GroupView[] groups = new GroupView[group_ids.length];
				for(int i = 0; i<group_ids.length; i++) {
					groups[i] = new GroupView(Server.getDatabase().getGroup(group_ids[i]));
					client.joinRoom(group_ids[i].toString());
				}
				ackSender.sendAckData((Object[])groups);
			}
		});
	}
	private void fetchGroup() {
		server.addEventListener("fetchGroup", String.class, new DataListener<String>() {
			@Override
			public void onData(SocketIOClient client, String data, AckRequest ackSender) throws Exception {
				try {
					JSONObject json = new JSONObject(data);
					User user = Server.getDatabase().getUser(UUID.fromString(json.getString("token")));
					if(user == null) return;
					String groupUUID = json.getJSONArray("args").getString(0);
					Group group = Server.getDatabase().getGroup(UUID.fromString(groupUUID));
					ackSender.sendAckData(new GroupView(group));
				}catch(Exception e) {
					e.printStackTrace();
				}
			}
		});
	}
}
