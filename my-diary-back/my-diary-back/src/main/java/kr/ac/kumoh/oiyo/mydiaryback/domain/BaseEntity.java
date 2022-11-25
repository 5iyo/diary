package kr.ac.kumoh.oiyo.mydiaryback.domain;

import lombok.Getter;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.Column;
import javax.persistence.EntityListeners;
import javax.persistence.MappedSuperclass;
import java.time.LocalDateTime;

@MappedSuperclass
@Getter
@EntityListeners(AuditingEntityListener.class)
public abstract class BaseEntity {

    // 생성일자
    @CreatedDate
    @Column(name = "CREATE_DATE", updatable = false)
    private LocalDateTime createDate;

    // 수정일자
    @LastModifiedDate
    @Column(name = "LAST_MODIFIED_DATE", updatable = true)
    private LocalDateTime lastModifiedDate;
}