package kr.ac.kumoh.oiyo.mydiaryback.service;

import kr.ac.kumoh.oiyo.mydiaryback.domain.DiaryImage;
import kr.ac.kumoh.oiyo.mydiaryback.repository.DiaryImageRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class DiaryImageService {

    private final DiaryImageRepository diaryImageRepository;

    @Transactional
    public Long saveDiaryImage(DiaryImage diaryImage) {
        return diaryImageRepository.save(diaryImage);
    }

    // 조회 메서드
    public List<DiaryImage> inquiryImagesByDiary(Long diaryId) {
        return diaryImageRepository.findImagesByDiary(diaryId);
    }

    // 삭제 메서드
    @Transactional
    public void deleteDiaryImage(Long diaryImageId) {
        diaryImageRepository.delete(diaryImageId);
    }
}
