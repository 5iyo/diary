package kr.ac.kumoh.oiyo.mydiaryback.api;

import com.fasterxml.jackson.annotation.JsonFormat;
import kr.ac.kumoh.oiyo.mydiaryback.domain.Travel;
import kr.ac.kumoh.oiyo.mydiaryback.domain.User;
import kr.ac.kumoh.oiyo.mydiaryback.service.TravelService;
import kr.ac.kumoh.oiyo.mydiaryback.service.UserService;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequiredArgsConstructor
public class TravelApiController {

    private final TravelService travelService;

    private final UserService userService;

    /**
     * 여행 추가
     * @param memberId 사용자 ID (PK)
     * @param createTravelRequest REQUEST BODY
     * @return
     */
    @PostMapping("/api/user/{id}/travels")
    public ResponseEntity saveTravel(@PathVariable("id") String memberId, @RequestBody @Valid CreateTravelRequest createTravelRequest) {

        User user = userService.findUserbyId(Long.parseLong(memberId));

        String travelTitle = createTravelRequest.getTravelTitle();
        String travelArea = createTravelRequest.getTravelArea();
        String travelLatitude = createTravelRequest.getTravelLatitude();
        String travelLongitude = createTravelRequest.getTravelLongitude();
        String travelImage = createTravelRequest.getTravelImage();
        LocalDate travelStartDate = createTravelRequest.getTravelStartDate();
        LocalDate travelEndDate = createTravelRequest.getTravelEndDate();

        Travel travel = new Travel(user, travelTitle, travelArea, travelLatitude,
                travelLongitude, travelImage, travelStartDate, travelEndDate);

        Long saveTravelId = travelService.saveTravel(travel);

        CreateTravelResponse createTravelResponse = new CreateTravelResponse(saveTravelId);

        return new ResponseEntity(createTravelResponse, HttpStatus.CREATED);

    }


    /**
     * 여행 삭제
     * @param travelId 여행 ID (PK)
     * @return
     */
    @DeleteMapping("/api/travels/{id}")
    public ResponseEntity deleteTravel(@PathVariable("id") Long travelId) {

        travelService.deleteTravel(travelId);

        return new ResponseEntity(HttpStatus.OK);
    }

    /**
     * 여행 목록 조회 (지도 마커 표시용)
     * @param memberId 사용자 ID (PK)
     * @return
     */
    @GetMapping("/api/user/{id}/inquire-travels")
    public ResponseEntity inquireTravelsInMap(@PathVariable("id") String memberId) {
        List<Travel> travels = travelService.inquiryTravelsByMember(memberId);

        List<TravelCoordinateDto> collect = travels.stream()
                .map(t -> new TravelCoordinateDto(t))
                .collect(Collectors.toList());

        return new ResponseEntity(collect, HttpStatus.OK);
    }

    /**
     * 여행 목록 출력 (지도 마커 클릭 시)
     * @param findTravelsRequest REQUEST BODY
     * @return
     */
    @GetMapping("/api/travels")
    public ResponseEntity inquireTravelsByCoordinate(FindTravelsRequest findTravelsRequest) {

        String travelLatitude = findTravelsRequest.getTravelLatitude();
        String travelLongitude = findTravelsRequest.getTravelLongitude();

        List<Travel> travels = travelService.inquiryTravelsByCoordinate(travelLatitude, travelLongitude);

        List<TravelListDto> collect = travels.stream()
                .map(t -> new TravelListDto(t))
                .collect(Collectors.toList());

        Result result = new Result(collect);

        return new ResponseEntity(result, HttpStatus.OK);
    }


    /**
     * 특정 여행 조회
     *
     * @param travelId 여행 ID (PK)
     * @return
     */
    @GetMapping("/api/travels/{id}")
    public ResponseEntity inquireTravel(@PathVariable("id") Long travelId) {

        Travel findTravel = travelService.findOne(travelId);

        TravelDto travelDto = new TravelDto(findTravel);

        return new ResponseEntity(travelDto, HttpStatus.OK);
    }

    /**
     * 특정 여행 수정
     * @param travelId 여행 ID (PK)
     * @param updateTravelRequest REQUEST BODY (수정할 내용)
     * @return
     */
    @PatchMapping("/api/travels/{id}")
    public ResponseEntity modifyTravel(@PathVariable("id") Long travelId, @RequestBody @Valid UpdateTravelRequest updateTravelRequest) {
        String travelTitle = updateTravelRequest.getTravelTitle();
        String travelImage = updateTravelRequest.getTravelImage();
        LocalDate travelStartDate = updateTravelRequest.getTravelStartDate();
        LocalDate travelEndDate = updateTravelRequest.getTravelEndDate();

        travelService.update(travelId, travelTitle, travelImage, travelStartDate, travelEndDate);

        return new ResponseEntity(HttpStatus.OK);
    }

    @Data
    @AllArgsConstructor
    static class Result<T> {
        private T travels;
    }

    @Data
    static class UpdateTravelRequest {
        private String travelTitle;
        private String travelImage;
        private LocalDate travelStartDate;
        private LocalDate travelEndDate;
    }

    @Data
    static class TravelDto {
        private String travelTitle;
        private String travelArea;
        private String travelImage;
        private LocalDate travelStartDate;
        private LocalDate travelEndDate;

        public TravelDto(Travel travel) {
            this.travelTitle = travel.getTravelTitle();
            this.travelArea = travel.getTravelArea();
            this.travelImage = travel.getTravelImage();
            this.travelStartDate = travel.getTravelStartDate();
            this.travelEndDate = travel.getTravelEndDate();
        }
    }

    @Data
    static class FindTravelsRequest {
        private String travelLatitude;
        private String travelLongitude;
    }

    @Data
    static class TravelListDto {

        private Long travelId;
        private String travelTitle;
        private String travelImage;
        @JsonFormat(pattern = "yyyy-MM-dd")
        private LocalDate travelStartDate;
        @JsonFormat(pattern = "yyyy-MM-dd")
        private LocalDate travelEndDate;

        public TravelListDto(Travel travel) {
            this.travelId = travel.getId();
            this.travelTitle = travel.getTravelTitle();
            this.travelImage = travel.getTravelImage();
            this.travelStartDate = travel.getTravelStartDate();
            this.travelEndDate = travel.getTravelEndDate();
        }
    }

    @Data
    static class TravelCoordinateDto {
        private String travelTitle;
        private String travelArea;
        private String travelLatitude;
        private String travelLongitude;
        private String travelImage;

        public TravelCoordinateDto(Travel travel) {
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
