package kr.ac.kumoh.oiyo.mydiaryback.api;

import com.fasterxml.jackson.annotation.JsonFormat;
import kr.ac.kumoh.oiyo.mydiaryback.domain.Diary;
import kr.ac.kumoh.oiyo.mydiaryback.domain.DiaryImage;
import kr.ac.kumoh.oiyo.mydiaryback.domain.Travel;
import kr.ac.kumoh.oiyo.mydiaryback.service.DiaryImageService;
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

    private final DiaryImageService diaryImageService;

    // 일기 생성 api
    @PostMapping("/api/diaries/{id}")
    public ResponseEntity saveDiary(@PathVariable("id") Long travelId, @RequestBody @Valid CreateDiaryRequest request) {

        Travel travel = travelService.findOne(travelId);

        LocalDateTime now = LocalDateTime.now();

        Diary diary = new Diary(now, now, request.getTitle(), request.getTravelDate(),
                request.getMainText(), request.getWeather(), request.getTravelDestination(), travel);

        // 이미지 생성
        List<String> images = request.getImages();

        for (String image : images) {
            new DiaryImage(diary, image);
        }

        diaryService.saveDiary(diary);

        CreateDiaryResponse createDiaryResponse = new CreateDiaryResponse(diary.getId());

        return new ResponseEntity(createDiaryResponse, HttpStatus.CREATED);
    }

    // 일기 삭제 api
    @DeleteMapping("/api/diaries/{id}")
    public ResponseEntity deleteDiary(@PathVariable("id") Long diaryId) {
        diaryService.deleteDiary(diaryId);

        return new ResponseEntity(HttpStatus.OK);
    }

    // 일기 목록 조회 api
    @GetMapping("/api/diaries/{id}/inquiry-diary-list")
    public ResponseEntity inquiryDiaryList(@PathVariable("id") Long travelId) {

        Travel findTravel = travelService.findOne(travelId);

        List<Diary> diaries = diaryService.readDiaryList(travelId);

        List<DiariesDto> collect = diaries.stream()
                .map(d -> new DiariesDto(d.getId(), d.getTitle(), d.getTravelDate()
                        , d.getTravelDestination(), d.getWeather()))
                .collect(Collectors.toList());

        String travelTitle = findTravel.getTravelTitle();
        String travelArea = findTravel.getTravelArea();
        LocalDate travelStartDate = findTravel.getTravelStartDate();
        LocalDate travelEndDate = findTravel.getTravelEndDate();

        Result result = new Result(travelTitle, travelArea, travelStartDate, travelEndDate, collect);

        return new ResponseEntity(result, HttpStatus.OK);
    }

    // 특정 일기 조회 api
    @GetMapping("/api/diaries/{id}")
    public ResponseEntity inquiryDiary(@PathVariable("id") Long diaryId) {
        Diary diary = diaryService.findOne(diaryId);

        // 이미지 조회
        List<DiaryImage> images = diaryImageService.inquiryImagesByDiary(diaryId);

        List<DiaryImageDto> collect = images.stream()
                .map(di -> new DiaryImageDto(di.getId(), di.getImageFile()))
                .collect(Collectors.toList());

        DiaryDto diaryDto = new DiaryDto(diary, collect);

        return new ResponseEntity(diaryDto, HttpStatus.OK);
    }

    @PatchMapping("/api/diaries/{id}")
    public ResponseEntity modifyDiary(@PathVariable("id") Long diaryId, @RequestBody @Valid UpdateDiaryRequest request){

        String title = request.getTitle();
        LocalDate travelDate = request.getTravelDate();
        String mainText = request.getMainText();
        String weather = request.getWeather();
        String travelDestination = request.getTravelDestination();
        LocalDateTime lastModifiedDate = LocalDateTime.now();

        diaryService.update(diaryId, title, travelDate, mainText, weather, travelDestination, lastModifiedDate);

        Diary findDiary = diaryService.findOne(diaryId);

        List<DiaryImage> images = diaryImageService.inquiryImagesByDiary(diaryId);

        List<DiaryImageDto> collect = images.stream()
                .map(di -> new DiaryImageDto(di.getId(), di.getImageFile()))
                .collect(Collectors.toList());

        DiaryDto diaryDto = new DiaryDto(findDiary, collect);

        return new ResponseEntity(diaryDto, HttpStatus.OK);
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
