package kr.ac.kumoh.oiyo.mydiaryback.api;

import com.fasterxml.jackson.annotation.JsonFormat;
import kr.ac.kumoh.oiyo.mydiaryback.domain.Diary;
import kr.ac.kumoh.oiyo.mydiaryback.domain.DiaryImage;
import kr.ac.kumoh.oiyo.mydiaryback.domain.Travel;
import kr.ac.kumoh.oiyo.mydiaryback.service.DiaryService;
import kr.ac.kumoh.oiyo.mydiaryback.service.TravelService;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequiredArgsConstructor
public class DiaryApiController {

    private final DiaryService diaryService;

    private final TravelService travelService;

    // 일기 생성 api

    /**
     * 일기 생성
     * @param travelId 여행 ID (PK)
     * @param request REQUEST BODY
     * @return 일기 ID (PK) 반환
     */
    @PostMapping("/api/diaries/{id}")
    public ResponseEntity saveDiary(@PathVariable("id") Long travelId, @RequestBody @Valid CreateDiaryRequest request) {

        Travel travel = travelService.findOne(travelId);

        LocalDateTime now = LocalDateTime.now();

        Diary diary = new Diary(request.getTitle(), request.getTravelDate(),
                request.getMainText(), request.getWeather(), request.getTravelDestination(), travel);

        // 이미지 생성
        List<String> images = request.getImages();

        for (String image : images) {
            DiaryImage.createDiaryImage(diary, image);
        }

        diaryService.save(diary);

        CreateDiaryResponse createDiaryResponse = new CreateDiaryResponse(diary.getId());

        return new ResponseEntity(createDiaryResponse, HttpStatus.CREATED);
    }

    /**
     * 일기 삭제
     * @param diaryId 일기 ID (PK)
     * @return
     */
    @DeleteMapping("/api/diaries/{id}")
    public ResponseEntity deleteDiary(@PathVariable("id") Long diaryId) {
        diaryService.deleteDiary(diaryId);

        return new ResponseEntity(HttpStatus.OK);
    }

    /**
     * 일기 목록 조회
     * @param travelId 여행 ID (PK)
     * @return 일기 정보
     */
    @GetMapping("/api/diaries/{id}/inquiry-diary-list")
    public ResponseEntity inquireDiaryList(@PathVariable("id") Long travelId) {

        Travel findTravel = travelService.findTravel(travelId);

        List<Diary> diaries = findTravel.getDiaries();

        List<DiariesDto> collect = diaries.stream()
                .map(DiariesDto::new)
                .collect(Collectors.toList());

        String travelTitle = findTravel.getTravelTitle();
        String travelArea = findTravel.getTravelArea();
        LocalDate travelStartDate = findTravel.getTravelStartDate();
        LocalDate travelEndDate = findTravel.getTravelEndDate();

        Result result = new Result(travelTitle, travelArea, travelStartDate, travelEndDate, collect);

        return new ResponseEntity(result, HttpStatus.OK);
    }

    // 특정 일기 조회 api

    /**
     * 특정 일기 조회
     * @param diaryId 일기 ID (PK)
     * @return 일기 정보
     */
    @GetMapping("/api/diaries/{id}")
    public ResponseEntity inquireDiary(@PathVariable("id") Long diaryId) {
        Diary diary = diaryService.findDiary(diaryId);

        List<DiaryImage> images = diary.getDiaryImages();

        List<DiaryImageDto> collect = images.stream()
                .map(di -> new DiaryImageDto(di.getId(), di.getImageFile()))
                .collect(Collectors.toList());

        DiaryDto diaryDto = new DiaryDto(diary, collect);

        return new ResponseEntity(diaryDto, HttpStatus.OK);
    }

    /**
     * 일기 수정
     * @param diaryId 일기 ID (PK)
     * @param request REQUEST BODY
     * @return
     */
    @PatchMapping("/api/diaries/{id}")
    public ResponseEntity modifyDiary(@PathVariable("id") Long diaryId, @RequestBody @Valid UpdateDiaryRequest request){

        String title = request.getTitle();
        LocalDate travelDate = request.getTravelDate();
        String mainText = request.getMainText();
        String weather = request.getWeather();
        String travelDestination = request.getTravelDestination();

        diaryService.update(diaryId, title, travelDate, mainText, weather, travelDestination);

        return new ResponseEntity(HttpStatus.OK);
    }

    @Data
    @AllArgsConstructor
    static class DiaryImageDto {
        private Long diaryImageId;
        private String imageFile;
    }

    @Data
    static class UpdateDiaryRequest {
        private String title;
        @DateTimeFormat(pattern = "yyyy-MM-dd")
        private LocalDate travelDate;
        private String mainText;
        private String weather;
        private String travelDestination;
    }

    @Data
    @AllArgsConstructor
    static class Result<T> {
        private String travelTitle;
        private String travelArea;
        private LocalDate travelStartDate;
        private LocalDate travelEndDate;
        private T diaries;
    }

    @Data
    static class DiaryDto {
        private Long dairyId;
        private String title;
        @JsonFormat(pattern = "yyyy-MM-dd")
        private LocalDate travelDate;
        private String mainText;
        private String weather;
        private String travelDestination;
        private List<DiaryImageDto> images;
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        private LocalDateTime createDate;
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        private LocalDateTime lastModifiedDate;

        public DiaryDto(Diary diary, List<DiaryImageDto> images) {
            this.dairyId = diary.getId();
            this.title = diary.getTitle();
            this.travelDate = diary.getTravelDate();
            this.mainText = diary.getMainText();
            this.weather = diary.getWeather();
            this.travelDestination = diary.getTravelDestination();
            this.images = images;
            this.createDate = diary.getCreateDate();
            this.lastModifiedDate = diary.getLastModifiedDate();
        }
    }

    @Data
    @AllArgsConstructor
    static class DiariesDto {
        private Long diaryId;
        private String title;
        @DateTimeFormat(pattern = "yyyy-MM-dd")
        private LocalDate travelDate;
        private String travelDestination;
        private String weather;

        public DiariesDto(Diary diary) {
            diaryId = diary.getId();
            title = diary.getTitle();
            travelDate = diary.getTravelDate();
            travelDestination = diary.getTravelDestination();
            weather = diary.getWeather();
        }
    }

    @Data
    @AllArgsConstructor
    static class CreateDiaryResponse {
        private Long id;
    }

    @Data
    static class CreateDiaryRequest {
        private String title;
        @DateTimeFormat(pattern = "yyyy-MM-dd")
        private LocalDate travelDate;
        private String mainText;
        private String weather;
        private String travelDestination;
        private List<String> images;
    }
}
