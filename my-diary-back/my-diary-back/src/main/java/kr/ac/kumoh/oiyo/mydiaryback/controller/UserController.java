package kr.ac.kumoh.oiyo.mydiaryback.controller;

import kr.ac.kumoh.oiyo.mydiaryback.repository.User;
import kr.ac.kumoh.oiyo.mydiaryback.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RequiredArgsConstructor
@RequestMapping(value = "/users", produces = {MediaType.APPLICATION_JSON_VALUE})
@RestController
public class UserController {
    private final UserRepository userRepository;

    @GetMapping("/{id}")
    public Map<String, Object> findById(@PathVariable("id")User user){
        Map<String, Object> response = new HashMap<>();

        if(user != null) {
            response.put("result","SUCCESS");
            response.put("user",user);
        }else {
            response.put("result", "FAIL");
            response.put("reason","일치하는 회원 정보가 없습니다.");
        }
        return response;
    }

}
