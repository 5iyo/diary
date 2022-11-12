package kr.ac.kumoh.oiyo.mydiaryback.controller;


import kr.ac.kumoh.oiyo.mydiaryback.repository.KakaoDTO;
import kr.ac.kumoh.oiyo.mydiaryback.repository.User;
import kr.ac.kumoh.oiyo.mydiaryback.service.KakaoService;
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
    @ResponseBody
    public User kakaoSignIn(@RequestParam("code") String code) {
//        String accessToken = kakaoService.getAccessKakaoToken(code);

        Map<String,Object> userInfo = kakaoService.getKakaoUserInfo(code);
//        System.out.println("###access_Token#### : " + accessToken);
        String name = userInfo.get("nickname").toString();
        String email = userInfo.get("email").toString();

        System.out.println("###nickname#### : " + name);
        System.out.println("###email#### : " + email);
        System.out.println("###id#### ; " + userInfo.get("id"));

//        토큰에서 받은 정보로 KakaoDTO build
        KakaoDTO kakaoDTO = KakaoDTO.builder()
                .k_name(name)
                .k_email(email)
                .build();

//        카카오로 회원가입 처리
        User kakaoUser = kakaoService.registerKakaoUserIfNeed(kakaoDTO);

//        강제 로그인 처리
//        Authentication authentication = kakaoService.forceLogin(kakaoUser);


        return kakaoUser;

    }



}
