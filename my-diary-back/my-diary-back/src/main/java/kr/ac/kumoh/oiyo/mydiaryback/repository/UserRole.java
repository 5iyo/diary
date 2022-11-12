package kr.ac.kumoh.oiyo.mydiaryback.repository;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum UserRole {
    USER("USER","사용자"),
    GUEST("GUEST","손님");
    private final String key;
    private final String title;
}
