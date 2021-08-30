package user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import util.DatabaseUtil;

public class UserDAO {

	public int login(String userID, String userPassword) { // 로그인 함수 정의
		String SQL = "SELECT userPassword FROM USER WHERE userID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			// DB접근하는 함수는 DatabaseUtil 외부 util에 정의를 함으로써 안정적으로 모듈화 함
			conn = DatabaseUtil.getConnection();	// DB와 연결
			pstmt = conn.prepareStatement(SQL);		// SQL실행 문자로 준비시킴
			pstmt.setString(1, userID);			// 사용자로부터 입력받은  ID값을 첫번째 물음표에 넣어줌
			rs = pstmt.executeQuery();				// DB실행문을 실행시킨 결과를 담음
			if (rs.next()) {						// 실행결과가 존재하는 경우에 한해서
				if (rs.getString(1).equals(userPassword)) {	
					return 1; // 로그인 성공
				}
				else {
					return 0; // 비밀번호 틀림
				}
			}
			return -1; // 아이디 없음
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			// Connection, PreparedStatement, ResultSet은 한번 사용이 되고나면 자원을 해제하여야 한다.
			// 서버에 무리가 가지 않도록 하기위해서
			try { if (conn != null) conn.close(); } catch (Exception e) { e.printStackTrace(); }
			try { if (pstmt != null) pstmt.close(); } catch (Exception e) { e.printStackTrace(); }
			try { if (rs != null) rs.close(); } catch (Exception e) { e.printStackTrace(); }
		}
		return -2; // 데이터베이스 오류
	}
	
	public int join(UserDTO user) { // 사용자의 정보를 입력받아 회원가입 수행
		String SQL = "INSERT INTO USER VALUES (?, ?, ?, ?, false)"; // id, pwd, email, hash, emailchecked
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();	// DB와 연결
			pstmt = conn.prepareStatement(SQL);		// SQL실행 문자로 준비시킴
			pstmt.setString(1,  user.getUserID());			
			pstmt.setString(2,  user.getUserPassword());
			pstmt.setString(3,  user.getUserEmail());
			pstmt.setString(4,  user.getUserEmailHash());
			return pstmt.executeUpdate();			// 실제로 반영된 데이터의 개수
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			// Connection, PreparedStatement, ResultSet은 한번 사용이 되고나면 자원을 해제하여야 한다.
			// 서버에 무리가 가지 않도록 하기위해서
			try { if (conn != null) conn.close(); } catch (Exception e) { e.printStackTrace(); }
			try { if (pstmt != null) pstmt.close(); } catch (Exception e) { e.printStackTrace(); }
			try { if (rs != null) rs.close(); } catch (Exception e) { e.printStackTrace(); }
		}
		return -1; // 회원가입 실패
	}
	
	public String getUserEmail(String userID) { // 사용자의 ID값을 받아서 사용자의 Email주소를 받아감
			String SQL = "SELECT userEmail FROM USER WHERE userID = ?"; // id, pwd, email, hash, emailchecked
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				conn = DatabaseUtil.getConnection();	// DB와 연결
				pstmt = conn.prepareStatement(SQL);		// SQL실행 문자로 준비시킴
				pstmt.setString(1, userID);
				rs = pstmt.executeQuery();
				if (rs.next()) { 						// 존재하는 아이디일 경우
					return rs.getString(1);
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				// Connection, PreparedStatement, ResultSet은 한번 사용이 되고나면 자원을 해제하여야 한다.
				// 서버에 무리가 가지 않도록 하기위해서
				try { if (conn != null) conn.close(); } catch (Exception e) { e.printStackTrace(); }
				try { if (pstmt != null) pstmt.close(); } catch (Exception e) { e.printStackTrace(); }
				try { if (rs != null) rs.close(); } catch (Exception e) { e.printStackTrace(); }
			}
			return null; // 데이터베이스 오류
	}
	
	// 이메일 인증이 되지 않으면, 강의평가를 작성할 수 없음
	public boolean getUserEmailChecked (String userID) { // 사용자의 아이디값을 입력받아 사용자가 이메일 검증이 되었는지 확인해야함
		String SQL = "SELECT userEmailChecked FROM USER WHERE userID = ?"; // id, pwd, email, hash, emailchecked
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();	// DB와 연결
			pstmt = conn.prepareStatement(SQL);		// SQL실행 문자로 준비시킴
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if (rs.next()) { 						// 존재하는 아이디일 경우
				return rs.getBoolean(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			// Connection, PreparedStatement, ResultSet은 한번 사용이 되고나면 자원을 해제하여야 한다.
			// 서버에 무리가 가지 않도록 하기위해서
			try { if (conn != null) conn.close(); } catch (Exception e) { e.printStackTrace(); }
			try { if (pstmt != null) pstmt.close(); } catch (Exception e) { e.printStackTrace(); }
			try { if (rs != null) rs.close(); } catch (Exception e) { e.printStackTrace(); }
		}
		return false; // 데이터베이스 오류
	}
	
	
	// 이메일 인증이 되지 않으면, 강의평가를 작성할 수 없음
	public boolean setUserEmailChecked (String userID) { // 특정한 사용자가 검증을통해 인증을 해주는 함수
		String SQL = "UPDATE USER SET userEmailChecked = true WHERE userID = ?";
		// userEmailChecked의 값을 true로 바꿔준다 이메일 인증되도록 처리
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();	// DB와 연결
			pstmt = conn.prepareStatement(SQL);		// SQL실행 문자로 준비시킴
			pstmt.setString(1, userID);
			pstmt.executeUpdate();
			return true; // 인증이 된 경우라도 한번 더 인증
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			// Connection, PreparedStatement, ResultSet은 한번 사용이 되고나면 자원을 해제하여야 한다.
			// 서버에 무리가 가지 않도록 하기위해서
			try { if (conn != null) conn.close(); } catch (Exception e) { e.printStackTrace(); }
			try { if (pstmt != null) pstmt.close(); } catch (Exception e) { e.printStackTrace(); }
			try { if (rs != null) rs.close(); } catch (Exception e) { e.printStackTrace(); }
		}
		return false; // 데이터베이스 오류
	}
}
