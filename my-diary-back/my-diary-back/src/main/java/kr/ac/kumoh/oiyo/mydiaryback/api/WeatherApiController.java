package kr.ac.kumoh.oiyo.mydiaryback.api;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

@RestController
public class WeatherApiController {
    public Map<String, String> locationList = Map.ofEntries(
            Map.entry("Seoul", "서울"),
            Map.entry("Incheon", "인천"),
            Map.entry("Daegu", "대구"),
            Map.entry("Busan", "부산"),
            Map.entry("Ulsan", "울산"),
            Map.entry("Gapyeong", "가평"),
            Map.entry("Gwacheon", "과천"),
            Map.entry("Gwangju", "광주"),
            Map.entry("Gunpo", "군포"),
            Map.entry("Namyangju", "남양주"),
            Map.entry("Bucheon", "부천"),
            Map.entry("Suwon", "수원"),
            Map.entry("Ansan", "안산"),
            Map.entry("Anyang", "안양"),
            Map.entry("Yongin", "용인"),
            Map.entry("Paju", "파주"),
            Map.entry("Hwaseong", "화성"),
            Map.entry("Goyang", "고양"),
            Map.entry("Guri", "구리"),
            Map.entry("Seongnam", "성남"),
            Map.entry("Anseong", "안성"),
            Map.entry("Yangju", "양주"),
            Map.entry("Yeoju", "여주"),
            Map.entry("Osan", "오산"),
            Map.entry("Uiwang", "의왕"),
            Map.entry("Pyeongtaek", "평택"),
            Map.entry("Hanam", "하남"),
            Map.entry("Gangneung", "강릉"),
            Map.entry("Sokcho", "속초"),
            Map.entry("Yangyang", "양양"),
            Map.entry("Wonju", "원주"),
            Map.entry("Chuncheon", "춘천"),
            Map.entry("Hwacheon", "화천"),
            Map.entry("Samcheok", "삼척"),
            Map.entry("Goseong", "고성"),
            Map.entry("Yanggu", "양구"),
            Map.entry("Inje", "인제"),
            Map.entry("Taebaek", "태백"),
            Map.entry("Namhae", "남해"),
            Map.entry("Miryang", "밀양"),
            Map.entry("Uiryeong", "의령"),
            Map.entry("Changwon", "창원"),
            Map.entry("Hadong", "하동"),
            Map.entry("Hamyang", "함양"),
            Map.entry("Gimhae", "김해"),
            Map.entry("Masan", "마산"),
            Map.entry("Sacheon", "사천"),
            Map.entry("Yangsan", "양산"),
            Map.entry("Jinju", "진주"),
            Map.entry("Changnyeong", "창녕"),
            Map.entry("Haman", "함안"),
            Map.entry("Hapcheon", "함천"),
            Map.entry("Gyeongsan", "경산"),
            Map.entry("Gyeongju", "경주"),
            Map.entry("Gumi", "구미"),
            Map.entry("Gunwi", "군위"),
            Map.entry("Gimcheon", "김천"),
            Map.entry("Mungyeong", "문경"),
            Map.entry("Bonghwa", "봉화"),
            Map.entry("Sangju", "상주"),
            Map.entry("Seongju", "성주"),
            Map.entry("Andong", "안동"),
            Map.entry("Yeongyang", "영양"),
            Map.entry("Yeongju", "영주"),
            Map.entry("Yecheon", "예천"),
            Map.entry("Uiseong", "의성"),
            Map.entry("Cheongdo", "청도"),
            Map.entry("Cheongsong", "청송"),
            Map.entry("Chilgok", "칠곡"),
            Map.entry("Pohang", "포항"),
            Map.entry("Gokseong", "곡성"),
            Map.entry("Gwangyang", "광양"),
            Map.entry("Naju", "나주"),
            Map.entry("Damyang", "담양"),
            Map.entry("Mokpo", "목포"),
            Map.entry("Muan", "무안"),
            Map.entry("Boseong", "보성"),
            Map.entry("Suncheon", "순천"),
            Map.entry("Shinan", "신안"),
            Map.entry("Yeosu", "여수"),
            Map.entry("Yeonggwang", "영광"),
            Map.entry("Wando", "완도"),
            Map.entry("Jangseong", "장성"),
            Map.entry("Hampyeong", "함평"),
            Map.entry("Haenam", "해남"),
            Map.entry("Gochang", "고창"),
            Map.entry("Gunsan", "군산"),
            Map.entry("Gimje", "김제"),
            Map.entry("Namwon", "남원"),
            Map.entry("Muju", "무주"),
            Map.entry("Buan", "부안"),
            Map.entry("Sunchang", "순창"),
            Map.entry("Wanju", "완주"),
            Map.entry("Iksan", "익산"),
            Map.entry("Jangsu", "장수"),
            Map.entry("Jeonju", "전주"),
            Map.entry("Jinan", "진안"),
            Map.entry("Gongju", "공주"),
            Map.entry("Nonsan", "논산"),
            Map.entry("Buyeo", "부여"),
            Map.entry("Seosan", "서산"),
            Map.entry("Asan", "아산"),
            Map.entry("Yesan", "예산"),
            Map.entry("Cheonan", "천안"),
            Map.entry("Taean", "태안"),
            Map.entry("Hongseong", "홍성"),
            Map.entry("Danyang", "단양"),
            Map.entry("Yeongdong", "영동"),
            Map.entry("Okcheon", "옥천"),
            Map.entry("Jecheon", "제천"),
            Map.entry("Cheongju", "청주"),
            Map.entry("Chungju", "충주"),
            Map.entry("Jeju", "제주")
    );

