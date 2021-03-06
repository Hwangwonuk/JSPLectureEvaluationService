package evaluation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

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
													// 각각 일치하는 데이터를 넣어줌
			// 시큐어 코딩을 위해 replaceAll() 구문 추가
			// XSS공격에 사용되는 script 구문을 작성할 수 있는 <,>를 html언어로 바꿔준다. \r\n 줄바꿈은 br태그로 바꿈
			// 게시글이 등록될 때 모든 <,>가 자동으로 치환이 되기 때문에 기본적으로 js구문을 삽입할 수가 까다로워진다.
			// 크로스 사이트 스크립팅(XSS)공격은 시중에 라이브러리를 사용하여 방어할 수 있다. 
			pstmt.setString(1, evaluationDTO.getUserID().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n", "<br />"));		
			pstmt.setString(2, evaluationDTO.getLectureName().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n", "<br />"));			
			pstmt.setString(3, evaluationDTO.getProfessorName().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n", "<br />"));			
			pstmt.setInt(4, evaluationDTO.getLectureYear()); // Int형이기 때문에 따로 처리할 필요 없음					
			pstmt.setString(5, evaluationDTO.getSemesterDivide().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n", "<br />"));			
			pstmt.setString(6, evaluationDTO.getLectureDivide().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n", "<br />"));			
			pstmt.setString(7, evaluationDTO.getEvaluationTitle().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n", "<br />"));			
			pstmt.setString(8, evaluationDTO.getEvaluationContent().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n", "<br />"));			
			pstmt.setString(9, evaluationDTO.getTotalScore().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n", "<br />"));			
			pstmt.setString(10, evaluationDTO.getCreditScore().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n", "<br />"));			
			pstmt.setString(11, evaluationDTO.getComfortableScore().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n", "<br />"));			
			pstmt.setString(12, evaluationDTO.getLectureScore().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n", "<br />"));			
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
	
	public ArrayList<EvaluationDTO> getList (String lectureDivide, String searchType, String search, int pageNumber) {
	// 사용자가 검색한 내용에 대한 결과를 강의평가 글로서 반환하도록 만듬 한페이지당 다섯개씩 평가글이 출력되도록 만들어 줄 것이다. pageNumber사용
		if(lectureDivide.equals("전체")) { // 사용자가 전체로 검색했다면
			lectureDivide = "";
		}
		ArrayList<EvaluationDTO> evaluationList = null;
		String SQL = "";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			if(searchType.equals("최신순")) { // LIKE는 MY SQL 문법중 하나인데 특정한 문자열을 포함하는지 확인할 때 사용함
				SQL = "SELECT * FROM EVALUATION WHERE lectureDivide LIKE ? AND CONCAT(lectureName, professorName, evaluationTitle, evaluationContent) LIKE " +
						"? ORDER BY evaluationID DESC LIMIT " + pageNumber * 5 + ", " + pageNumber * 5 + 6;
				// 강의제목,교수이름,평가제목,평가내용을 모두 합친 문자열이 어떠한 문자열을 포함하고 있는지 물어본다
				// 그 결과를 evaluationID 값으로 내림차순 정렬해서 최신순대로 출력 LIMIT를 이용하여 총 6개의 게시글을출력(다음페이지로 넘어가게), 페이지가 넘어갈 때 마다 5개씩 글출력
			} else if (searchType.equals("추천순")) { // 추천순으로 출력
				SQL = "SELECT * FROM EVALUATION WHERE lectureDivide LIKE ? AND CONCAT(lectureName, professorName, evaluationTitle, evaluationContent) LIKE " +
						"? ORDER BY likeCount DESC LIMIT " + pageNumber * 5 + ", " + pageNumber * 5 + 6;
			}
			conn = DatabaseUtil.getConnection();			// DB와 연결
			pstmt = conn.prepareStatement(SQL);				// SQL실행 문자로 준비시킴
			pstmt.setString(1, "%" + lectureDivide + "%");	// %는 MySQL 문법중 하나인데, LIKE다음에 %문자열%이 오면 그 문자열을 포함하는지 물어보는것이다
			// lectureDivide는 전체,교양,전공,기타가 있고 전체는 공백으로 치환해서 항상 포함하게 만들고, 나머지는 해당 글자와 동일한 결과만 출력됨
			pstmt.setString(2, "%" + search + "%");			// 두번째?는 강의명,교수명,평가제목,평가내용을 다 포함한 문자열에 사용자가 검색한 내용이 포함되어 있는지
			rs = pstmt.executeQuery();						// DB실행문을 실행시킨 결과를 담음
			evaluationList = new ArrayList<EvaluationDTO>();// 강의평가가 담기는 리스트를 초기화
			while (rs.next()) {								// 모든 게시물이 존재할 때 마다
				EvaluationDTO evaluation = new EvaluationDTO(
						rs.getInt(1), 		// 특정한 결과가 나올 때 마다 결과를 이용해서 초기화
						rs.getString(2),	// userID
						rs.getString(3),
						rs.getString(4),
						rs.getInt(5),
						rs.getString(6),
						rs.getString(7),
						rs.getString(8),
						rs.getString(9),
						rs.getString(10),
						rs.getString(11),
						rs.getString(12),
						rs.getString(13),
						rs.getInt(14)
				);
				evaluationList.add(evaluation); // 모든 강의평가 데이터를 리스트에 담음
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
		return evaluationList; // 리스트에 담긴 결과를 반환
	}
	
	public int like(String evaluationID) {
		String SQL = "UPDATE EVALUATION SET likeCount = likeCount + 1 WHERE evaluationID = ?";
		// 특정한 강의평가 글의 likeCount를 1증가
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();	// DB와 연결
			pstmt = conn.prepareStatement(SQL);		// SQL실행 문자로 준비시킴
			pstmt.setInt(1, Integer.parseInt(evaluationID));
			return pstmt.executeUpdate();			// 실행한 결과를 반환
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
	
	public int delete(String evaluationID) {
		String SQL = "DELETE FROM EVALUATION WHERE evaluationID = ?";
		// 특정한 강의평가 글을 삭제
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();	// DB와 연결
			pstmt = conn.prepareStatement(SQL);		// SQL실행 문자로 준비시킴
			pstmt.setInt(1, Integer.parseInt(evaluationID));
			return pstmt.executeUpdate();			// 실행한 결과를 반환
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
	
	public String getUserID(String evaluationID) {
		// 특정한 강의평가 글을 작성한 사용자의 ID를 구하는 메소드
		String SQL = "SELECT userID FROM EVALUATION WHERE evaluationID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();	// DB와 연결
			pstmt = conn.prepareStatement(SQL);		// SQL실행 문자로 준비시킴
			pstmt.setInt(1, Integer.parseInt(evaluationID));
			rs = pstmt.executeQuery();
			if (rs.next()) { 						// 결과가 존재하는 경우
				return rs.getString(1);				// 아이디 값을 반환
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
		return null; // 존재하지 않는 아이디
	}
}
