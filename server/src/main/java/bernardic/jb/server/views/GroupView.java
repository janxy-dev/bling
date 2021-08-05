package main.java.bernardic.jb.server.views;

import java.util.UUID;

import org.json.JSONArray;

import main.java.bernardic.jb.server.Server;
import main.java.bernardic.jb.server.models.Group;

public class GroupView {
	private final UUID groupUUID;
	private final String name;
	private final JSONArray members;
	public GroupView(Group group) {
		this.groupUUID = group.getGroupUUID();
		this.name = group.getName();
		UUID[] members = group.getMembers();
		String[] usernames = new String[members.length];
		for(int i = 0; i<members.length; i++) {
			UUID token = members[i];
			usernames[i] = Server.getDatabase().getUser(token).getUsername();
		}
		this.members = new JSONArray(usernames); 
	}
	public UUID getGroupUUID() {
		return groupUUID;
	}
	public String getName() {
		return name;
	}
	public JSONArray getMembers() {
		return members;
	}
}

