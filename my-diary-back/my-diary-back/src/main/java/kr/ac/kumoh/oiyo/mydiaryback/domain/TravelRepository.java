package kr.ac.kumoh.oiyo.mydiaryback.domain;

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

    public Travel findOne(Long travelId) {
        return em.find(Travel.class, travelId);
    }

    public Travel findTravel(Long travelId) {
        return em.createQuery("select t from Travel t join fetch t.diaries where t.id = :travelId", Travel.class)
                .setParameter("travelId", travelId)
                .getSingleResult();
    }

    /**
     * 사용자의 모든 여행 조회
     * 로그인하고 지도에 여행지 마커 표시할 때 사용
     * @param memberId 사용자의 ID (pk)
     * @return 해당 사용자의 모든 여행 기록 조회
     */
    public List<Travel> findTravelsByMember(Long memberId) {
        return em.createQuery("select t from Travel t" +
                        " join t.user m on m.id = :mId", Travel.class)
                .setParameter("mId", memberId)
                .getResultList();
    }

    public List<Travel> findTravelsByCoordinate(Long userId, String travelLatitude, String travelLongitude) {
       return em.createQuery("select t from Travel t" +
                               " join t.user u on u.id = :userId" +
                               " where t.travelLatitude = :travelLatitude" +
                               " and t.travelLongitude = :travelLongitude"
                        , Travel.class)
                .setParameter("userId", userId)
                .setParameter("travelLatitude", travelLatitude)
                .setParameter("travelLongitude", travelLongitude)
                .getResultList();
    }

    public void delete(Long travelId) {
        Travel findTravel = findOne(travelId);
        em.remove(findTravel);
    }
}
