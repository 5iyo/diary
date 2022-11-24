package kr.ac.kumoh.oiyo.mydiaryback.api;

import com.fasterxml.jackson.annotation.JsonFormat;
import kr.ac.kumoh.oiyo.mydiaryback.domain.Member;
import kr.ac.kumoh.oiyo.mydiaryback.domain.Travel;
import kr.ac.kumoh.oiyo.mydiaryback.service.MemberService;
import kr.ac.kumoh.oiyo.mydiaryback.service.TravelService;
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
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequiredArgsConstructor
public class TravelApiController {

    private final TravelService travelService;

    private final MemberService memberService;

    @PostMapping("/api/travels/{id}")
    public ResponseEntity saveTravel(@PathVariable("id") String memberId, @RequestBody @Valid CreateTravelRequest createTravelRequest) {

        Member member = memberService.findOne(memberId);

        LocalDateTime now = LocalDateTime.now();

        String travelTitle = createTravelRequest.getTravelTitle();
        String travelArea = createTravelRequest.getTravelArea();
        String travelLatitude = createTravelRequest.getTravelLatitude();
        String travelLongitude = createTravelRequest.getTravelLongitude();
        String travelImage = createTravelRequest.getTravelImage();
        LocalDate travelStartDate = createTravelRequest.getTravelStartDate();
        LocalDate travelEndDate = createTravelRequest.getTravelEndDate();

        Travel travel = new Travel(now, now, member, travelTitle, travelArea, travelLatitude,
                travelLongitude, travelImage, travelStartDate, travelEndDate);

        Long saveTravelId = travelService.saveTravel(travel);

        CreateTravelResponse createTravelResponse = new CreateTravelResponse(saveTravelId);

        return new ResponseEntity(createTravelResponse, HttpStatus.CREATED);

    }

    @DeleteMapping("/api/travels/{id}")
    public ResponseEntity deleteTravel(@PathVariable("id") Long travelId) {

        travelService.deleteTravel(travelId);

        return new ResponseEntity(HttpStatus.OK);
    }

    @GetMapping("/api/travels/{id}")
    public ResponseEntity inquiryTravelsInMap(@PathVariable("id") String memberId) {
        List<Travel> travels = travelService.inquiryTravelsByMember(memberId);

        List<TravelDto> collect = travels.stream()
                .map(t -> new TravelDto(t))
                .collect(Collectors.toList());

        return new ResponseEntity(collect, HttpStatus.OK);
    }

    @GetMapping("/api/travels")
    public ResponseEntity inquiryTravelsByCoordinate(@RequestBody @Valid FindTravelsRequest findTravelsRequest) {

        String travelLatitude = findTravelsRequest.getTravelLatitude();
        String travelLongitude = findTravelsRequest.getTravelLongitude();

        List<Travel> travels = travelService.inquiryTravelsByCoordinate(travelLatitude, travelLongitude);

        List<TravelListDto> collect = travels.stream()
                .map(t -> new TravelListDto(t))
                .collect(Collectors.toList());

        Result result = new Result(collect);

        return new ResponseEntity(result, HttpStatus.OK);
    }

    @Data
    @AllArgsConstructor
    static class Result<T> {
        private T travels;
    }

    @Data
    static class FindTravelsRequest {
        private String travelLatitude;
        private String travelLongitude;
    }

    @Data
    static class TravelListDto {
        private String travelTitle;
        private String travelImage;
        @JsonFormat(pattern = "yyyy-MM-dd")
        private LocalDate travelStartDate;
        @JsonFormat(pattern = "yyyy-MM-dd")
        private LocalDate travelEndDate;

        public TravelListDto(Travel travel) {
            this.travelTitle = travel.getTravelTitle();
            this.travelImage = travel.getTravelImage();
            this.travelStartDate = travel.getTravelStartDate();
            this.travelEndDate = travel.getTravelEndDate();
        }
    }

    @Data
    static class TravelDto {
        private String travelTitle;
        private String travelArea;
        private String travelLatitude;
        private String travelLongitude;
        private String travelImage;

        public TravelDto(Travel travel) {
            this.travelTitle = travel.getTravelTitle();
            this.travelArea = travel.getTravelArea();
            this.travelLatitude = travel.getTravelLatitude();
            this.travelLongitude = travel.getTravelLongitude();
            this.travelImage = travel.getTravelImage();
        }
    }

    @Data
    @AllArgsConstructor
    static class CreateTravelResponse {
        private Long id;
    }

    @Data
    static class CreateTravelRequest {
        private String travelTitle;
        private String travelArea;
        private String travelLatitude;
        private String travelLongitude;
        private String travelImage;
        @DateTimeFormat(pattern = "yyyy-MM-dd")
        private LocalDate travelStartDate;
        @DateTimeFormat(pattern = "yyyy-MM-dd")
        private LocalDate travelEndDate;
    }
}
