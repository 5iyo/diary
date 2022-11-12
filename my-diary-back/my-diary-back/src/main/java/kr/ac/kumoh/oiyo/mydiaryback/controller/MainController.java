package kr.ac.kumoh.oiyo.mydiaryback.controller;


import kr.ac.kumoh.oiyo.mydiaryback.domain.KakaoDTO;
import kr.ac.kumoh.oiyo.mydiaryback.domain.User;
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Map;

@Controller
public class MainController {
    @Autowired
    KakaoService kakaoService;

    @RequestMapping("test")
    @ResponseBody
    public String testConnect() {
        return "연결성공";
    }

    @RequestMapping("kakao/login")
    public KakaoDTO kakaoSignIn(@RequestParam("code") String code) {
//        String accessToken = kakaoService.getAccessKakaoToken(code);

        Map<String,Object> userInfo = kakaoService.getKakaoUserInfo(code);
//        System.out.println("###access_Token#### : " + accessToken);

        System.out.println("###nickname#### : " + userInfo.get("nickname"));
        System.out.println("###email#### : " + userInfo.get("email"));
        System.out.println("###id#### ; " + userInfo.get("id"));

//        토큰에서 받은 정보로 KakaoDTO build
        KakaoDTO kakaoDTO = KakaoDTO.builder()
                .k_email(userInfo.get("email").toString())
                .k_name(userInfo.get("nickname").toString())
                .build();




        return kakaoDTO;

    }



}
