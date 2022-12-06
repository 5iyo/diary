package kr.ac.kumoh.oiyo.mydiaryback.domain.dto;

import kr.ac.kumoh.oiyo.mydiaryback.domain.Travel;
import kr.ac.kumoh.oiyo.mydiaryback.domain.User;
import lombok.Data;

import java.time.LocalDate;

@Data
public class TravelsOfUserDto {

    String travelTitle;
    String travelArea;
    String travelLatitude;
    String travelLongitude;
    String travelImage;
    LocalDate travelStartDate;
    LocalDate travelEndDate;



    public TravelsOfUserDto(Travel travel) {
        this.travelTitle = travel.getTravelTitle();
        this.travelArea = travel.getTravelArea();
        this.travelLatitude = travel.getTravelLatitude();
        this.travelLongitude = travel.getTravelLongitude();
        this.travelImage = travel.getTravelImage();
        this.travelStartDate = travel.getTravelStartDate();
        this.travelEndDate = travel.getTravelEndDate();
    }
}
