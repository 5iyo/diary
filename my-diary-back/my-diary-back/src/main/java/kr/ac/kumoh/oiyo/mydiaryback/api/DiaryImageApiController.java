package kr.ac.kumoh.oiyo.mydiaryback.api;

import kr.ac.kumoh.oiyo.mydiaryback.domain.Diary;
import kr.ac.kumoh.oiyo.mydiaryback.domain.DiaryImage;
import kr.ac.kumoh.oiyo.mydiaryback.service.DiaryImageService;
import kr.ac.kumoh.oiyo.mydiaryback.service.DiaryService;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

@RestController
@RequiredArgsConstructor
public class DiaryImageApiController {

    private final DiaryService diaryService;

    private final DiaryImageService diaryImageService;

    @PostMapping("/api/diary-images/{id}")
    public ResponseEntity saveDiaryImage(@PathVariable("id") Long diaryId, @RequestBody @Valid CreateDiaryImageRequest createDiaryImageRequest) {

        Diary findDiary = diaryService.findOne(diaryId);

        DiaryImage diaryImage = new DiaryImage(findDiary, createDiaryImageRequest.getImageFile());

        Long diaryImageId = diaryImageService.saveDiaryImage(diaryImage);

        CreateDiaryImageResponse createDiaryImageResponse = new CreateDiaryImageResponse(diaryImageId);

        return new ResponseEntity(createDiaryImageResponse, HttpStatus.CREATED);
    }

    @DeleteMapping("/api/diary-images/{id}")
    public ResponseEntity deleteDiaryImage(@PathVariable("id") Long diaryImageId) {
        diaryImageService.deleteDiaryImage(diaryImageId);

        return new ResponseEntity(HttpStatus.OK);
    }

    @Data
    @AllArgsConstructor
    static class CreateDiaryImageResponse {
        private Long id;
    }

    @Data
    static class CreateDiaryImageRequest {
        private String imageFile;
    }
}
