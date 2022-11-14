package kr.ac.kumoh.oiyo.mydiaryback.domain;

import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@NoArgsConstructor
public class Travel extends BaseEntity {

    @Id
    @GeneratedValue
    @Column(name = "TRIP_ID")
    private Long id;

    // Member
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MEMBER_ID")
    private Member member;

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

    public Travel(LocalDateTime createDate, LocalDateTime lastModifiedDate, Member member, String travelTitle
            , String travelArea, String travelLatitude, String travelLongitude, String travelImage
            , LocalDate travelStartDate, LocalDate travelEndDate) {
        super(createDate, lastModifiedDate);
        setMember(member);
        this.travelTitle = travelTitle;
        this.travelArea = travelArea;
        this.travelLatitude = travelLatitude;
        this.travelLongitude = travelLongitude;
        this.travelImage = travelImage;
        this.travelStartDate = travelStartDate;
        this.travelEndDate = travelEndDate;
    }

    /* 연관관계 편의 메서드 */
    private void setMember(Member member) {
        if(this.member != null)
            this.member.getTravels().remove(this);
        this.member = member;
        member.getTravels().add(this);
    }
}
