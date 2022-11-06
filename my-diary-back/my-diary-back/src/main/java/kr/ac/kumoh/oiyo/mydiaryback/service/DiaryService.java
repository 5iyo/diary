package kr.ac.kumoh.oiyo.mydiaryback.service;

import kr.ac.kumoh.oiyo.mydiaryback.domain.Diary;
import kr.ac.kumoh.oiyo.mydiaryback.repository.DiaryImageRepository;
import kr.ac.kumoh.oiyo.mydiaryback.repository.DiaryRepository;
import kr.ac.kumoh.oiyo.mydiaryback.repository.dto.FindDiaryDtoByTravel;
import kr.ac.kumoh.oiyo.mydiaryback.repository.dto.FindOneDiaryDto;
import kr.ac.kumoh.oiyo.mydiaryback.service.dto.ReadDiaryDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class DiaryService {

    private final DiaryRepository diaryRepository;

    private final DiaryImageRepository diaryImageRepository;

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
    public ReadDiaryDTO readDiary(Long diaryId) {

        FindOneDiaryDto findOneDiaryDto = diaryRepository.findOne(diaryId);

        List<String> diaryImages = diaryImageRepository.findImagesByDiary(diaryId);

        return new ReadDiaryDTO(findOneDiaryDto.getTitle(), findOneDiaryDto.getTravelDate(), findOneDiaryDto.getMainText()
                , findOneDiaryDto.getWeather(), findOneDiaryDto.getTravelDestination(), diaryImages
                , findOneDiaryDto.getCreatedDate(), findOneDiaryDto.getLastModifiedDate());
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
    public List<FindDiaryDtoByTravel> readDiaryList(Long travelId) {
        return diaryRepository.findDiariesByTravel(travelId);
    }

    /**
     * 일기 내용 수정
     *
     *
     * @param diaryId
     */
    // 현재 일기 내용 수정에 관한 DTO 필요 <- 무슨 필드 변경할지 필요함.
    @Transactional
    public void editDiary(Long diaryId) {

    }
}
