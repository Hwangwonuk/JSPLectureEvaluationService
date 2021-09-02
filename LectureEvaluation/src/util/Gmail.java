package util;

import javax.mail.Authenticator; // 인증 수행을 도와주는 Authenticator 클래스
import javax.mail.PasswordAuthentication;

public class Gmail extends Authenticator {
	
	@Override
	protected PasswordAuthentication getPasswordAuthentication() {
		return new PasswordAuthentication("hok0173@gmail.com", "vpfmthsk3!"); 
		// 메일을 보낼 관리자 자신의 Gmail 계정의 id,pwd
		// google 계정 보안에 들어가서 보안 수준이 낮은 앱의 액세스 허용 체크해야한다. 구글입장에서는 낮은 보안이기 때문
	}
}
