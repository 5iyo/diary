package kr.ac.kumoh.oiyo.mydiaryback.service;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import kr.ac.kumoh.oiyo.mydiaryback.repository.*;
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
public class NaverService {

    @Autowired
    private UserRepository userRepository;

    public Map<String, Object> getNaverUserInfo(String accessToken){
        //요청하는 클라이언트마다 가진 정보가 다를 수 있기에 HashMap을 사용
        Map<String,Object> userInfo = new HashMap<>();
        String reqURL = "https://openapi.naver.com/v1/nid/me";
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
            JsonObject naver_account = element.getAsJsonObject().get("response").getAsJsonObject();

            String nickname = naver_account.getAsJsonObject().get("name").getAsString();
            String profile_image = naver_account.getAsJsonObject().get("profile_image").getAsString();
            String email = naver_account.getAsJsonObject().get("email").getAsString();

            userInfo.put("name", nickname);
            userInfo.put("email", email);
            userInfo.put("profile_image", profile_image);
        } catch (IOException e){
            e.printStackTrace();
        }
        return userInfo;
    }

    @Transactional
    public User registerNaverUserIfNeed (NaverDTO naverUserInfo)
    {
        String naverEmail = naverUserInfo.getN_email();
        String nickname = naverUserInfo.getN_name();
        String image = naverUserInfo.getN_image();
        User naverUser = userRepository.findByEmail(naverEmail).orElse(null);

//        회원이 없으면 회원가입
        if(naverUser == null) {
            naverUser = User.builder()
                    .email(naverEmail)
                    .username(nickname)
                    .profileImage(image)
                    .role(UserRole.USER)
                    .build();
            userRepository.save(naverUser);
        }
        return naverUser;
    }
}
