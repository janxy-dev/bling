package com.janbernardic.server;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Properties;

public class Configs {
	
	private static HashMap<String, Properties> configs = new HashMap<String, Properties>();
	
	public static Properties get(String name) {
		return configs.get(name);
	}
	
	public static void init() {
		//Save default configs
		saveConfig("database");
	}
	
	@SuppressWarnings("resource")
	public static void saveConfig(String name) {
		try {
			Path path = Paths.get("./"+name+".properties");
			InputStream is;
			try {
				is = new FileInputStream(path.toString());
			} 
			catch (IOException e1) {
				is = Configs.class.getResourceAsStream("/resources/configs/" + path.getFileName());
				try {
					Files.copy(is, path);
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			Properties props = new Properties();
			props.load(is);
			is.close();
			configs.put(name, props);
		}catch(IOException e) {}
		


		
	}
}
