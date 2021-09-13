package file;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import util.DatabaseUtil;


public class FileDAO {
	
	public int upload(String fileName, String fileRealName) { // 업로드
		String SQL = "INSERT INTO FILE VALUES (?, ?)";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			// DB접근하는 함수는 DatabaseUtil 외부 util에 정의를 함으로써 안정적으로 모듈화 함
			conn = DatabaseUtil.getConnection();	// DB와 연결
			pstmt = conn.prepareStatement(SQL);		// SQL실행 문자로 준비시킴
			pstmt.setString(1, fileName);			
			pstmt.setString(2, fileRealName);
			return pstmt.executeUpdate();			// DB실행문을 실행시킨 결과를 담음
			// 정상적인 수행결과는 1을 반환한다.
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			// Connection, PreparedStatement, ResultSet은 한번 사용이 되고나면 자원을 해제하여야 한다.
			// 서버에 무리가 가지 않도록 하기위해서
			try { if (conn != null) conn.close(); } catch (Exception e) { e.printStackTrace(); }
			try { if (pstmt != null) pstmt.close(); } catch (Exception e) { e.printStackTrace(); }
			try { if (rs != null) rs.close(); } catch (Exception e) { e.printStackTrace(); }
		}
		return -1; // 데이터베이스 오류
	}
}
