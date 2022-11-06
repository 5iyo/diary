package kr.ac.kumoh.oiyo.mydiaryback.service.dto;

import lombok.Getter;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Getter
public class ReadDiaryDTO {

    // 일기 제목
    private String title;

    // 여행한 날짜
    private LocalDate travelDate;

    // 일기 본문 내용
    private String mainText;

    // 날씨
    private String weather;

    // 여행지
    private String travelDestination;

    // 사진들
    private List<String> diaryImages;

    // 일기 생성 날짜 + 시간
    private LocalDateTime createdDate;

    // 최종 수정 날짜 + 시간
    private LocalDateTime lastModifiedDate;

    public ReadDiaryDTO(String title, LocalDate travelDate, String mainText, String weather, String travelDestination
            , List<String> diaryImages, LocalDateTime createdDate, LocalDateTime lastModifiedDate) {
        this.title = title;
        this.travelDate = travelDate;
        this.mainText = mainText;
        this.weather = weather;
        this.travelDestination = travelDestination;
        this.diaryImages = diaryImages;
        this.createdDate = createdDate;
        this.lastModifiedDate = lastModifiedDate;
    }
}
