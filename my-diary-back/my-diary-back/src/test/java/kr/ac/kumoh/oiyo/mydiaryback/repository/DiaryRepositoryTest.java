package kr.ac.kumoh.oiyo.mydiaryback.repository;

import kr.ac.kumoh.oiyo.mydiaryback.domain.Address;
import kr.ac.kumoh.oiyo.mydiaryback.domain.Diary;
import kr.ac.kumoh.oiyo.mydiaryback.domain.Member;
import kr.ac.kumoh.oiyo.mydiaryback.domain.Travel;
import kr.ac.kumoh.oiyo.mydiaryback.repository.dto.FindDiaryDtoByTravel;
import kr.ac.kumoh.oiyo.mydiaryback.repository.dto.FindOneDiaryDto;
import org.assertj.core.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import static org.assertj.core.api.Assertions.*;

@SpringBootTest
@Transactional
public class DiaryRepositoryTest {

    @PersistenceContext
    private EntityManager em;

    @Autowired
    private DiaryRepository diaryRepository;

    private LocalDateTime now = LocalDateTime.of(2022, 11, 6, 22, 33, 16);

    @Test
    public void 일기조회_테스트() {

        // Given
        Member member = createMember("member1", "Member1", null, null, LocalDate.of(1999, 1, 1), "test@namer.com", null);
        em.persist(member);

        LocalDate sd = LocalDate.of(2022, 1, 1);
        LocalDate ed = LocalDate.of(2022, 1, 3);
        Travel travel = createTravel(member, "서울", "37.541°", "126.986", null, sd, ed);
        em.persist(travel);

        LocalDate diaryDate1 = LocalDate.of(2022, 1, 1);
        LocalDate diaryDate2 = LocalDate.of(2022, 1, 2);
        LocalDate diaryDate3 = LocalDate.of(2022, 1, 3);
        Diary diary1 = createDiary("diary1", diaryDate1, "주절주절", "맑음", travel);
        Diary diary2 = createDiary("diary2", diaryDate2, "절주절주", "흐림", travel);
        Diary diary3 = createDiary("diary3", diaryDate3, "쥬절쥬절", "비", travel);
        diaryRepository.save(diary1);
        diaryRepository.save(diary2);
        diaryRepository.save(diary3);

        // When
        em.flush();
        em.clear();

        FindOneDiaryDto f = diaryRepository.findOne(diary2.getId());

        // Then
        assertThat(f.getTitle()).isEqualTo("diary2");
        assertThat(f.getTravelDate()).isEqualTo(diaryDate2);
        assertThat(f.getMainText()).isEqualTo("절주절주");
        assertThat(f.getWeather()).isEqualTo("흐림");
        assertThat(f.getTravelDestination()).isEqualTo("서울");
        assertThat(f.getCreatedDate()).isEqualTo(now);
        assertThat(f.getLastModifiedDate()).isEqualTo(now);

    }

    @Test
    public void 여행별_일기조회_테스트() {

        // Given
        Member member = createMember("member1", "Member1", null, null, LocalDate.of(1999, 1, 1), "test@namer.com", null);
        em.persist(member);

        LocalDate sd = LocalDate.of(2022, 1, 1);
        LocalDate ed = LocalDate.of(2022, 1, 3);
        Travel travel = createTravel(member, "서울", "37.541°", "126.986", null, sd, ed);
        em.persist(travel);

        LocalDate diaryDate1 = LocalDate.of(2022, 1, 1);
        LocalDate diaryDate2 = LocalDate.of(2022, 1, 2);
        LocalDate diaryDate3 = LocalDate.of(2022, 1, 3);
        Diary diary1 = createDiary("diary1", diaryDate1, "주절주절", "맑음", travel);
        Diary diary2 = createDiary("diary2", diaryDate2, "절주절주", "흐림", travel);
        Diary diary3 = createDiary("diary3", diaryDate3, "쥬절쥬절", "비", travel);
        diaryRepository.save(diary1);
        diaryRepository.save(diary2);
        diaryRepository.save(diary3);

        // When
        em.flush();
        em.clear();

        List<FindDiaryDtoByTravel> diaryDtoByTravels = diaryRepository.findDiaryDtoByTravel(travel.getId());

        // Then
        assertThat(diaryDtoByTravels.get(0).getDiaryId()).isEqualTo(diary1.getId());
        assertThat(diaryDtoByTravels.get(0).getTitle()).isEqualTo("diary1");
        assertThat(diaryDtoByTravels.get(0).getTravelDate()).isEqualTo(diaryDate1);
        assertThat(diaryDtoByTravels.get(0).getWeather()).isEqualTo("맑음");

        assertThat(diaryDtoByTravels.get(1).getDiaryId()).isEqualTo(diary2.getId());
        assertThat(diaryDtoByTravels.get(1).getTitle()).isEqualTo("diary2");
        assertThat(diaryDtoByTravels.get(1).getTravelDate()).isEqualTo(diaryDate2);
        assertThat(diaryDtoByTravels.get(1).getWeather()).isEqualTo("흐림");

        assertThat(diaryDtoByTravels.get(2).getDiaryId()).isEqualTo(diary3.getId());
        assertThat(diaryDtoByTravels.get(2).getTitle()).isEqualTo("diary3");
        assertThat(diaryDtoByTravels.get(2).getTravelDate()).isEqualTo(diaryDate3);
        assertThat(diaryDtoByTravels.get(2).getWeather()).isEqualTo("비");
    }

