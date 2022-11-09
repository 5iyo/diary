package kr.ac.kumoh.oiyo.mydiaryback.service;

import kr.ac.kumoh.oiyo.mydiaryback.domain.Travel;
import kr.ac.kumoh.oiyo.mydiaryback.repository.TravelRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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

    @Transactional
    public void deleteTravel(Long travelId) {
        travelRepository.delete(travelId);
    }
}
