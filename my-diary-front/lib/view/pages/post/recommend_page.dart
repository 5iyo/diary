import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_diary_front/controller/dto/RecommendResp.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:math';

const get_host = "192.168.20.2:8080";
const host = "http://192.168.20.2:8080";

Future<RecommendResp> fetchRecommend(String x, String y) async {
  Map<String, String> queryParams = {
    "mapX": x,
    "mapY": y
  };
  final response = await http.get(
    Uri.http('$get_host', '/recommend', queryParams),
  );
  if(response.statusCode == 200) {
    print("추천 리스트 요청 성공");
    print(json.decode(utf8.decode(response.bodyBytes)));
    return RecommendResp.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  } else if(response.statusCode == 500) {
    throw Exception("추천 리스트가 없음");
  }
  else{
    throw Exception("추천 리스트 요청을 실패했습니다.");
  }
}

class RecommendPage extends StatefulWidget {

  final String location;
  final String x;
  final String y;
  const RecommendPage(this.location, this.x, this.y);

  @override
  State<RecommendPage> createState() => _RecommendPageState(location, x, y);
}

class _RecommendPageState extends State<RecommendPage> {

  final String location;
  final String x;
  final String y;
  _RecommendPageState(this.location, this.x, this.y);

  Future<RecommendResp>? recommend;

  void initState() {
    super.initState();
    recommend = fetchRecommend(x, y);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          title: Text(" "),
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
              return CircularProgressIndicator();
            },
          ),
        )
    );
  }

  Widget buildRecommend(snapshot) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: Text('${location} 추천 여행지 🤸',
              style: GoogleFonts.lato(
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700]
              ),
            ),
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
                  return Container(
                    height: 90,
                    margin: EdgeInsets.only(bottom: 20),
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.transparent,
                    ),
                    child: Stack(
                        children: [
                          Positioned(
                            top : 3,
                            left: 10,
                            child: index < 9 ? Text('0${index+1}',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 40,
                                    color: Colors.grey[600]
                                )
                            ) : Text('${index+1}',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 40,
                                    color: Colors.grey[600]
                                )
                            ),
                          ),
                          Positioned(
                            bottom: 3,
                            right: 10,
                            child: Text('${snapshot.data.recommendresp[index].title}',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold
                                )
                            ),
                          )
                        ]
                    ),
                  );
                }
            ),
          )
        ],
      ),
    );
  }
}
