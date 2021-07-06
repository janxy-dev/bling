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
		database.addUser("jan", "123", "asd@gmail.com");
		User user = database.getUser("72e95131-4f0b-4fd1-8402-ddd38a35f25e");
		System.out.println(user.getEmail());
	}
}
