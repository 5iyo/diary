package kr.ac.kumoh.oiyo.mydiaryback.domain.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class NaverDto {
    private String n_name;
    private String n_email;
    private String n_image;

}
