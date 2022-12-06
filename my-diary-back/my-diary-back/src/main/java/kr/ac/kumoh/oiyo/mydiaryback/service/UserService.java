package kr.ac.kumoh.oiyo.mydiaryback.service;

import kr.ac.kumoh.oiyo.mydiaryback.domain.Travel;
import kr.ac.kumoh.oiyo.mydiaryback.domain.dto.PostUserInfoDto;
import kr.ac.kumoh.oiyo.mydiaryback.domain.User;
import kr.ac.kumoh.oiyo.mydiaryback.domain.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class UserService {

    @Autowired
    UserRepository userRepository;

    @Transactional
    public int deleteUserById(long id) {
        Optional<User> user = userRepository.findById(id);
        if(user.isPresent()) {
            userRepository.delete(user.get());
            return 1;
        }
        return 0;
    }

    @Transactional
    public List<Travel> findTravelsbyUserId(long id){
        User user = userRepository.findById(id).orElseThrow(()->{
            return new IllegalArgumentException("수정하기 위한 회원 찾기 실패!");
        });

        return user.getTravels();
    }

    @Transactional
    public User findUserbyId(long id){
        User user = userRepository.findById(id).orElseThrow(()->{
            return new IllegalArgumentException("수정하기 위한 회원 찾기 실패!");
        });

        return user;
    }

    @Transactional
    public int updateUser(long id,PostUserInfoDto updateUserInfo){
        User user = userRepository.findById(id).orElseThrow(()->{
            return new IllegalArgumentException("수정하기 위한 회원 찾기 실패!");
        });

        user.setProfileIntroduction(updateUserInfo.getProfileIntroduction());
        user.setBirthDatebyString(updateUserInfo.getBirthDate());
        user.setAddress(updateUserInfo.getAddress());

        userRepository.save(user);

        return 1;
    }
}
