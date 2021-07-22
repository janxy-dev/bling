package main.java.bernardic.jb.server;

import com.corundumstudio.socketio.AckRequest;
import com.corundumstudio.socketio.SocketIOClient;
import com.corundumstudio.socketio.SocketIOServer;
import com.corundumstudio.socketio.listener.DataListener;

import main.java.bernardic.jb.server.models.UserModel;

public class FetchHandler {
	final SocketIOServer server;
	public FetchHandler(SocketIOServer server) {
		this.server = server;
	}
	public void init() {
		fetchLocalUser();
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
}
