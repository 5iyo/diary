package kr.ac.kumoh.oiyo.mydiaryback.repository;


import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

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

    @Builder
    public User(String username, String email, UserRole role, String profileImage){
        this.username = username;
        this.email = email;
        this.profileImage = profileImage;
        this.role = role;
    }


}
