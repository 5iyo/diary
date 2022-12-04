package kr.ac.kumoh.oiyo.mydiaryback.api;

import kr.ac.kumoh.oiyo.mydiaryback.domain.dto.PostUserInfoDto;
import kr.ac.kumoh.oiyo.mydiaryback.domain.User;
import kr.ac.kumoh.oiyo.mydiaryback.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RequiredArgsConstructor
@RequestMapping(value = "/user", produces = {MediaType.APPLICATION_JSON_VALUE})
@RestController
public class UserController {
    private final UserService userService;

    @DeleteMapping("/{id}")
    public Map<String, Object> delete(@PathVariable("id") long id) {
        Map<String, Object> response = new HashMap<>();
        if(userService.delete(id) > 0) {
            response.put("result","SUCCESS");
        } else {
            response.put("result","FAIL");
            response.put("reason","일치하는 회원정보가 없습니다.");
        }
        return response;
    }

    @PostMapping("")
    public Map<String, Object> updateUser(@RequestBody PostUserInfoDto updateDto){
        Map<String, Object>response = new HashMap<>();
         if(userService.updateUser(updateDto) == 1)
         {
             response.put("result","SUCCESS");
         }else{
             response.put("result","FAIL");
             response.put("reason","사용자 정보 수정 실패");
         }
        return response;
    }

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
