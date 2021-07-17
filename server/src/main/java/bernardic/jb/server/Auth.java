package main.java.bernardic.jb.server;

import com.corundumstudio.socketio.AckRequest;
import com.corundumstudio.socketio.SocketIOClient;
import com.corundumstudio.socketio.SocketIOServer;
import com.corundumstudio.socketio.listener.DataListener;

public class Auth {
	SocketIOServer server;
	public Auth(SocketIOServer server) {
		this.server = server;
	}
	public void init() {
		handleLogin();
		handleRegister();
	}
	private void handleLogin() {
        server.addEventListener("login", String.class, new DataListener<String>() {
			@Override
			public void onData(SocketIOClient client, String data, AckRequest ackSender) throws Exception {
				String[] _data = data.split(":");
				String username = _data[0];
				String password = _data[1];
				String token = Server.getDatabase().authUser(username, password);
				if(token == null) token = "*Password or/and username is invalid!\n";
				client.sendEvent("login", token);
			}
        });
	}
	private void handleRegister() {
        server.addEventListener("register", String.class, new DataListener<String>() {
			@Override
			public void onData(SocketIOClient client, String data, AckRequest ackSender) throws Exception {
				String[] _data = data.split(":");
				String username = _data[0];
				String email = _data[1];
				String password = _data[2];
				String conPassword = _data[3];
				String error = "";
				//check if username is already in use
				if(Server.getDatabase().hasUsername(username)) {
					error += "Username is in use!\n";
				}
				if(Server.getDatabase().hasEmail(email)) {
					error += "Email is in use!\n";
				}
				if(!password.equals(conPassword)) {
					error+= "Passwords don't match!\n";
				}
				if(error.isEmpty()) {
					client.sendEvent("login", Server.getDatabase().addUser(username, password, email));
				}
				else client.sendEvent("login", '*'+error);
				
			}
        });
	}
	
}
