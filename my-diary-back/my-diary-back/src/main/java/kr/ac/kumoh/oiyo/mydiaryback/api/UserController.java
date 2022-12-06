package kr.ac.kumoh.oiyo.mydiaryback.api;

import kr.ac.kumoh.oiyo.mydiaryback.domain.Travel;
import kr.ac.kumoh.oiyo.mydiaryback.domain.dto.PostUserInfoDto;
import kr.ac.kumoh.oiyo.mydiaryback.domain.User;
import kr.ac.kumoh.oiyo.mydiaryback.domain.dto.TravelsOfUserDto;
import kr.ac.kumoh.oiyo.mydiaryback.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@RequestMapping(value = "/user", produces = {MediaType.APPLICATION_JSON_VALUE})
@RestController
public class UserController {
    private final UserService userService;

    @PostMapping("/{id}")
    public Map<String, Object> updateUser(@PathVariable("id") String id,@RequestBody PostUserInfoDto updateDto){
        Map<String, Object>response = new HashMap<>();
         if(userService.updateUser(Long.parseLong(id), updateDto) == 1)
         {
             response.put("result","SUCCESS");
         }else{
             response.put("result","FAIL");
             response.put("reason","사용자 정보 수정 실패");
         }
        return response;
    }

    @GetMapping("/{id}")
    public Map<String, Object> findById(@PathVariable("id")long userId){
        Map<String, Object> response = new HashMap<>();

        User user = userService.findUserbyId(userId);
        List<Travel> travels = userService.findTravelsbyUserId(userId);
        List<TravelsOfUserDto> collect = travels.stream()
                .map(t -> new TravelsOfUserDto(t))
                .collect(Collectors.toList());

        if(user != null) {
            response.put("result","SUCCESS");
            response.put("user",user);
            response.put("travels",collect);
        }else {
            response.put("result", "FAIL");
            response.put("reason","일치하는 회원 정보가 없습니다.");
        }
        return response;
    }

    @DeleteMapping("/{id}")
    public Map<String, Object> deleteUserById(@PathVariable("id")long userId){
        Map<String, Object> response = new HashMap<>();

        if (userService.deleteUserById(userId)==1){
            response.put("result","SUCCESS");
        }else{
            response.put("result","FAIL");
            response.put("reason","사용자 삭제 실패");
        }
        return response;
    }

}
