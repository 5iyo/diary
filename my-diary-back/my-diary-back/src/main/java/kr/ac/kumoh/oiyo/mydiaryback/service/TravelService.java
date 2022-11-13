package kr.ac.kumoh.oiyo.mydiaryback.service;

import kr.ac.kumoh.oiyo.mydiaryback.domain.Travel;
import kr.ac.kumoh.oiyo.mydiaryback.repository.TravelRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class TravelService {

    private final TravelRepository travelRepository;

    @Transactional
    public Long saveTravel(Travel travel) {
        travelRepository.save(travel);
        return travel.getId();
    }

    public Travel findOne(Long travelId) {
        return travelRepository.findOne(travelId);
    }

    public Travel findTravel(Long travelId) {
        return travelRepository.findTravel(travelId);
    }

    /**
     * 사용자의 모든 여행 조회
     * 로그인하고 지도에 여행지 마커 표시할 때 사용
     * @param memberId 사용자의 ID (pk)
     * @return 해당 사용자의 모든 여행 기록 조회
     */
    public List<Travel> inquiryTravelsByMember(String memberId) {
        return travelRepository.findTravelsByMember(memberId);
    }

    public List<Travel> inquiryTravelsByCoordinate(String travelLatitude, String travelLongitude) {
        return travelRepository.findTravelsByCoordinate(travelLatitude, travelLongitude);
    }

    @Transactional
    public void deleteTravel(Long travelId) {
        travelRepository.delete(travelId);
    }
}
