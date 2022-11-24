package kr.ac.kumoh.oiyo.mydiaryback.repository;

import lombok.Data;

import java.time.LocalDate;

@Data
public class PostUserInfoDto {
    private String email;
    private String profileIntroduction;
    private LocalDate birthDate;
    private String address;
}
