package kr.ac.kumoh.oiyo.mydiaryback.repository;

import lombok.Getter;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.Column;
import javax.persistence.EntityListeners;
import javax.persistence.MappedSuperclass;
import java.time.LocalDateTime;

//Entity에 LifeCyle에 관련된 이번테에서 해당하는 이벤트를 Listen
//Auditing(자동으로 값 매핑) 기능 추가
@EntityListeners(AuditingEntityListener.class)
@Getter
@MappedSuperclass // BaseEntity를 상속한 Entity들은 아래 필드들을 컬럼으로 인식
public class BaseEntity {
    @CreatedDate
    @Column(updatable = false)
    private LocalDateTime created_at;

    @LastModifiedDate
    private LocalDateTime updated_at;
}
