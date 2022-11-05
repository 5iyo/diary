package kr.ac.kumoh.oiyo.mydiaryback.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.time.LocalDate;
import java.util.List;

@Entity
@Getter
@NoArgsConstructor
@AllArgsConstructor
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
    @OneToMany(mappedBy = "travel")
    private List<Diary> diaries;

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

    /* 연관관계 편의 메서드 */
    public void setMember(Member member) {
        if (this.member != null) {
            this.member.getTravels().remove(this);
        }
        this.member = member;
        member.getTravels().add(this);
    }
}