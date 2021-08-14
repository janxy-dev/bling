package main.java.bernardic.jb.server.handlers;

import java.io.FileInputStream;
import java.util.HashMap;

import org.json.JSONObject;

import com.corundumstudio.socketio.AckRequest;
import com.corundumstudio.socketio.SocketIOClient;
import com.corundumstudio.socketio.SocketIOServer;
import com.corundumstudio.socketio.listener.DataListener;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;

public class FirebaseHandler {
	private SocketIOServer server;
	private static FirebaseHandler instance;
	public static FirebaseHandler getInstance() {return instance;}
	public FirebaseHandler(SocketIOServer server) {
		this.server = server;
		instance = this;
	}
	
	@SuppressWarnings("deprecation")
	public void init() {
		try {
			FileInputStream serviceAccount = new FileInputStream("serviceAccountKey.json");
			FirebaseOptions	options = new FirebaseOptions.Builder()
					  .setCredentials(GoogleCredentials.fromStream(serviceAccount))
					  .build();
			FirebaseApp.initializeApp(options);
			handleFirebaseToken();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	HashMap<String, String> clients = new HashMap<>();
	
	public void handleFirebaseToken() {
		server.addEventListener("firebaseToken", String.class, new DataListener<String>() {
			@Override
			public void onData(SocketIOClient client, String data, AckRequest ackSender) throws Exception {
				try {
					JSONObject json = new JSONObject(data);
					clients.put(json.getString("token"), json.getString("firebaseToken"));
				}catch(Exception e) {
					e.printStackTrace();
				}
			}
		});
	}
	
	void pushMessageNotification(String token) {
		String firebaseToken = clients.get(token);
		if(firebaseToken == null) return;
		try {
			FirebaseMessaging.getInstance().send(Message.builder().setToken(firebaseToken).setNotification(Notification.builder()
					.setTitle("Bling")
					.setBody("New message!").build()).build());
		} catch (FirebaseMessagingException e) {
			e.printStackTrace();
		}
	}
}
