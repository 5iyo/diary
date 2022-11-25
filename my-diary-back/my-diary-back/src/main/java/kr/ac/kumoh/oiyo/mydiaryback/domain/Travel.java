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
public class Travel extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "TRAVEL_ID")
    private Long id;

    // Member
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MEMBER_ID")
    private User user;

    // Diary
    @OneToMany(mappedBy = "travel", cascade = CascadeType.REMOVE, orphanRemoval = true)
    private List<Diary> diaries = new ArrayList<>();
    
    // 여행에 대한 제목
    private String travelTitle;

    // 여행지
    private String travelArea;

    // 해당 여행지의 위도
    private String travelLatitude;

    // 해당 여행지의 경도
    private String travelLongitude;

    // 여행 대표 이미지
    // 일기 리스트 조회 화면에서 대표 이미지로 사용됨
    private String travelImage;

    // 여행 시작 날짜
    private LocalDate travelStartDate;

    // 여행 종료 날짜
    private LocalDate travelEndDate;

    public Travel(User user, String travelTitle
            , String travelArea, String travelLatitude, String travelLongitude, String travelImage
            , LocalDate travelStartDate, LocalDate travelEndDate) {
        setMember(user);
        this.travelTitle = travelTitle;
        this.travelArea = travelArea;
        this.travelLatitude = travelLatitude;
        this.travelLongitude = travelLongitude;
        this.travelImage = travelImage;
        this.travelStartDate = travelStartDate;
        this.travelEndDate = travelEndDate;
    }

    /* 연관관계 편의 메서드 */
    private void setMember(User user) {
        if(this.user != null)
            this.user.getTravels().remove(this);
        this.user = user;
        user.getTravels().add(this);
    }

    //== 수정 메서드 ==//
    public void updateTravel(String travelTitle, String travelImage, LocalDate travelStartDate, LocalDate travelEndDate) {
        this.travelTitle = travelTitle;
        this.travelImage = travelImage;
        this.travelStartDate = travelStartDate;
        this.travelEndDate = travelEndDate;
    }
}
