package main.java.bernardic.jb.server;

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
	
	public static void saveConfig(String name) {
		try {
			Path path = Paths.get("./"+name+".properties");
			if(!Files.exists(path)) {
				InputStream is = Configs.class.getResourceAsStream("/main/resources/configs/" + path.getFileName());
				Files.copy(is, path);
				is.close();
			}
			InputStream is = new FileInputStream(path.toString());
			Properties props = new Properties();
			props.load(is);
			is.close();
			configs.put(name, props);
		}catch(IOException e) {}	
	}
}
