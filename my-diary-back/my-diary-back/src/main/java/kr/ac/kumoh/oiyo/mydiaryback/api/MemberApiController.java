package kr.ac.kumoh.oiyo.mydiaryback.api;

import kr.ac.kumoh.oiyo.mydiaryback.domain.Address;
import kr.ac.kumoh.oiyo.mydiaryback.domain.Member;
import kr.ac.kumoh.oiyo.mydiaryback.service.MemberService;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.time.LocalDate;
import java.time.LocalDateTime;

@RestController
@RequiredArgsConstructor
public class MemberApiController {

    private final MemberService memberService;

    // 회원 생성
    @PostMapping("/api/members")
    public ResponseEntity saveMember(@RequestBody @Valid CreateMemberRequest createMemberRequest) {

        LocalDateTime now = LocalDateTime.now();

        String memberId = createMemberRequest.getMemberId();
        String name = createMemberRequest.getName();
        String profileImage = createMemberRequest.getProfileImage();
        String profileIntroduction = createMemberRequest.getProfileIntroduction();
        LocalDate birthDate = createMemberRequest.getBirthDate();
        String email = createMemberRequest.getEmail();

        String city = createMemberRequest.getCity();
        String street = createMemberRequest.getStreet();
        String zipcode = createMemberRequest.getZipcode();

        Address address = new Address(city, street, zipcode);

        Member member = new Member(now, now, memberId, name, profileImage, profileIntroduction, birthDate, email, address);

        String saveMemberId = memberService.join(member);

        CreateMemberResponse createMemberResponse = new CreateMemberResponse(saveMemberId);

        return new ResponseEntity(createMemberResponse, HttpStatus.CREATED);
    }

    // 회원 삭제
    @DeleteMapping("/api/members/{id}")
    public ResponseEntity deleteMember(@PathVariable("id") String memberId) {
        memberService.deleteMember(memberId);

        return new ResponseEntity(HttpStatus.OK);
    }

    // 마이페이지에 조회할 때 사용
    @GetMapping("/api/members/{id}")
    public ResponseEntity inquiryMember(@PathVariable("id") String memberId) {
        Member findMember = memberService.findOne(memberId);

        String name = findMember.getName();
        String profileImg = findMember.getProfileImg();
        String profileIntroduction = findMember.getProfileIntroduction();
        LocalDate birthDate = findMember.getBirthDate();
        String email = findMember.getEmail();
        Address address = findMember.getAddress();
        String city = address.getCity();
        String street = address.getStreet();
        String zipcode = address.getZipcode();

        MemberDto memberDto = new MemberDto(name, profileImg, profileIntroduction, birthDate, email, city, street, zipcode);
        
        return new ResponseEntity(memberDto, HttpStatus.OK);
    }

    @Data
    @AllArgsConstructor
    static class MemberDto {
        private String name;
        private String profileImage;
        private String profileIntroduction;
        @DateTimeFormat(pattern = "yyyy-MM-dd")
        private LocalDate birthDate;
        private String email;
        private String city;
        private String street;
        private String zipcode;
    }

    @Data
    @AllArgsConstructor
    static class CreateMemberResponse {
        private String id;
    }

    @Data
    static class CreateMemberRequest {
        private String memberId;
        private String name;
        private String profileImage;
        private String profileIntroduction;
        @DateTimeFormat(pattern = "yyyy-MM-dd")
        private LocalDate birthDate;
        private String email;
        private String city;
        private String street;
        private String zipcode;
    }
}
