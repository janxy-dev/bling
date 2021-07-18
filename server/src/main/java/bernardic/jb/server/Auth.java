package main.java.bernardic.jb.server;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.corundumstudio.socketio.AckRequest;
import com.corundumstudio.socketio.SocketIOClient;
import com.corundumstudio.socketio.SocketIOServer;
import com.corundumstudio.socketio.listener.DataListener;

import main.java.bernardic.jb.server.models.LoginModel;
import main.java.bernardic.jb.server.models.RegisterModel;

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
			public void onData(SocketIOClient client, String _data, AckRequest ackSender) throws Exception {
				LoginModel data = LoginModel.fromJson(_data);
				String username = data.getUsername();
				String password = data.getPassword();
				String token = Server.getDatabase().authUser(username, password);
				if(token == null) token = "*Password or/and username is invalid!\n";
				client.sendEvent("login", token);
			}
        });
	}
	private boolean checkInvalidCharacters(String string) {
		Pattern p = Pattern.compile("[^a-z0-9._+-]", Pattern.CASE_INSENSITIVE);
		Matcher m = p.matcher(string);
		return m.find();
	}
	private void handleRegister() {
        server.addEventListener("register", String.class, new DataListener<String>() {
			@Override
			public void onData(SocketIOClient client, String _data, AckRequest ackSender) throws Exception {
				RegisterModel data = RegisterModel.fromJson(_data);
				String username = data.getUsername();
				String email = data.getEmail();
				String password = data.getPassword();
				String conPassword = data.getConfirmedPassword();
				String error = "";
				if(Server.getDatabase().hasUsername(username)) error += "Username is in use!\n";
				if(username.isEmpty()) error += "Username field is empty!\n";
				if(checkInvalidCharacters(username)) error += "Username contains invalid characters!\n";
				if(Server.getDatabase().hasEmail(email)) error += "Email is in use!\n";
				if(email.isEmpty()) error += "Email field is empty!\n";
				if(checkInvalidCharacters(email)) error += "Email contains invalid characters!\n";
				if(!password.equals(conPassword)) error += "Passwords don't match!\n";
				if(password.isEmpty()) error += "Password field is empty!\n";
				if(error.isEmpty()) {
					client.sendEvent("login", Server.getDatabase().addUser(username, password, email));
				}
				else client.sendEvent("login", '*'+error);
			}
        });
	}
	
}
