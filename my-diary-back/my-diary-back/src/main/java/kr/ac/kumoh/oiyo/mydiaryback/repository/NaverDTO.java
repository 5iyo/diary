package kr.ac.kumoh.oiyo.mydiaryback.repository;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class NaverDTO {
    private String n_name;
    private String n_email;

}
