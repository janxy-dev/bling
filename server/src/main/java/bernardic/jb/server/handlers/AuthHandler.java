package main.java.bernardic.jb.server.handlers;

import java.util.ArrayList;
import java.util.regex.Matcher;

import java.util.regex.Pattern;

import com.corundumstudio.socketio.AckRequest;
import com.corundumstudio.socketio.SocketIOClient;
import com.corundumstudio.socketio.SocketIOServer;
import com.corundumstudio.socketio.listener.DataListener;

import main.java.bernardic.jb.server.Server;
import main.java.bernardic.jb.server.packets.LoginPacket;
import main.java.bernardic.jb.server.packets.RegisterPacket;
import main.java.bernardic.jb.server.views.AuthResponseView;

public class AuthHandler {
	SocketIOServer server;
	public AuthHandler(SocketIOServer server) {
		this.server = server;
	}
	public void init() {
		handleLogin();
		handleRegister();
	}
	private void handleLogin() {
        server.addEventListener("login", String.class, new DataListener<String>() {
			@Override
			public void onData(SocketIOClient client, String _data, AckRequest ackSender) throws Exception {
				LoginPacket data = LoginPacket.fromJson(_data);
				String username = data.getUsername();
				String password = data.getPassword();
				String token = Server.getDatabase().authUser(username, password);
				if(token == null) {
					ackSender.sendAckData(new AuthResponseView(false, null, new String[] {"Password or/and username is invalid!"}));
				}
				ackSender.sendAckData(new AuthResponseView(true, token, null));
			}
        });
	}
	private boolean usernameCharacters(String string) {
		Pattern p = Pattern.compile("^$|[a-z0-9._-]", Pattern.CASE_INSENSITIVE);
		Matcher m = p.matcher(string);
		return m.find();
	}
	private boolean emailCharacters(String string) {
		Pattern p = Pattern.compile("^$|[a-z0-9._+@-]", Pattern.CASE_INSENSITIVE);
		Matcher m = p.matcher(string);
		return m.find();
	}
	private void handleRegister() {
        server.addEventListener("register", String.class, new DataListener<String>() {
			@Override
			public void onData(SocketIOClient client, String _data, AckRequest ackSender) throws Exception {
				try {
					RegisterPacket data = RegisterPacket.fromJson(_data);
					String username = data.getUsername();
					String email = data.getEmail();
					String password = data.getPassword();
					String conPassword = data.getConfirmedPassword();
					ArrayList<String> error = new ArrayList<String>();
					if(Server.getDatabase().hasUsername(username)) error.add("Username is in use!");
					if(username.isEmpty()) error.add("Username field is empty!");
					if(!usernameCharacters(username)) error.add("Username contains invalid characters!");
					if(Server.getDatabase().hasEmail(email)) error.add("Email is in use!");
					if(email.isEmpty()) error.add("Email field is empty!");
					if(!emailCharacters(email)) error.add("Email contains invalid characters!");
					if(!password.equals(conPassword)) error.add("Passwords don't match!");
					if(password.isEmpty()) error.add("Password field is empty!\n");
					if(error.isEmpty()) {
						String token = Server.getDatabase().addUser(username, password, email);
						ackSender.sendAckData(new AuthResponseView(true, token, null));
					}
					else ackSender.sendAckData(new AuthResponseView(false, null, error.toArray(new String[0])));;	
				}catch(Exception e) {
					e.printStackTrace();
				}
			}
        });
	}
	
}
