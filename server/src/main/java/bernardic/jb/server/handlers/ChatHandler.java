package main.java.bernardic.jb.server.handlers;

import com.corundumstudio.socketio.AckRequest;
import com.corundumstudio.socketio.SocketIOClient;
import com.corundumstudio.socketio.SocketIOServer;
import com.corundumstudio.socketio.listener.DataListener;

import main.java.bernardic.jb.server.Database;
import main.java.bernardic.jb.server.Server;
import main.java.bernardic.jb.server.packets.ChatMessagePacket;

public class ChatHandler {
	private SocketIOServer server;
	private Database db = Server.getDatabase();
	public ChatHandler(SocketIOServer server) {
		this.server = server;
	}
	
	public void init() {
		handleChatMessage();
	}
	
	public void handleChatMessage() {
		server.addEventListener("sendMessage", String.class, new DataListener<String>() {
			@Override
			public void onData(SocketIOClient client, String data, AckRequest ackSender) throws Exception {
				ChatMessagePacket packet = ChatMessagePacket.fromJson(data);
				if(!db.validateToken(packet.getToken())) return;
				db.addMessage(packet.getGroupUUID(), packet.getMessage());
			}
		});
	}
}
