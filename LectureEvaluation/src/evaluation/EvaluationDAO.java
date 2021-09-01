package evaluation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import util.DatabaseUtil;

// 강의 평가와 관련된 데이터베이스 접근을 직접적으로 가능하게 해주는 클래스
public class EvaluationDAO {
	
	public int write(EvaluationDTO evaluationDTO) { // 사용자가 한개의 강의평가 정보를 기록 할수있도록 해주는 글쓰기 메소드
		String SQL = "INSERT INTO EVALUATION VALUES (NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0)";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			// DB접근하는 함수는 DatabaseUtil 외부 util에 정의를 함으로써 안정적으로 모듈화 함
			conn = DatabaseUtil.getConnection();	// DB와 연결
			pstmt = conn.prepareStatement(SQL);		// SQL실행 문자로 준비시킴
			pstmt.setString(1, evaluationDTO.getUserID()); 				// 각각 일치하는 데이터를 넣어줌
			pstmt.setString(2, evaluationDTO.getLectureName());			
			pstmt.setString(3, evaluationDTO.getProfessorName());			
			pstmt.setInt(4, evaluationDTO.getLectureYear());							
			pstmt.setString(5, evaluationDTO.getSemesterDivide());			
			pstmt.setString(6, evaluationDTO.getLectureDivide());			
			pstmt.setString(7, evaluationDTO.getEvaluationTitle());			
			pstmt.setString(8, evaluationDTO.getEvaluationContent());			
			pstmt.setString(9, evaluationDTO.getTotalScore());			
			pstmt.setString(10, evaluationDTO.getCreditScore());			
			pstmt.setString(11, evaluationDTO.getComfortableScore());			
			pstmt.setString(12, evaluationDTO.getLectureScore());			
			return pstmt.executeUpdate();	// 실제로 INSERT 구문을 실행한 결과를 반환		
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
