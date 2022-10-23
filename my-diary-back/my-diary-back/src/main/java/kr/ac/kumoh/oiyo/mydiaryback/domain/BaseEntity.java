package kr.ac.kumoh.oiyo.mydiaryback.domain;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.MappedSuperclass;
import java.time.LocalDateTime;

@MappedSuperclass
@Getter
@Setter
public class BaseEntity {
    private String createBy;
    private LocalDateTime createDate;
    private String modifiedBy;
    private LocalDateTime lastModifiedDate;
}