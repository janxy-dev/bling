package main.java.bernardic.jb.server.handlers;

import java.util.UUID;

import com.corundumstudio.socketio.AckRequest;
import com.corundumstudio.socketio.BroadcastAckCallback;
import com.corundumstudio.socketio.SocketIOClient;
import com.corundumstudio.socketio.SocketIOServer;
import com.corundumstudio.socketio.listener.DataListener;

import main.java.bernardic.jb.server.Database;
import main.java.bernardic.jb.server.Server;
import main.java.bernardic.jb.server.models.Group;
import main.java.bernardic.jb.server.models.User;
import main.java.bernardic.jb.server.packets.ChatMessagePacket;
import main.java.bernardic.jb.server.views.ChatMessageView;

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
				try {
					ChatMessagePacket packet = ChatMessagePacket.fromJson(data);
					User user = db.getUser(UUID.fromString(packet.getToken()));
					if(user == null) return;
					Group group = db.getGroup(UUID.fromString(packet.getGroupUUID()));
					if(group == null) return;
					for(int i = 0; i<group.getMembers().length; i++) {
						db.addMessage(group.getMembers()[i], group.getGroupUUID(), packet.getMessage(), user.getUsername());
					}
					ChatMessageView msg = new ChatMessageView(group.getGroupUUID(), packet.getMessage(), user.getUsername());
					server.getRoomOperations(packet.getGroupUUID()).sendEvent("message", msg, new BroadcastAckCallback<String>(String.class) {
						@Override
						protected void onClientSuccess(SocketIOClient client, String result) {
							super.onClientSuccess(client, result);
							//if msg delivered delete
							System.out.println(client);
							System.out.println(result);
							User user = db.getUser(UUID.fromString(result));
							db.deleteMessages(user);
						}
					});
				}catch(Exception e) {
					e.printStackTrace();
				}
			}
		});
	}
}
