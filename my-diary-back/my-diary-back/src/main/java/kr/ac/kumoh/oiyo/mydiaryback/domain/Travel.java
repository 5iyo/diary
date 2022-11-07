package kr.ac.kumoh.oiyo.mydiaryback.domain;

import lombok.AllArgsConstructor;
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

    // 여행지
    private String travelDestination;

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

    public Travel(LocalDateTime createDate, LocalDateTime lastModifiedDate, Member member, String travelDestination, String travelLatitude, String travelLongitude, String travelImage, LocalDate travelStartDate, LocalDate travelEndDate) {
        super(createDate, lastModifiedDate);
        this.member = member;
        this.travelDestination = travelDestination;
        this.travelLatitude = travelLatitude;
        this.travelLongitude = travelLongitude;
        this.travelImage = travelImage;
        this.travelStartDate = travelStartDate;
        this.travelEndDate = travelEndDate;
    }
}
