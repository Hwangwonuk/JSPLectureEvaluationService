package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DatabaseUtil { // 실질적으로 데이터베이스와 연동하는 부분
	
	public static Connection getConnection() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/tuto?characterEncoding=UTF-8&serverTimezone=UTC"; // 연동할 mysql
			String dbID = "root"; // 최고 권한 아이디
			String dbPassword = "111111"; // 권한 아이디의 비밀번호
			Class.forName("com.mysql.cj.jdbc.Driver"); // com.mysql.jdbc.Driver라는 클래스를 찾아서 사용하겠다.
			// 빌드했더니 아래 메시지 나와서 클래스 패키지명 com.mysql.cj.jdbc.Driver로 바꿈
			// Loading class `com.mysql.jdbc.Driver'. This is deprecated.
			// The new driver class is `com.mysql.cj.jdbc.Driver'.
			// The driver is automatically registered via the SPI and manual loading of the driver class
			// is generally unnecessary.
			
			return DriverManager.getConnection(dbURL, dbID, dbPassword); // 접속한 상태 자체를 반환
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null; // 오류가 발생하면 null값을 반환
	}
}
