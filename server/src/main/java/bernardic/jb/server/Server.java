package main.java.bernardic.jb.server;

import java.util.Properties;

import com.corundumstudio.socketio.AckRequest;
import com.corundumstudio.socketio.Configuration;
import com.corundumstudio.socketio.SocketIOClient;
import com.corundumstudio.socketio.SocketIOServer;
import com.corundumstudio.socketio.listener.ConnectListener;
import com.corundumstudio.socketio.listener.DataListener;

public class Server {
	private static Database database;
	public static Database getDatabase() { return database; }
	public static void main(String[] args) {
		Configs.init();
		Properties dbProps = Configs.get("database");
		database = new Database(dbProps.getProperty("url"), dbProps.getProperty("user"), dbProps.getProperty("password"));
		database.testConnection();
		database.createUsers();
		database.addUser("jan", "123", "asd@gmail.com");
		Configuration config = new Configuration();
		config.setHostname("localhost");
		config.setPort(5000);
		final SocketIOServer server = new SocketIOServer(config);
		server.addConnectListener(new ConnectListener() {
			@Override
			public void onConnect(SocketIOClient client) {
				System.out.println("Connnected to " + client);
			}
		});
        server.addEventListener("login", String.class, new DataListener<String>() {
			@Override
			public void onData(SocketIOClient client, String data, AckRequest ackSender) throws Exception {
				String[] _data = data.split(":");
				System.out.println(_data[0] + ", " + _data[1]);
			}
        });
        server.start();
		
		
	}
}
