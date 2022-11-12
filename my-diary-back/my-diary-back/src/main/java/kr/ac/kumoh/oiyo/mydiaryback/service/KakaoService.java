package kr.ac.kumoh.oiyo.mydiaryback.service;

import kr.ac.kumoh.oiyo.mydiaryback.repository.KakaoDTO;
import kr.ac.kumoh.oiyo.mydiaryback.repository.User;
import kr.ac.kumoh.oiyo.mydiaryback.repository.UserRepository;
import kr.ac.kumoh.oiyo.mydiaryback.repository.UserRole;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;


import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.springframework.transaction.annotation.Transactional;

@Service
public class KakaoService {
    @Value("${social.kakao.env.client-id}")
    private String CLIENT_ID;

    @Value("${social.kakao.env.redirect-uri}")
    private String REDIRECT_URI;

    @Autowired
    private UserRepository userRepository;


//    인가 코드를 받아서 카카오에 AccessToken을 요청하고,
//    전달 받은 AccessToken을 return한다.
    public String getAccessKakaoToken(String authorize_code){
        String access_Token = "";
        String refresh_Token = "";
        String reqURL = "https://kauth.kakao.com/oauth/token";

        try {
            URL url = new URL(reqURL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();

            //POST요청을 위해 기본값이 false인 setDoOutPut을 true로 설정
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);

            //POST 요청에 필요로 요구하는 파라미터 스트림을 통해 전송
            BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()));
            StringBuilder sb = new StringBuilder();
            sb.append("grant_type=authorization_code");
            sb.append("&client_id="+CLIENT_ID);
            sb.append("&redirect_uri="+REDIRECT_URI);
            sb.append("&code="+authorize_code);
            bw.write(sb.toString());
            bw.flush();

            //결과 코드가 200이면 성공
            int responseCode = conn.getResponseCode();
            System.out.println("responseCode : "+responseCode);

            //요청을 통해 얻은 JSON타입의 Response 메세지 읽어오기
            BufferedReader br = new BufferedReader((new InputStreamReader(conn.getInputStream())));
            String line = "";
            String result = "";

            while((line = br.readLine()) != null){
                result += line;
            }
            System.out.println("responsebody : "+result);

            //Gson 라이브러리에 포함된 클래스로 JSON파싱 객체 생성
            JsonElement element = JsonParser.parseString(result);

            access_Token = element.getAsJsonObject().get("access_token").getAsString();
            refresh_Token = element.getAsJsonObject().get("refresh_token").getAsString();

            System.out.println("access_token : " + access_Token);
            System.out.println("refresh_token : " + refresh_Token);

            br.close();
            bw.close();
        } catch (IOException e){
            e.printStackTrace();
        }
        return access_Token;
    }

//    AccessToken을 받아서 User정보를 획득하고 return한다.
    public Map<String, Object> getKakaoUserInfo(String access_Token){
        //요청하는 클라이언트마다 가진 정보가 다를 수 있기에 HashMap을 사용
        Map<String,Object> userInfo = new HashMap<>();
        String reqURL = "https://kapi.kakao.com/v2/user/me";
        try {
            URL url = new URL(reqURL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            //요청에 필요한 Header에 포함될 내용
            conn.setRequestProperty("Authorization", "Bearer " + access_Token);

            int responseCode = conn.getResponseCode();
            System.out.println("responseCode : " + responseCode);
            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));

            String line = "";
            String result = "";

            while ((line = br.readLine()) != null) {
                result += line;
            }
            System.out.println("response body : " + result);

            JsonElement element = JsonParser.parseString(result);
            JsonObject properties = element.getAsJsonObject().get("properties").getAsJsonObject();
            JsonObject kakao_account = element.getAsJsonObject().get("kakao_account").getAsJsonObject();

            String nickname = properties.getAsJsonObject().get("nickname").getAsString();
            String profile_image = properties.getAsJsonObject().get("profile_image").getAsString();
            String email = kakao_account.getAsJsonObject().get("email").getAsString();

            userInfo.put("nickname", nickname);
            userInfo.put("email", email);
            userInfo.put("profile_image", profile_image);
        } catch (IOException e){
            e.printStackTrace();
        }
        return userInfo;
    }

    public String kakaoLogout(String access_Token) {
        String reqURL = "https://kapi.kakao.com/v1/user/logout";
        try{
            URL url = new URL(reqURL);

            HttpURLConnection conn = (HttpURLConnection) url.openConnection();

//            POST 요청을 위해 기본값이 false인 setDoOutPut을 true로
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);

//            요청에 필요한 Header에 포함될 내용
             conn.setRequestProperty("Authorization", "Bearer "+access_Token);

//             결과 코드가 200이라면 성공
            int responseCode = conn.getResponseCode();
            System.out.println("responseCode : "+responseCode);

//            요청을 통해 얻은 JSON타입의 Response 메세지 읽어오기
            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String line = "";
            String result = "";

            while ((line = br.readLine()) != null){
                result +=line;
            }
            System.out.println("response body : "+result);
            br.close();
        }catch (IOException e){
            e.printStackTrace();
        }
        return access_Token;
    }

    @Transactional
    public User registerKakaoUserIfNeed (KakaoDTO kakaoUserInfo)
    {
        String kakaoEmail = kakaoUserInfo.getK_email();
        String nickname = kakaoUserInfo.getK_name();
        User kakaoUser = userRepository.findByEmail(kakaoEmail).orElse(null);

//        회원이 없으면 회원가입
        if(kakaoUser == null) {
            kakaoUser = User.builder()
                    .email(kakaoEmail)
                    .username(nickname)
                    .role(UserRole.USER)
                    .build();
            userRepository.save(kakaoUser);
        }
        return kakaoUser;
    }
}
