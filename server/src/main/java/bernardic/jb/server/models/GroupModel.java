package main.java.bernardic.jb.server.models;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

public class GroupModel {
	private JSONArray admins;
	private String groupUUID = null;
	private String name = null;
	private List<String> members = new ArrayList<>();
	public List<String> getMembers() {
		return members;
	}
	public GroupModel setMembers(String[] members) {
		this.members = Arrays.asList(members);
		return this;
	}
	public String getName() {
		return name;
	}
	public GroupModel setName(String name) {
		this.name = name;
		return this;
	}
	public GroupModel setGroupUUID(String uuid) {
		this.groupUUID = uuid;
		return this;
	}
	public String getGroupUUID() {
		return groupUUID;
	}
	public JSONArray getAdmins() {
		return admins;
	}
	public GroupModel setAdmins(JSONArray admins) {
		this.admins = admins;
		return this;
	}
	public static GroupModel fromJson(String jsonString) {
		JSONObject json = new JSONObject(jsonString);
		return new GroupModel().setName(json.getString("name")).setAdmins(json.getJSONArray("admins"));
	}
	
}
