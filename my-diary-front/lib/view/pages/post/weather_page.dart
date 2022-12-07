import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_diary_front/controller/dto/WeatherResp.dart';
import 'package:my_diary_front/data.dart';
import 'package:my_diary_front/view/pages/post/recommend_page.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../components/ui_view_model.dart';

String? host = dotenv.env['SERVER_URI'];
String? get_host = dotenv.env['SERVER_NAME'];

Future<WeatherResp> fetchWeather() async {
  var url = '$host/weather/clear';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    print("날씨 리스트 요청 성공");
    print(json.decode(utf8.decode(response.bodyBytes)));
    return WeatherResp.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  } else if (response.statusCode == 500) {
    throw Exception("날씨 리스트가 없습니다.");
  } else {
    throw Exception("날씨 리스트 요청을 실패했습니다.");
  }
}

class WeatherPage extends StatefulWidget {
  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  var date = DateTime.now();

  String getSystemTime() {
    var now = DateTime.now();
    return DateFormat("h:mm:a").format(now);
  }

  Future<WeatherResp>? weather;

  bool isAwait = false;

  @override
  void initState() {
    super.initState();
    weather = fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          title: Text(
            '오늘의 추천 지역 😃',
            style: GoogleFonts.lato(
                fontSize: 23,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700]),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        extendBodyBehindAppBar: true,
        body: Stack(children: [
          Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),FutureBuilder<WeatherResp>(
                      future: weather,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Expanded(child: buildWeather(snapshot));
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}에러");
                        }
                        return Expanded(child: UiViewModel.buildProgressBar());
                      },
                    ),
                ],
              )),
          isAwait ? UiViewModel.buildProgressBar() : Container(),
        ]));
  }

  Widget buildWeather(snapshot) {
    return ListView.builder(
        padding: const EdgeInsets.all(0.0),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: snapshot.data.weatherresp.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RecommendPage(
                              snapshot.data.weatherresp[index].location,
                              snapshot.data.weatherresp[index].position.y,
                              snapshot.data.weatherresp[index].position.x)))
                  .then((value) {
                if (value.runtimeType == TravelMarker) {
                  print("pop weather_page");
                  Navigator.pop(context, value);
                }
              });
            },
            title: Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(colors: [
                  Color(0xff7AEBF2),
                  Color(0xff9887FE),
                ]),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${snapshot.data.weatherresp[index].location}",
                          style: GoogleFonts.lato(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Row(
                        children: [
                          TimerBuilder.periodic(
                            (Duration(minutes: 1)),
                            builder: (context) {
                              print('${getSystemTime()}');
                              return Text(
                                getSystemTime(),
                                style: GoogleFonts.lato(
                                    fontSize: 13.0, color: Colors.white),
                              );
                            },
                          ),
                          Text(
                            DateFormat(' - EEEE').format(date),
                            style: GoogleFonts.lato(
                                fontSize: 13.0, color: Colors.white),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(width: 15),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        height: 60,
                        width: 60,
                        color: Colors.transparent,
                        child: SvgPicture.asset(
                          'svg/sun.svg',
                          color: Colors.white,
                        ),
                      ),
                      Text(
                          "${double.parse(snapshot.data.weatherresp[index].temp).round()}\u2103",
                          style: GoogleFonts.lato(
                              fontSize: 40.0,
                              fontWeight: FontWeight.w300,
                              color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
