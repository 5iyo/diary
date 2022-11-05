package kr.ac.kumoh.oiyo.mydiaryback.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Diary extends BaseEntity {

    @Id
    @GeneratedValue
    @Column(name = "DIARY_ID")
    private Long id;

    // 일기 제목
    private String title;

    // 여행 일자
    private LocalDate tripDate;

    // 일기 본문 내용
    private String mainText;

    // 날씨
    private String weather;

    // 사진들?
//    private List<String> diaryImages = new ArrayList<>();

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TRIP_ID")
    private Trip trip;

    // 동행자 보류 (공유할 때 필요!!)

    /* 연관관계 편의 메서드 */
    public void setTrip(Trip trip) {
        if (this.trip != null) {
            this.trip.getDiaries().remove(this);
        }
        this.trip = trip;
        trip.getDiaries().add(this);
    }
}
