# my_diary_front

A new Flutter project.

## Getting Started

# 안드로이드 sdk 버전 설정
1. C:\src\flutter\packages\flutter_tools\gradle\flutter.gradle에서
   compileSdkVersion, targetSdkVersion을 33, minSdkVersion을 21로 수정한다.

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
3. my-diary-front\ios\Runner\GoogleService-info.plist 추가
4. my-diary-front\.env 추가 + .env 파일 SERVER_URI 본인 환경에 맞게 수정 필요
   참고로 에뮬레이터 사용시 일반적으로 사용하는 localhost(127.0.0.1) 대신 10.0.2.2를 사용해야함
   에뮬레이터가 가상환경이라 컴퓨터 로컬에 접근하려면 에뮬레이터의 10.0.2.2를 통해야 함

# Kakao 로그인 해시키 등록
https://developers.kakao.com/docs/latest/ko/getting-started/sdk-android#add-key-hash

# null safety 허용
1. Run → Edit Configurations 에 들어간다
2. Additional run args : --no-sound-null-safety


✅ lib/view/pages/post 내의 파일, lib/controller/dto_* 파일의 host 수정 -> cmd 창 ipconfig -> 자신의 IPv4 주소

✅ lib/view/pages/post/mapPage -> FloatingActionButton으로 여행 작성 하는 부분에서 member id back에서 받아야 함

✅ 지도 클릭 시 마커 생성되는 예전 맵 -> 장소 검색해서 마커찍는 맵으로 바꿔야 함
마커 좌표는 lib/view/pages/post/travel_list_page -> fetchTravelList 의 queryParams에서 값을 임의로 넣었음 -> 검색한 좌표로 넣어야 함

📌 다이어리 이미지 수정 외 모든 crud 가능 이미지 수정은 완료하는 대로 올리겠습니다
