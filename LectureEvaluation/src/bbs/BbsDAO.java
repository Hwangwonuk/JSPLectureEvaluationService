package bbs;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import util.DatabaseUtil;

public class BbsDAO {
	
	public String getDate() { // 게시판 글 작성 시 현재 서버시간
		String SQL = "SELECT NOW()";  // 현재의 시간을 가져오는 MYSQL의 문장
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();	// DB와 연결
			pstmt = conn.prepareStatement(SQL);		// SQL실행 문자로 준비시킴
			rs = pstmt.executeQuery();				// 결과를 가져옴
			if (rs.next()) {						// 결과가 있는 경우
				return rs.getString(1);				// 현재의 날짜를 그대로 반환
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
		return ""; // 데이터베이스 오류
	}
	
	public int getNext() { 
		String SQL = "SELECT bbsID FROM BBS ORDER BY bbsID DESC"; // 내림차순 정렬 후 마지막에 쓰인 번호
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();	// DB와 연결
			pstmt = conn.prepareStatement(SQL);		// SQL실행 문자로 준비시킴
			rs = pstmt.executeQuery();				// 결과를 가져옴
			if (rs.next()) {						// 결과가 있는 경우
				return rs.getInt(1) + 1;			// 글 마지막 번호 + 1
			}
			return 1; 								// 현재가 첫번째 게시글인 경우 1리턴
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
	
	public int write(String bbsTitle, String userID, String bbsContent) { 
		String SQL = "INSERT INTO BBS VALUES (?, ?, ?, ?, ?, ?)"; // 내림차순 정렬 후 마지막에 쓰인 번호
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();	// DB와 연결
			pstmt = conn.prepareStatement(SQL);		// SQL실행 문자로 준비시킴
			pstmt.setInt(1, getNext());			
			pstmt.setString(2, bbsTitle);
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, bbsContent);
			pstmt.setInt(6, 1);						// available이니까 처음엔 글이 보여져야 하니까 1을 보여줘야함
			return pstmt.executeUpdate();
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
	
	public ArrayList<Bbs> getList(int bpageNumber){
		// 삭제가 되지 않아서 Avialable이 1인 글들만 가져옴 내림차순 정렬, 위에서부터 10개까지만 가져옴
		String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10"; 
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();	// DB와 연결
			pstmt = conn.prepareStatement(SQL);		// SQL실행 문자로 준비시킴
			// getNext()는 다음으로 작성될 글의 번호를 의미한다. 만약 글이 5개가 있다면 getNext()는 6이된다. 
			// pageNumber는 5개니까  1페이지가 되고 즉 위의 SQL 실행문에 ?에 6보다 작은것만 가져온다 라는 의미
			pstmt.setInt(1, getNext() - (bpageNumber - 1) * 10);	
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				list.add(bbs);
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
		return list; 
	}
	
	public boolean nextPage(int bpageNumber) { // 특정한 페이지가 존재하는지
	// 만약 게시글이 10개단위로 끊긴다고 생각하고 게시글이 10개라면 다음 페이지의 버튼이 나오지 않아야 한다. 이러한 페이지 처리를 위한 메소드
		String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1"; 
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();	// DB와 연결
			pstmt = conn.prepareStatement(SQL);		// SQL실행 문자로 준비시킴
			// getNext()는 다음으로 작성될 글의 번호를 의미한다. 만약 글이 5개가 있다면 getNext()는 6이된다. 
			// pageNumber는 5개니까  1페이지가 되고 즉 위의 SQL 실행문에 ?에 6보다 작은것만 가져온다 라는 의미
			pstmt.setInt(1, getNext() - (bpageNumber - 1) * 10);	
			rs = pstmt.executeQuery();
			if (rs.next()) { // 결과가 하나라도 존재한다면 
				return true; // 다음 페이지로 넘어갈 수 있다
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
		return false; 
	}
}
