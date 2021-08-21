package user;

public class UserDTO {
	
	String userId;
	String userPassword;
	
	// getter 현재의 데이터를 가져오는것
	// setter 데이터를 기록하는것
	
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserPassword() {
		return userPassword;
	}
	public void setUserPassword(String userPassword) {
		this.userPassword = userPassword;
	}
	
}