    private Member createMember(String id, String name, String pImg, String pIntroduction, LocalDate birthDate, String email, Address address) {
        LocalDateTime now = LocalDateTime.now();
        return new Member(now, now, id, name, pImg, pIntroduction, birthDate, email, address);
    }

    private Travel createTravel(Member member, String travelDestination, String travelLatitude, String travelLongitude, String travelImage, LocalDate travelStartDate, LocalDate travelEndDate) {
        return new Travel(now, now, member, travelDestination, travelLatitude, travelLongitude, travelImage, travelStartDate, travelEndDate);
    }

    private Diary createDiary(String title, LocalDate travelDate, String mainText, String weather, Travel travel) {
        return new Diary(now, now, title, travelDate, mainText, weather, travel);
    }
    
    /*@Test
    public void 여행별_일기조회_테스트() {

        // Given
        Member member = createMember("member1", "Member1", null, null, LocalDate.of(1999, 1, 1), "test@namer.com", null);
        em.persist(member);

        LocalDate sd = LocalDate.of(2022, 1, 1);
        LocalDate ed = LocalDate.of(2022, 1, 3);
        Travel travel = createTravel(member, "서울", "37.541°", "126.986", null, sd, ed);
        em.persist(travel);

        LocalDate diaryDate1 = LocalDate.of(2022, 1, 3);
        LocalDate diaryDate2 = LocalDate.of(2022, 1, 2);
        LocalDate diaryDate3 = LocalDate.of(2022, 1, 1);
        Diary diary1 = createDiary("diary1", diaryDate1, "주절주절", "맑음", travel);
        Diary diary2 = createDiary("diary2", diaryDate2, "절주절주", "흐림", travel);
        Diary diary3 = createDiary("diary3", diaryDate3, "쥬절쥬절", "비", travel);
        diaryRepository.save(diary1);
        diaryRepository.save(diary2);
        diaryRepository.save(diary3);

        // When
        em.flush();
        em.clear();

        List<Diary> diaries = diaryRepository.findDiariesByTravel(travel.getId());

        // Then
        assertThat(diaries.get(2).getTitle()).isEqualTo("diary1");
        assertThat(diaries.get(2).getTravelDate()).isEqualTo(diaryDate1);
        assertThat(diaries.get(2).getWeather()).isEqualTo("맑음");
        assertThat(diaries.get(2).getMainText()).isEqualTo("주절주절");

        assertThat(diaries.get(1).getTitle()).isEqualTo("diary2");
        assertThat(diaries.get(1).getTravelDate()).isEqualTo(diaryDate2);
        assertThat(diaries.get(1).getWeather()).isEqualTo("흐림");
        assertThat(diaries.get(1).getMainText()).isEqualTo("절주절주");

        assertThat(diaries.get(0).getTitle()).isEqualTo("diary3");
        assertThat(diaries.get(0).getTravelDate()).isEqualTo(diaryDate3);
        assertThat(diaries.get(0).getWeather()).isEqualTo("비");
        assertThat(diaries.get(0).getMainText()).isEqualTo("쥬절쥬절");
    }*/
}
