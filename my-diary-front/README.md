# my_diary_front

A new Flutter project.

## Getting Started

# 안드로이드 sdk 버전 설정
1. C:\src\flutter\packages\flutter_tools\gradle\flutter.gradle 수정

# API key 설정
1. my-diary-front\android\local.properties 수정
2. my-diary-front\android\app\google-services.json 추가
3. my-diary-front\.env 추가 + .env 파일 SERVER_URI 본인 환경에 맞게 수정 필요

# null safety 허용
1. Run → Edit Configurations 에 들어간다
2. Additional run args : --no-sound-null-safety