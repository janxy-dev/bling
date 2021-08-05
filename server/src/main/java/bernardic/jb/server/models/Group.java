package main.java.bernardic.jb.server.models;

import java.util.UUID;

public class Group {
	private final UUID groupUUID;
	private final String name;
	private final UUID[] members;
	public Group(UUID groupUUID, String name, UUID[] members) {
		this.groupUUID = groupUUID;
		this.name = name;
		this.members = members;
	}
	public UUID[] getMembers() {
		return members;
	}
	public String getName() {
		return name;
	}
	public UUID getGroupUUID() {
		return groupUUID;
	}
	public UUID getAdmin() {
		return members[0];
	}
	
}
