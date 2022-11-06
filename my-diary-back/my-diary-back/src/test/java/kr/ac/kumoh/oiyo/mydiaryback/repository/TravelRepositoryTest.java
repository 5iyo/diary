package kr.ac.kumoh.oiyo.mydiaryback.repository;

import kr.ac.kumoh.oiyo.mydiaryback.domain.Address;
import kr.ac.kumoh.oiyo.mydiaryback.domain.Member;
import kr.ac.kumoh.oiyo.mydiaryback.domain.Travel;
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
public class TravelRepositoryTest {

    @PersistenceContext
    private EntityManager em;

    @Autowired
    private TravelRepository travelRepository;

    @Test
    public void 사용자별_여행_조회_테스트() {

        // Given
        Member member = createMember("member1", "Member1", null, null, LocalDate.of(1999, 1, 1), "test@namer.com", null);
        em.persist(member);

        LocalDate sd = LocalDate.of(2022, 1, 1);
        LocalDate ed = LocalDate.of(2022, 1, 3);
        Travel travel = createTravel(member, "서울", "37.541°", "126.986", null, sd, ed);
        travelRepository.save(travel);

        LocalDate sd1 = LocalDate.of(2022, 1, 9);
        LocalDate ed1 = LocalDate.of(2022, 1, 10);
        Travel travel1 = createTravel(member, "구미", "37.000°", "127.486", null, sd1, ed1);
        travelRepository.save(travel1);

        LocalDate sd2 = LocalDate.of(2022, 2, 16);
        LocalDate ed2 = LocalDate.of(2022, 2, 18);
        Travel travel2 = createTravel(member, "속초", "37.541°", "128.986", null, sd2, ed2);
        travelRepository.save(travel2);

        // When
        em.flush();
        em.clear();

        List<Travel> travels = travelRepository.findTravelsByMember(member.getId());

        // Then
        assertThat(travels.get(0).getTravelDestination()).isEqualTo("서울");
        assertThat(travels.get(0).getTravelStartDate()).isEqualTo(sd);
        assertThat(travels.get(0).getTravelEndDate()).isEqualTo(ed);

        assertThat(travels.get(1).getTravelDestination()).isEqualTo("구미");
        assertThat(travels.get(1).getTravelStartDate()).isEqualTo(sd1);
        assertThat(travels.get(1).getTravelEndDate()).isEqualTo(ed1);

        assertThat(travels.get(2).getTravelDestination()).isEqualTo("속초");
        assertThat(travels.get(2).getTravelStartDate()).isEqualTo(sd2);
        assertThat(travels.get(2).getTravelEndDate()).isEqualTo(ed2);

    }

    private Member createMember(String id, String name, String pImg, String pIntroduction, LocalDate birthDate, String email, Address address) {
        LocalDateTime now = LocalDateTime.now();
        return new Member(now, now, id, name, pImg, pIntroduction, birthDate, email, address);
    }

    private Travel createTravel(Member member, String travelDestination, String travelLatitude, String travelLongitude, String travelImage, LocalDate travelStartDate, LocalDate travelEndDate) {
        LocalDateTime now = LocalDateTime.now();
        return new Travel(now, now, member, travelDestination, travelLatitude, travelLongitude, travelImage, travelStartDate, travelEndDate);
    }
}
