package kr.ac.kumoh.oiyo.mydiaryback.domain.dto;

import lombok.Data;

@Data
public class PostUserInfoDto {
    private String email;
    private String profileIntroduction;
    private String birthDate;
    private String address;
}
