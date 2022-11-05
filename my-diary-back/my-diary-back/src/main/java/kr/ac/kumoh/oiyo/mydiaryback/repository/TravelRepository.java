package kr.ac.kumoh.oiyo.mydiaryback.repository;

import kr.ac.kumoh.oiyo.mydiaryback.domain.Travel;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import java.util.List;

@Repository
@RequiredArgsConstructor
public class TravelRepository {

    private final EntityManager em;

    /**
     * Travel DB에 저장
     * @param travel 엔티티 객체
     * @return travelId (pk)
     */
    public Long save(Travel travel) {
        em.persist(travel);
        return travel.getId();
    }

    /**
     * 사용자의 모든 여행 조회
     * @param memberId 사용자의 ID (pk)
     * @return 해당 사용자의 모든 여행 기록 조회
     */
    /*public List<Travel> findAllByMember(Long memberId) {
        em.createQuery("select t from Travel t join fetch t.diaries")
    }*/
}
