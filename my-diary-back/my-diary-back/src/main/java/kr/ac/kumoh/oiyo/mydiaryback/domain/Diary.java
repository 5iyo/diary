package kr.ac.kumoh.oiyo.mydiaryback.domain;

import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@NoArgsConstructor
public class Diary extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "DIARY_ID")
    private Long id;

    // 일기 제목
    private String title;

    // 여행 일자
    private LocalDate travelDate;

    // 일기 본문 내용
    private String mainText;

    // 날씨
    private String weather;

    // 세부 여행지
    private String travelDestination;
    
    // 여행
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TRAVEL_ID")
    private Travel travel;

    // 사진들
    @OneToMany(mappedBy = "diary", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<DiaryImage> diaryImages = new ArrayList<>();

    // 동행자 보류 (공유할 때 필요!!)

    public Diary(String title, LocalDate travelDate
            , String mainText, String weather, String travelDestination, Travel travel) {
        this.title = title;
        this.travelDate = travelDate;
        this.mainText = mainText;
        this.weather = weather;
        this.travelDestination = travelDestination;
        setTravel(travel);
    }

    /* 연관관계 편의 메서드 */
    private void setTravel(Travel travel) {
        if (this.travel != null) {
            this.travel.getDiaries().remove(this);
        }
        this.travel = travel;
        travel.getDiaries().add(this);
    }

    //== 수정 메서드 ==//
    public void updateDiary(String title, LocalDate travelDate, String mainText, String weather
            , String travelDestination) {
        this.title = title;
        this.travelDate = travelDate;
        this.mainText = mainText;
        this.weather = weather;
        this.travelDestination = travelDestination;
    }
}
