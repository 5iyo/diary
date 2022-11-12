package kr.ac.kumoh.oiyo.mydiaryback.controller;

import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.UserRecord;
import com.google.firebase.auth.UserRecord.CreateRequest;
import com.google.firebase.auth.UserRecord.UpdateRequest;

import kr.ac.kumoh.oiyo.mydiaryback.domain.User;
import kr.ac.kumoh.oiyo.mydiaryback.domain.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.http.HttpHeaders;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.LogManager;
import java.util.logging.Logger;


import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

@Service
public class KakaoService {
    private static final Logger log = LogManager.getLogManager().getLogger(String.valueOf(KakaoService.class));

    @Autowired
    private UserRepository mr;

//    getAccessToken()과 getUserInfo()를 호출한다.
//    public Map<String, Object> execKakaoLogin(String authorize_code){
//        Map<String,Object> result = new HashMap<String, Object>();
//        //get access token
//        String accessToken = getAccessKakaoToken(authorize_code);
//        result.put("accessToken",accessToken);
//        //read user info
//        Map<String, Object> userInfo = getKakaoUserInfo(accessToken);
//        result.put("userInfo",userInfo);
//
////        Firebase Customtoken 발행
//        if(userInfo != null){
//            try{
//                result.put("customToken", createFirebaseCustomToken(userInfo));
//                result.put("errYn","N");
//                result.put("errMsg","");
//            }catch (FirebaseAuthException e){
//                result.put("errYn", "Y");
//                result.put("errMsg","FirebaseException : "+e.getMessage());
//            }catch (Exception e){
//                result.put("errYn","Y");
//                result.put("errMsg","Kakap Login Fail");
//            }
//
//            log.info(userInfo.toString());
//            return result;
//        }
//
//
//        System.out.println(userInfo.toString());
//        return userInfo;
//    }

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
            sb.append("&client_id=22dc6a1f1f08667d709fdbb48d7d6ccf");
            sb.append("&redirect_uri=http://localhost:8080/kakao/login");
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

//    public String createFirebaseCustomToken(Map<String, Object> userInfo) throws Exception{
//        UserRecord userRecord;
//        String uid = userInfo.get("id").toString();
//        String email = userInfo.get("email").toString();
//        String displayName =  userInfo.get("nickname").toString();
//
////        1. 사용자 정보로 파이어 베이스 유저정보 update, 사용자 정보가 있다면 userRecord에 유저 정보가 담긴다.
//        try {
//            UpdateRequest request = new UpdateRequest(uid);
//            request.setEmail(email);
//            request.setDisplayName(displayName);
//            userRecord = FirebaseAuth.getInstance().updateUser(request);
////      1-2. 사용자 정보가 없다면 catch에서 createUser로 사용자를 생성한다.
//        }catch (FirebaseAuthException e){
//            CreateRequest createRequest = new CreateRequest();
//            createRequest.setUid(uid);
//            createRequest.setEmail(email);
//            createRequest.setEmailVerified(false);
//            createRequest.setDisplayName(displayName);
//
//            userRecord = FirebaseAuth.getInstance().createUser(createRequest);
//        }
//        return FirebaseAuth.getInstance().createCustomToken(userRecord.getUid());
//    }
}
