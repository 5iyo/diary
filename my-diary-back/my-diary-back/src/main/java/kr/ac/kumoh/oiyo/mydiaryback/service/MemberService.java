package kr.ac.kumoh.oiyo.mydiaryback.service;

import kr.ac.kumoh.oiyo.mydiaryback.domain.Member;
import kr.ac.kumoh.oiyo.mydiaryback.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class MemberService {

    private final MemberRepository memberRepository;

    @Transactional
    public String join(Member member) {
        memberRepository.save(member);
        return member.getId();
    }

    public Member findOne(String memberId) {
        return memberRepository.findOne(memberId);
    }

    @Transactional
    public void deleteMember(String memberId) {
        memberRepository.delete(memberId);
    }
}
