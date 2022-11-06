package kr.ac.kumoh.oiyo.mydiaryback.repository.dto;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
public class FindDiaryDtoByTravel {

    // 일기Id (PK)
    private Long diaryId;

    // 일기 제목
    private String title;

    // 여행 일자
    private LocalDate travelDate;

    // 날씨
    private String weather;

    public FindDiaryDtoByTravel(Long diaryId, String title, LocalDate travelDate, String weather) {
        this.diaryId = diaryId;
        this.title = title;
        this.travelDate = travelDate;
        this.weather = weather;
    }
}
