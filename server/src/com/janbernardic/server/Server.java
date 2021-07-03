package com.janbernardic.server;

public class Server {

	public static void main(String[] args) {
		Configs.init();
		System.out.println(Configs.get("database").getProperty("test"));
	}
}
