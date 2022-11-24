package kr.ac.kumoh.oiyo.mydiaryback.repository;


import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@Entity
@NoArgsConstructor
@Getter
public class User extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Column
    private String email;

    @Column
    private String username;

    @Column
    private String profileImage;

    @Enumerated(EnumType.STRING)
    private UserRole role;

    @Column
    private String profileIntroduction;

    @Column
    private LocalDate birthDate;

    @Column
    private String address;

    @Builder
    public User(String username, String email, UserRole role, String profileImage){
        this.username = username;
        this.email = email;
        this.profileImage = profileImage;
        this.role = role;
    }

    public void setProfileIntroduction(String profileIntroduction){
        this.profileIntroduction = profileIntroduction;
    }
    public void setBirthDate(LocalDate birthDate)
    {
        this.birthDate = birthDate;
    }

    public void setBirthDatebyString(String birthDate){
        LocalDate date = LocalDate.parse(birthDate, DateTimeFormatter.ISO_DATE);
        this.birthDate = date;
    }

    public void setAddress(String address){
        this.address = address;
    }


}
