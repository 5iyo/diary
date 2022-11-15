package kr.ac.kumoh.oiyo.mydiaryback.repository;

import kr.ac.kumoh.oiyo.mydiaryback.domain.Member;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;

@Repository
@RequiredArgsConstructor
public class MemberRepository {

    private final EntityManager em;

    public String save(Member member) {
        em.persist(member);
        return member.getId();
    }

    public Member findOne(String memberId) {
        return em.find(Member.class, memberId);
    }

    public void delete(String memberId) {
        Member findMember = findOne(memberId);
        em.remove(findMember);
    }
}
