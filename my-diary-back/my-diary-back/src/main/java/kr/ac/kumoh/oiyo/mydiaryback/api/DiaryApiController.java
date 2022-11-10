package kr.ac.kumoh.oiyo.mydiaryback.api;

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

@RestController
@RequiredArgsConstructor
public class DiaryApiController {

    private final DiaryService diaryService;

    private final TravelService travelService;

    // 일기 생성 api
    @PostMapping("/api/diaries/{id}")
    public ResponseEntity saveDiary(@PathVariable("id") Long travelId, @RequestBody @Valid CreateDiaryRequest request) {

        Travel travel = travelService.findOne(travelId);

        LocalDateTime now = LocalDateTime.now();

        Diary diary = new Diary(now, now, request.getTitle(), request.getTravelDate(),
                request.getMainText(), request.getWeather(), travel);

        // 이미지 생성
        List<String> images = request.getImages();

        for (String image : images) {
            new DiaryImage(diary, image);
        }

        diaryService.saveDiary(diary);

        CreateDiaryResponse createDiaryResponse = new CreateDiaryResponse(diary.getId());

        return new ResponseEntity(createDiaryResponse, HttpStatus.CREATED);
    }

    @DeleteMapping("/api/diaries/{id}")
    public ResponseEntity deleteDiary(@PathVariable("id") Long diaryId) {
        diaryService.deleteDiary(diaryId);

        return new ResponseEntity(HttpStatus.OK);
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
