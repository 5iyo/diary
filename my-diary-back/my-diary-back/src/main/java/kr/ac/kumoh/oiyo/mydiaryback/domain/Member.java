package kr.ac.kumoh.oiyo.mydiaryback.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;


@Entity
@Getter
@NoArgsConstructor
public class Member extends BaseEntity {

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

    // 사용자 이메일
    private String email;

    // 사용자 주소
    @Embedded
    private Address address;

    public Member(LocalDateTime createDate, LocalDateTime lastModifiedDate, String id, String name, String profileImg, String profileIntroduction, LocalDate birthDate, String email, Address address) {
        super(createDate, lastModifiedDate);
        this.id = id;
        this.name = name;
        this.profileImg = profileImg;
        this.profileIntroduction = profileIntroduction;
        this.birthDate = birthDate;
        this.email = email;
        this.address = address;
    }
}
