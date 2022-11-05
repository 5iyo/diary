package kr.ac.kumoh.oiyo.mydiaryback.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.List;

@Entity
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class Trip extends BaseEntity {

    @Id
    @GeneratedValue
    @Column(name = "TRIP_ID")
    private Long id;

    private String posX;

    private String posY;

    // 여행 이미지
    private String tripImage;

    // Diary
    @OneToMany(mappedBy = "trip")
    private List<Diary> diaries;
}
