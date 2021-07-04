package main.java.bernardic.jb.server;

import java.util.Properties;

public class Server {

	public static void main(String[] args) {
		Configs.init();
		Properties dbProps = Configs.get("database");
		Database database = new Database(dbProps.getProperty("url"), dbProps.getProperty("user"), dbProps.getProperty("password"));
		database.testConnection();
	}
}
