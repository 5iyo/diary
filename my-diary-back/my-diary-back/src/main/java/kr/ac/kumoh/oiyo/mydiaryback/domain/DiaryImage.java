package kr.ac.kumoh.oiyo.mydiaryback.domain;

import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Entity
@Getter
@NoArgsConstructor
public class DiaryImage {

    @Id
    @GeneratedValue
    @Column(name = "DIARY_IMAGE_ID")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DIARY_ID")
    private Diary diary;

    private String imageFile;

    public static DiaryImage createDiaryImage(Diary diary, String imageFile) {
        return new DiaryImage(diary, imageFile);
    }

    public DiaryImage(Diary diary, String imageFile) {
        setDiary(diary);
        this.imageFile = imageFile;
    }

    /* 연관관계 편의 메서드 */
    private void setDiary(Diary diary) {
        if (this.diary != null) {
            this.diary.getDiaryImages().remove(this);
        }
        this.diary = diary;
        diary.getDiaryImages().add(this);
    }
}
