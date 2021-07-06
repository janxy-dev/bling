package main.java.bernardic.jb.server;

import java.util.Properties;

public class Server {
	private static Database database;
	public static Database getDatabase() { return database; }
	public static void main(String[] args) {
		Configs.init();
		Properties dbProps = Configs.get("database");
		database = new Database(dbProps.getProperty("url"), dbProps.getProperty("user"), dbProps.getProperty("password"));
		database.testConnection();
		database.createUsers();
	}
}
