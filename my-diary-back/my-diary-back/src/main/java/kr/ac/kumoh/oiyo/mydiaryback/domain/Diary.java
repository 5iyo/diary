package kr.ac.kumoh.oiyo.mydiaryback.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@NoArgsConstructor
public class Diary extends BaseEntity {

    @Id
    @GeneratedValue
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
    
    // 여행
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TRIP_ID")
    private Travel travel;

    // 사진들
    @OneToMany(mappedBy = "diary", cascade = CascadeType.REMOVE, orphanRemoval = true)
    private List<DiaryImage> diaryImages = new ArrayList<>();

    // 동행자 보류 (공유할 때 필요!!)


    public Diary(LocalDateTime createDate, LocalDateTime lastModifiedDate, String title, LocalDate travelDate, String mainText, String weather, Travel travel) {
        super(createDate, lastModifiedDate);
        this.title = title;
        this.travelDate = travelDate;
        this.mainText = mainText;
        this.weather = weather;
        setTravel(travel);
    }

    /* 연관관계 편의 메서드 */
    public void setTravel(Travel travel) {
        if (this.travel != null) {
            this.travel.getDiaries().remove(this);
        }
        this.travel = travel;
        travel.getDiaries().add(this);
    }
}