    @Value("${weather.key}")
    private String weatherKey;

    @Value("${travel.key}")
    private String travelKey;

    /**
     * 맑음 지역 필터링
     * @return
     * @throws JSONException
     */
    @GetMapping("/weather/clear")
    public Response clearWeather () throws JSONException {
        List<String> clearLocationList = new ArrayList<>();
        List<ClearLocationInfoDTO> clearLocationInfoDTOList = new ArrayList<>();
        String url = "https://api.openweathermap.org/data/2.5/weather";

        try {
            Iterator<String> iterator = locationList.keySet().iterator();
            while (iterator.hasNext()) {
                String location = iterator.next();
                StringBuilder urlStringBuilder = new StringBuilder(url);

                urlStringBuilder.append("?" + URLEncoder.encode("q", "UTF-8") + "=" + URLEncoder.encode(location, "UTF-8"));
                urlStringBuilder.append("&" + URLEncoder.encode("appid", "UTF-8") + "=" + weatherKey);
                urlStringBuilder.append("&" + URLEncoder.encode("units", "UTF-8") + "=" + URLEncoder.encode("metric", "UTF-8"));

                URL url1 = new URL(urlStringBuilder.toString());

                HttpURLConnection urlConnection = (HttpURLConnection) url1.openConnection();
                urlConnection.setRequestMethod("GET");

                BufferedReader br;

                if (urlConnection.getResponseCode() >= 200 && urlConnection.getResponseCode() <= 300) {
                    br = new BufferedReader(new InputStreamReader(urlConnection.getInputStream(), StandardCharsets.UTF_8));
                } else {
                    br = new BufferedReader(new InputStreamReader(urlConnection.getErrorStream(), StandardCharsets.UTF_8));
                }

                // 날씨 api 반환 결과
                StringBuilder result = new StringBuilder();
                String returnLine;
                while ((returnLine = br.readLine()) != null) {
                    result.append(returnLine);
                }

                br.close();
                urlConnection.disconnect();

                // json 결과 파싱
                JSONObject jsonObj = new JSONObject(result.toString());
                JSONObject coordObj = jsonObj.getJSONObject("coord");

                BigDecimal mapX = coordObj.getBigDecimal("lon");
                BigDecimal mapY = coordObj.getBigDecimal("lat");
                PosDTO posDTO = new PosDTO();
                posDTO.setX(mapX.toString());
                posDTO.setY(mapY.toString());

                JSONArray weatherArray = jsonObj.getJSONArray("weather");

                JSONObject tempArray = jsonObj.getJSONObject("main");

                for (int i = 0; i < weatherArray.length(); i++) {
                    JSONObject weatherObj = weatherArray.getJSONObject(i);
                    String weather = weatherObj.getString("main");

                    //Clear 지역 필터링
                    if (weather.equals("Clear")) {
                        ClearLocationInfoDTO clearDTO = new ClearLocationInfoDTO();

                        BigDecimal temp = tempArray.getBigDecimal("temp");
                        String clearLocation = locationList.get(location);
                        clearLocationList.add(clearLocation);

                        clearDTO.setTemp(temp.toString());
                        clearDTO.setLocation(clearLocation);
                        clearDTO.setPosition(posDTO);
                        clearLocationInfoDTOList.add(clearDTO);
                    }
                }
                result.delete(0, result.length());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new Response(clearLocationInfoDTOList);
    }

    /**
     *
     * @param mapX
     * @param mapY
     * @return
     */
    @GetMapping("/recommend")
    public Response recommendTravel(@RequestParam String mapX, @RequestParam String mapY) {
        String resultTravel = "";
        String apiUrl = "http://apis.data.go.kr/B551011/KorService/locationBasedList";
        List<TravelInfoDTO> travelDTOList = new ArrayList<>();

        StringBuilder urlBuilder = new StringBuilder(apiUrl);
        try {

            urlBuilder.append("?" + URLEncoder.encode("serviceKey", "UTF-8") + "=" + travelKey);
            urlBuilder.append("&" + URLEncoder.encode("numOfRows", "UTF-8") + "=" + URLEncoder.encode("30", "UTF-8"));
            urlBuilder.append("&" + URLEncoder.encode("pageNo", "UTF-8") + "=" + URLEncoder.encode("1", "UTF-8"));
            urlBuilder.append("&" + URLEncoder.encode("MobileOS", "UTF-8") + "=" + URLEncoder.encode("ETC", "UTF-8"));
            urlBuilder.append("&" + URLEncoder.encode("MobileApp", "UTF-8") + "=" + URLEncoder.encode("5IYO", "UTF-8"));
            urlBuilder.append("&" + URLEncoder.encode("mapX", "UTF-8") + "=" + URLEncoder.encode(mapX, "UTF-8"));
            urlBuilder.append("&" + URLEncoder.encode("mapY", "UTF-8") + "=" + URLEncoder.encode(mapY, "UTF-8"));
            urlBuilder.append("&" + URLEncoder.encode("_type", "UTF-8") + "=" + URLEncoder.encode("json", "UTF-8"));
            urlBuilder.append("&" + URLEncoder.encode("arrange", "UTF-8") + "=" + URLEncoder.encode("E", "UTF-8"));
            urlBuilder.append("&" + URLEncoder.encode("radius", "UTF-8") + "=" + URLEncoder.encode("50000", "UTF-8"));

            URL url2 = new URL(urlBuilder.toString());

            HttpURLConnection conn = (HttpURLConnection) url2.openConnection();
            conn.setRequestMethod("GET");

            BufferedReader rd;
            if (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
                rd = new BufferedReader(new InputStreamReader(conn.getInputStream(),StandardCharsets.UTF_8));
            } else {
                rd = new BufferedReader(new InputStreamReader(conn.getErrorStream(), StandardCharsets.UTF_8));
            }

            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = rd.readLine()) != null) {
                sb.append(line);
            }
            rd.close();
            conn.disconnect();

            resultTravel = sb.toString();

            // json
            JSONObject jsonObj = new JSONObject(resultTravel);
            JSONObject response = jsonObj.getJSONObject("response");

            JSONObject header = response.getJSONObject("header");
            JSONObject body = response.getJSONObject("body");

            JSONObject items = body.getJSONObject("items");

            JSONArray itemsJSONArray = items.getJSONArray("item");

            for (int j = 0; j < itemsJSONArray.length(); j++) {
                JSONObject itemObj = itemsJSONArray.getJSONObject(j);

                TravelInfoDTO infoDTO = new TravelInfoDTO();
                String title = itemObj.getString("title");
                String travelX = itemObj.getString("mapx");
                String travelY = itemObj.getString("mapy");

                infoDTO.setTitle(title);
                infoDTO.setX(travelX);
                infoDTO.setY(travelY);

                travelDTOList.add(infoDTO);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return new Response(travelDTOList);
    }

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    static class TravelInfoDTO {
        private String title;
        private String x;
        private String y;
    }

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    static class PosDTO {
        private String x;
        private String y;
    }


    @Data
    @AllArgsConstructor
    static class RecommendTravelDTO {
        private String title;
    }

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    static class ClearLocationInfoDTO {
        private String temp;
        private String location;
        private PosDTO position;
    }

    @Data
    @AllArgsConstructor
    static  class ClearDTO<T> {
        private ClearLocationInfoDTO locationInfo;
        private T title;
    }

    @Data
    @AllArgsConstructor
    static class Result<T> {
        private T result;
    }

    @Data
    @AllArgsConstructor
    static class Response<T> {
        private T response;
    }
}
