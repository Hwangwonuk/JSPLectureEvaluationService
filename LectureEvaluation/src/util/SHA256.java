package util;

import java.security.MessageDigest;

public class SHA256 {
// 일반적으로 회원가입 이후에 이메일 인증을 할 때 기존에 존재하는 이메일값에 HASH값을 적용해서 사용자가 그것을 인증코드로 링크를 타고 들어와서 인증을 할수있도록 개발함
	// 이메일값(input)에 hash를 적용한 값을 이용해서 반환하겠다.
	public static String getSHA256(String input) {
		StringBuffer result = new StringBuffer();
		try {
			MessageDigest digest = MessageDigest.getInstance("SHA-256"); 
			// Digest를 이용해서 실제로 사용자가 입력한 값을 SHA-256으로 알고리즘 적용할 수 있도록 만듬
			byte[] salt = "Hello! This is Salt.".getBytes();
			// salt는 단순하게 SHA256을 적용하게 되면 해커에 의해서 해킹을당할 가능성이 높아지기 때문에 일반적으로 salt값을 적용 hex
			digest.reset();
			digest.update(salt); // salt값 적용
			byte[] chars = digest.digest(input.getBytes("UTF-8"));
			// 실제로 HASH를 적용한 값을 chars에 담아준다
			for (int i = 0; i < chars.length; i++) { // 그것을 문자열 형태로 만들어준다.
				String hex = Integer.toHexString(0xff & chars[i]);
				// 0xff hex값과 현재 hash값을 적용한 캐릭터의 해당 인덱스를 
				if (hex.length() == 1) result.append("0");
				// 1자리수인 경우에는 0을 붙여서 총 2자리 값을 가지는 16진수 형태로 출력되게 만듬
				result.append(hex);
				// hex값을 뒤에 차근차근 달아서 
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result.toString();
		// 해당 hash값을 반환하도록 만듬
	} 
	
}
