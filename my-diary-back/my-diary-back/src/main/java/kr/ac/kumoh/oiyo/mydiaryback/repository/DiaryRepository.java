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
     *
     * @param diary 엔티티 객체
     * @return diaryId (pk)
     */
    public Long save(Diary diary) {
        em.persist(diary);
        return diary.getId();
    }

    /**
     * em.find(Diary.class, diaryId)
     * 일기 수정할 때 호출됨
     *
     * @param id
     * @return
     */
    public Diary findOne(Long id) {
        Diary diary = em.find(Diary.class, id);
        return diary;
    }

    /**
     * 하나의 Diary 객체 조회
     * 일기 목록에서 특정 일기 클릭하면 호출된다.
     * 일기 제목, 여행 날짜, 일기 본문, 날씨, 여행지, 일기 생성 시간, 일기 수정 시간
     *
     * @param diaryId - pk
     * @return 조회한 diary 엔티티 객체
     */
    public Diary findDiary(Long diaryId) {
        return em.createQuery("select d from Diary d join fetch d.diaryImages where d.id = :diaryId", Diary.class)
                .setParameter("diaryId", diaryId)
                .getSingleResult();
    }

    /**
     * 여행별 일기 조회 메서드 (날짜 오름차순)
     * 지도에서 마커를 클릭하면 해당 메서드가 호출된다.
     * 일기 리스트에는 제목, 여행 날짜, 날씨만 표시
     * 일기 id도 함께 보내준다.
     *
     * @param travelId 클릭한 마커에 해당하는 여행Id
     * @return travelId에 해당하는 모든 일기 조회
     */
    public List<Diary> findDiariesByTravel(Long travelId) {
        return em.createQuery("select d from Diary d join d.travel t on t.id = :travelId", Diary.class)
                .setParameter("travelId", travelId).getResultList();
    }

    public void delete(Long diaryId) {
        Diary findDiary = findOne(diaryId);
        em.remove(findDiary);
    }

    /**
     * 사용자의 모든 일기 조회 (날짜 오름차순)
     *
     * @return 사용자가 작성한 모든 일기
     */
    /*public List<Diary> findAllByMember() {
        return em.createQuery("select d from Diary d ORDER BY d.createDate", Diary.class).getResultList();
    }*/

    /**
     * 여행별 일기 조회 메서드 (날짜 오름차순)
     *
     * @param travelId 클릭한 마커에 해당하는 여행Id
     * @return travelId에 해당하는 모든 일기 조회
     */
    /*public List<Diary> findDiariesByTravel(Long travelId) {
        return em.createQuery("select d from Diary d join d.travel t on t.id = :travelId ORDER BY d.travelDate", Diary.class)
                .setParameter("travelId", travelId)
                .getResultList();
    }*/

    /*public DiaryQueryDto findOne(Long diaryId) {
    return em.createQuery("select new kr.ac.kumoh.oiyo.mydiaryback.repository.dto.DiaryQueryDto"
                    + "(d.title, d.travelDate, d.mainText, d.weather, t.travelDestination, d.createDate, d.lastModifiedDate) "
                    + "from Diary d "
                    + "join d.travel t where d.id = :dId"
                    , DiaryQueryDto.class)
            .setParameter("dId", diaryId)
            .getSingleResult();
    }*/

    /*public List<DiaryQueryDtoByTravel> findDiariesByTravel(Long travelId) {
    return em.createQuery("select new kr.ac.kumoh.oiyo.mydiaryback.repository.dto.DiaryQueryDtoByTravel"
                            + "(d.id, d.title, d.travelDate, d.weather) from Diary d "
                            + "join d.travel t on t.id = :tId ORDER BY d.travelDate",
                    DiaryQueryDtoByTravel.class)
            .setParameter("tId", travelId)
            .getResultList();
    }*/
}
