import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_diary_front/controller/dto/RecommendResp.dart';
import 'package:http/http.dart' as http;
import 'package:my_diary_front/view/components/ui_view_model.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math';

import '../../../data.dart';

String? host = dotenv.env['SERVER_URI'];
String? get_host = dotenv.env['SERVER_NAME'];

Future<RecommendResp> fetchRecommend(String y, String x) async {
  Map<String, String> queryParams = {
    "mapY": y,
    "mapX": x,
  };
  final response = await http.get(
    Uri.http('$get_host', '/recommend', queryParams),
  );
  if (response.statusCode == 200) {
    print("추천 리스트 요청 성공");
    print(json.decode(utf8.decode(response.bodyBytes)));
    return RecommendResp.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  } else if (response.statusCode == 500) {
    throw Exception("추천 리스트가 없음");
  } else {
    throw Exception("추천 리스트 요청을 실패했습니다.");
  }
}

class RecommendPage extends StatefulWidget {
  final String location;
  final String y;
  final String x;

  const RecommendPage(this.location, this.y, this.x);

  @override
  State<RecommendPage> createState() => _RecommendPageState(location, y, x);
}

class _RecommendPageState extends State<RecommendPage> {
  final String location;
  final String y;
  final String x;

  _RecommendPageState(this.location, this.y, this.x);

  Future<RecommendResp>? recommend;

  void initState() {
    super.initState();
    recommend = fetchRecommend(y, x);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          title: Text(
            '${location} 추천 여행지 🤸',
            style: GoogleFonts.lato(
                fontSize: 23,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700]),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          padding: EdgeInsets.all(15.0),
          child: FutureBuilder<RecommendResp>(
            future: recommend,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return buildRecommend(snapshot);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}에러");
              }
              return Expanded(child: UiViewModel.buildProgressBar());
            },
          ),
        ));
  }

  Widget buildRecommend(snapshot) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          SizedBox(
            height: 25.0,
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.all(0.0),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data.recommendresp.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      print(
                          "${snapshot.data.recommendresp[index].y}, ${snapshot.data.recommendresp[index].x}");
                      Navigator.pop(
                          context,
                          TravelMarker(
                              travelTitle:
                                  snapshot.data.recommendresp[index].title,
                              travelArea: '',
                              travelLatLng: LatLng(
                                  double.parse(
                                      snapshot.data.recommendresp[index].y),
                                  double.parse(
                                      snapshot.data.recommendresp[index].x)),
                              travelImage: ''));
                    },
                    child: Container(
                      height: 90,
                      margin: EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.transparent,
                      ),
                      child: Stack(children: [
                        Positioned(
                          top: 3,
                          left: 10,
                          child: index < 9
                              ? Text('0${index + 1}',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 40,
                                      color: Colors.grey[600]))
                              : Text('${index + 1}',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 40,
                                      color: Colors.grey[600])),
                        ),
                        Positioned(
                          bottom: 3,
                          right: 10,
                          child: Text(
                              '${snapshot.data.recommendresp[index].title}',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                        )
                      ]),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
