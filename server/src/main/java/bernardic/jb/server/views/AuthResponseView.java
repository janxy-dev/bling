package main.java.bernardic.jb.server.views;

public class AuthResponseView{
	private final boolean ok;
	private final String token;
	private final String[] errors;
	public AuthResponseView(boolean ok, String token, String[] errors) {
		this.ok = ok;
		this.token = token;
		this.errors = errors;
	}
	public boolean isOk() {
		return ok;
	}
	public String getToken() {
		return token;
	}
	public String[] getErrors() {
		return errors;
	}
}
