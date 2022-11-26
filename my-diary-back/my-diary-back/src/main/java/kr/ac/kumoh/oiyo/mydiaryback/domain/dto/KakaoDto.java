package kr.ac.kumoh.oiyo.mydiaryback.domain.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class KakaoDto {
    private String k_name;
    private String k_email;
    private String k_image;
}
