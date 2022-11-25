package kr.ac.kumoh.oiyo.mydiaryback.service;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import kr.ac.kumoh.oiyo.mydiaryback.domain.KakaoDTO;
import kr.ac.kumoh.oiyo.mydiaryback.domain.User;
import kr.ac.kumoh.oiyo.mydiaryback.domain.UserRepository;
import kr.ac.kumoh.oiyo.mydiaryback.domain.UserRole;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

@Service
public class KakaoService {
    @Autowired
    private UserRepository userRepository;

//    AccessToken을 받아서 User정보를 획득하고 return한다.
    public Map<String, Object> getKakaoUserInfo(String accessToken){
        //요청하는 클라이언트마다 가진 정보가 다를 수 있기에 HashMap을 사용
        Map<String,Object> userInfo = new HashMap<>();
        String reqURL = "https://kapi.kakao.com/v2/user/me";
        try {
            URL url = new URL(reqURL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            //요청에 필요한 Header에 포함될 내용
            conn.setRequestProperty("Authorization", "Bearer " + accessToken);

            int responseCode = conn.getResponseCode();
            System.out.println("responseCode : " + responseCode);
            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));

            String line = "";
            String result = "";

            while ((line = br.readLine()) != null) {
                result += line;
            }
            System.out.println("response body : " + result);

            JsonElement element = JsonParser.parseString(result);
            JsonObject properties = element.getAsJsonObject().get("properties").getAsJsonObject();
            JsonObject kakao_account = element.getAsJsonObject().get("kakao_account").getAsJsonObject();
            JsonObject profile = kakao_account.getAsJsonObject().get("profile").getAsJsonObject();

            String nickname = properties.getAsJsonObject().get("nickname").getAsString();
            String profile_image = profile.getAsJsonObject().get("profile_image_url").getAsString();
            String email = kakao_account.getAsJsonObject().get("email").getAsString();

            userInfo.put("nickname", nickname);
            userInfo.put("email", email);
            userInfo.put("profile_image", profile_image);
        } catch (IOException e){
            e.printStackTrace();
        }
        return userInfo;
    }

    public String kakaoLogout(String accessToken) {
        String reqURL = "https://kapi.kakao.com/v1/user/logout";
        try{
            URL url = new URL(reqURL);

            HttpURLConnection conn = (HttpURLConnection) url.openConnection();

//            POST 요청을 위해 기본값이 false인 setDoOutPut을 true로
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);

//            요청에 필요한 Header에 포함될 내용
             conn.setRequestProperty("Authorization", "Bearer "+accessToken);

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
        return accessToken;
    }

    @Transactional
    public User registerKakaoUserIfNeed (KakaoDTO kakaoUserInfo)
    {
        String kakaoEmail = kakaoUserInfo.getK_email();
        String nickname = kakaoUserInfo.getK_name();
        String image = kakaoUserInfo.getK_image();
        User kakaoUser = userRepository.findByEmail(kakaoEmail).orElse(null);

//        회원이 없으면 회원가입
        if(kakaoUser == null) {
            kakaoUser = User.builder()
                    .email(kakaoEmail)
                    .username(nickname)
                    .profileImage(image)
                    .role(UserRole.USER)
                    .build();
            userRepository.save(kakaoUser);
        }
        return kakaoUser;
    }
}
