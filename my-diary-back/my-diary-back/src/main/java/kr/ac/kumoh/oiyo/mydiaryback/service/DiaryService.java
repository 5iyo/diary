package kr.ac.kumoh.oiyo.mydiaryback.service;

import kr.ac.kumoh.oiyo.mydiaryback.domain.Diary;
import kr.ac.kumoh.oiyo.mydiaryback.repository.DiaryImageRepository;
import kr.ac.kumoh.oiyo.mydiaryback.repository.DiaryRepository;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
public class DiaryService {

    private final DiaryRepository diaryRepository;

    private final DiaryImageRepository diaryImageRepository;

    // 저장
    @Transactional
    public Long saveDiary(Diary diary) {
        diaryRepository.save(diary);
        return diary.getId();
    }

    /**
     * 일기 목록에서 특정 일기를 클릭하면 호출된다.
     * 일기 제목, 여행 날짜, 일기 본문, 날씨, 여행지, 사진들, 일기 생성 시간, 일기 수정 시간
     *
     * @param diaryId
     * @return
     */
    // 조회
    public Diary readDiary(Long diaryId) {

        return diaryRepository.findDiary(diaryId);
    }

    /**
     * 여행별 일기 조회 메서드 (날짜 오름차순)
     * 지도에서 마커를 클릭하면 해당 메서드가 호출된다.
     * 일기 리스트에는 제목, 여행 날짜, 날씨만 표시
     * 일기 id도 함께 보내준다.
     *
     * @param travelId
     * @return
     */
    // 일기 목록 조회
    public List<Diary> readDiaryList(Long travelId) {
        return diaryRepository.findDiariesByTravel(travelId);
    }

    @Transactional
    public void deleteDiary(Long diaryId) {
        diaryRepository.delete(diaryId);
    }

    /**
     * 일기 내용 수정
     *
     *
     * @param diaryId
     */
   /* @Transactional
    public void update(Long diaryId, String title, LocalDate travelDate, String mainText, String weather, String travelDestination, ) {
        Diary diary = diaryRepository.findDiary(diaryId);

    }*/
}
