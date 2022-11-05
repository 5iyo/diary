package kr.ac.kumoh.oiyo.mydiaryback.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;

import javax.persistence.*;
import java.time.LocalDate;

@Entity
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class Member extends BaseEntity{

    @Id
    @Column(name = "MEMBER_ID")
    private String id;

    // 사용자 이름
    private String name;

    // 사용자 프로필 이미지
    private String profileImg;

    // 사용자 프로필 소개글
    private String profileIntroduction;

    // 사용자 생년월일
    private LocalDate birthDate;

    // 사용자 주소
    @Embedded
    private Address address;
}
