package kr.ac.kumoh.oiyo.mydiaryback.domain.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class GoogleDto {
    private String g_name;
    private String g_email;
    private String g_image;

//   public String id;
//    public String email;
//    public Boolean verifiedEmail;
//    public String name;
//    public String givenName;
//    public String familyName;
//    public String picture;
//    public String locale;
}
