package user;

public class UserDTO {
	
	String userID;
	String userPassword;
	
	// getter 현재의 데이터를 가져오는것
	// setter 데이터를 기록하는것
	
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getUserPassword() {
		return userPassword;
	}
	public void setUserPassword(String userPassword) {
		this.userPassword = userPassword;
	}
	
}
