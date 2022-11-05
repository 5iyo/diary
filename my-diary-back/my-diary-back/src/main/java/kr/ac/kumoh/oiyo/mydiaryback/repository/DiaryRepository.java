package kr.ac.kumoh.oiyo.mydiaryback.repository;

import kr.ac.kumoh.oiyo.mydiaryback.domain.Diary;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import java.util.List;

@Repository
@RequiredArgsConstructor
public class DiaryRepository {

    private final EntityManager em;

    /**
     * 일기 저장
     * @param diary 엔티티 객체
     * @return diaryId (pk)
     */
    public Long save(Diary diary) {
        em.persist(diary);
        return diary.getId();
    }

    /**
     * find(diaryId) 함수로 하나의 Diary 객체 조회
     * @param diaryId - pk
     * @return 조회한 diary 엔티티 객체
     */
    public Diary findOne(Long diaryId) {
        return em.find(Diary.class, diaryId);
    }

    /**
     * 여행별 일기 조회 메서드
     * 지도에서 마커를 클릭하면 해당 메서드가 호출된다.
     * @param travelId 클릭한 마커에 해당하는 여행Id
     * @return travelId에 해당하는 모든 일기 조회
     */
    public List<Diary> findDiariesByTravel(Long travelId) {
        return em.createQuery("select d from Diary d join d.travel t on t.id = :travelId", Diary.class)
                .setParameter("travelId", travelId)
                .getResultList();
    }

    /**
     * 사용자의 모든 일기 조회 (날짜 오름차순)
     * @return 사용자가 작성한 모든 일기
     */
    public List<Diary> findAllByMember() {
        return em.createQuery("select d from Diary d ORDER BY d.createDate", Diary.class).getResultList();
    }
}
