package kr.ac.kumoh.oiyo.mydiaryback.repository;

import kr.ac.kumoh.oiyo.mydiaryback.domain.DiaryImage;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import java.util.List;

@Repository
@RequiredArgsConstructor
public class DiaryImageRepository {

    private final EntityManager em;

    // 생성
    public Long save(DiaryImage diaryImage) {
        em.persist(diaryImage);
        return diaryImage.getId();
    }

    /**
     * 일기 pk를 사용해 관련된 이미지 모두 조회
     * 일기 목록에서 특정 일기 클릭하면 호출된다.
     *
     * @param diaryId
     * @return
     */
    // 조회
    public List<String> findImagesByDiary(Long diaryId) {
        return em.createQuery("select di.imageFile from DiaryImage di join di.diary d on d.id = :dId", String.class)
                .setParameter("dId", diaryId)
                .getResultList();
    }
    
    // 삭제
}
