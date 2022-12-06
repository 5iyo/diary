package kr.ac.kumoh.oiyo.mydiaryback.api;


import kr.ac.kumoh.oiyo.mydiaryback.domain.Travel;
import kr.ac.kumoh.oiyo.mydiaryback.domain.dto.GoogleDto;
import kr.ac.kumoh.oiyo.mydiaryback.domain.dto.KakaoDto;
import kr.ac.kumoh.oiyo.mydiaryback.domain.dto.NaverDto;
import kr.ac.kumoh.oiyo.mydiaryback.domain.User;
import kr.ac.kumoh.oiyo.mydiaryback.service.UserService;
import kr.ac.kumoh.oiyo.mydiaryback.service.social.GoogleService;
import kr.ac.kumoh.oiyo.mydiaryback.service.social.KakaoService;
import kr.ac.kumoh.oiyo.mydiaryback.service.social.NaverService;
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
public class SocialController {

    @Autowired
    KakaoService kakaoService;
    @Autowired
    NaverService naverService;

    @Autowired
    GoogleService googleService;

    @Autowired
    UserService userService;


    @RequestMapping("test")
    @ResponseBody
    public String testConnect() {
        return "연결성공";
    }

    @RequestMapping(value = "kakao/login", produces = "application/json;charset=utf8")
    @ResponseBody
    public Map<String, Object> kakaoSignIn(@RequestParam("accessToken") String accessToken) {
        Map<String, Object> response = new HashMap<>();

        Map<String,Object> userInfo = kakaoService.getKakaoUserInfo(accessToken);
//        System.out.println("###access_Token#### : " + code);
        String name = userInfo.get("nickname").toString();
        String email = userInfo.get("email").toString();
        String image = userInfo.get("profile_image").toString();

        System.out.println("###nickname#### : " + name);
        System.out.println("###email#### : " + email);
        System.out.println("###id#### ; " + userInfo.get("id"));

//        토큰에서 받은 정보로 KakaoDTO build
        KakaoDto kakaoDTO = KakaoDto.builder()
                .k_name(name)
                .k_email(email)
                .k_image(image)
                .build();

//        카카오로 회원가입 처리
        User kakaoUser = kakaoService.registerKakaoUserIfNeed(kakaoDTO);

//        여행 정보 불러오기
        List<Travel> travels = userService.findTravelsbyUserId(kakaoUser.getId());
        List<TravelApiController.TravelDto> collect = travels.stream()
                .map(t -> new TravelApiController.TravelDto(t))
                .collect(Collectors.toList());

        response.put("travels",collect);
        response.put("user",kakaoUser);

        return response;
    }

    @RequestMapping(value = "naver/login", produces = "application/json;charset=utf8")
    @ResponseBody
    public Map<String, Object> naverSignIn(@RequestParam("accessToken") String accessToken) {
        Map<String, Object> response = new HashMap<>();

        Map<String,Object> userInfo = naverService.getNaverUserInfo(accessToken);
//        System.out.println("###access_Token#### : " + code);
        String name = userInfo.get("name").toString();
        String email = userInfo.get("email").toString();
        String image = userInfo.get("profile_image").toString();

        System.out.println("###nickname#### : " + name);
        System.out.println("###email#### : " + email);
        System.out.println("###id#### ; " + userInfo.get("id"));

//        토큰에서 받은 정보로 NaverDTO build
        NaverDto naverDTO = NaverDto.builder()
                .n_name(name)
                .n_email(email)
                .n_image(image)
                .build();

//        네이버로 회원가입 처리
        User naverUser = naverService.registerNaverUserIfNeed(naverDTO);

//        여행 정보 불러오기
        List<Travel> travels = userService.findTravelsbyUserId(naverUser.getId());
        List<TravelApiController.TravelDto> collect = travels.stream()
                .map(t -> new TravelApiController.TravelDto(t))
                .collect(Collectors.toList());

        response.put("travels",collect);
        response.put("user",naverUser);

        return response;
    }

    @RequestMapping(value = "google/login", produces = "application/json;charset=utf8")
    @ResponseBody
    public Map<String, Object> googleSignIn(@RequestParam("accessToken") String accessToken) {
        Map<String, Object> response = new HashMap<>();

        Map<String,Object> userInfo = googleService.getGoogleUserInfo(accessToken);
//        System.out.println("###access_Token#### : " + code);
        String name = userInfo.get("name").toString();
        String email = userInfo.get("email").toString();
        String image = userInfo.get("profile_image").toString();

        System.out.println("###nickname#### : " + name);
        System.out.println("###email#### : " + email);
        System.out.println("###id#### ; " + userInfo.get("id"));

//        토큰에서 받은 정보로 GoogleDTO build
        GoogleDto googleDTO = GoogleDto.builder()
                .g_name(name)
                .g_email(email)
                .g_image(image)
                .build();

//        구글로 회원가입 처리
        User googleUser = googleService.registerGoogleUserIfNeed(googleDTO);
        
//        여행 정보 불러오기
        List<Travel> travels = userService.findTravelsbyUserId(googleUser.getId());
        List<TravelApiController.TravelDto> collect = travels.stream()
                .map(t -> new TravelApiController.TravelDto(t))
                .collect(Collectors.toList());

        response.put("travels",collect);
        response.put("user",googleUser);

        return response;
    }
}
