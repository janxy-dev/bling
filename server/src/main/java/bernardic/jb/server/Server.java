package main.java.bernardic.jb.server;

import java.util.Properties;
import java.util.UUID;

import com.corundumstudio.socketio.BroadcastAckCallback;
import com.corundumstudio.socketio.Configuration;
import com.corundumstudio.socketio.SocketIOClient;
import com.corundumstudio.socketio.SocketIOServer;
import com.corundumstudio.socketio.listener.ConnectListener;

import main.java.bernardic.jb.server.handlers.AuthHandler;
import main.java.bernardic.jb.server.handlers.ChatHandler;
import main.java.bernardic.jb.server.handlers.FetchHandler;
import main.java.bernardic.jb.server.handlers.FirebaseHandler;
import main.java.bernardic.jb.server.handlers.GroupHandler;
import main.java.bernardic.jb.server.models.User;
import main.java.bernardic.jb.server.views.ChatMessageView;

public class Server {
	private static Database database;
	public static Database getDatabase() { return database; }
	private static SocketIOServer server;
	public static void main(String[] args) {
		Configs.init();
		
		Properties dbProps = Configs.get("database");
		database = new Database(dbProps.getProperty("url"), dbProps.getProperty("user"), dbProps.getProperty("password"));
		database.init();
		
		Configuration config = new Configuration();
		config.setPort(5000);
		server = new SocketIOServer(config);
		server.addConnectListener(new ConnectListener() {
			@Override
			public void onConnect(SocketIOClient client) {
				System.out.println("Connnected to " + client);
			}
		});
		
		FetchHandler fetchHandler = new FetchHandler(server);
		AuthHandler authHandler = new AuthHandler(server);
		GroupHandler groupHandler = new GroupHandler(server);
		ChatHandler chatHandler = new ChatHandler(server);
		FirebaseHandler firebaseHandler = new FirebaseHandler(server);
		
		authHandler.init();
		fetchHandler.init();
		groupHandler.init();
		chatHandler.init();
		firebaseHandler.init();
        server.start();
	}
	public static void sendMessage(ChatMessageView msg) {
		server.getRoomOperations(msg.getGroupUUID().toString()).sendEvent("message", msg, new BroadcastAckCallback<String>(String.class) {
			@Override
			protected void onClientSuccess(SocketIOClient client, String result) {
				super.onClientSuccess(client, result);
				//if msg delivered delete
				User user = database.getUser(UUID.fromString(result));
				database.deleteMessage(user, 0);
			}
		});
	}
}
