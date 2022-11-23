package kr.ac.kumoh.oiyo.mydiaryback.repository;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class KakaoDTO {
    private String k_name;
    private String k_email;
    private String k_image;
}
