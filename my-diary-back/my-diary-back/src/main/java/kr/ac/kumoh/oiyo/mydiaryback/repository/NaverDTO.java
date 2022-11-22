package kr.ac.kumoh.oiyo.mydiaryback.repository;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class NaverDTO {
    private String N_name;
    private String N_email;

}
