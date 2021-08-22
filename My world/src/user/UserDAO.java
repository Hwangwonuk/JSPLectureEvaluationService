package user;

import java.sql.PreparedStatement;

import util.DatabaseUtil;

import java.sql.Connection;

public class UserDAO { // 실질적으로 데이터베이스와 1:1로 연동되는 부분 DatabaseAccessObject
	
	public int join(String userID, String userPassword) {
		String SQL = "INSERT INTO USER VALUES (?, ?)";
		try {
			Connection conn = DatabaseUtil.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			pstmt.setString(2, userPassword);
			return pstmt.executeUpdate();	// 실제로 INSERT된 데이터의 개수
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
}
