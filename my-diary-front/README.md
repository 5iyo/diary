# my_diary_front

A new Flutter project.

## Getting Started

# 안드로이드 sdk 버전 설정
1. C:\src\flutter\packages\flutter_tools\gradle\flutter.gradle 수정

   ...
   class FlutterExtension {
   /** Sets the compileSdkVersion used by default in Flutter app projects. */
   static int compileSdkVersion = 33

   /** Sets the minSdkVersion used by default in Flutter app projects. */
   static int minSdkVersion = 21

   /** Sets the targetSdkVersion used by default in Flutter app projects. */
   static int targetSdkVersion = 33
   ...

# API key 설정
1. my-diary-front\android\local.properties 수정
2. my-diary-front\android\app\google-services.json 추가
3. my-diary-front\.env 추가 + .env 파일 SERVER_URI 본인 환경에 맞게 수정 필요
   참고로 에뮬레이터 사용시 일반적으로 사용하는 localhost(127.0.0.1) 대신 10.0.2.2를 사용해야함
   에뮬레이터가 가상환경이라 컴퓨터 로컬에 접근하려면 에뮬레이터의 10.0.2.2를 통해야 함

# null safety 허용
1. Run → Edit Configurations 에 들어간다
2. Additional run args : --no-sound-null-safety