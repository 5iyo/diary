import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_diary_front/controller/dto/DiaryListResp.dart';
import 'package:my_diary_front/view/pages/post/diary_list_page.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const host = "http://10.0.2.2:8080";


Future<DiaryList> fetchTravelList(int id) async {
  var url = '$host/api/diaries/$id/inquiry-diary-list';
  final response = await http.get(Uri.parse(url));

  if(response.statusCode == 200) {
    print("리스트 요청 성공");
    print(json.decode(utf8.decode(response.bodyBytes)));
    return DiaryList.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  } else {
    throw Exception("리스트 요청을 실패했습니다.");
  }
}


class TravelListPage extends StatefulWidget {

  @override
  State<TravelListPage> createState() => _TravelListPage();
}

class _TravelListPage extends State<TravelListPage> {

  Future<DiaryList>? diarylist;

  void initState() {
    super.initState();
    diarylist = fetchTravelList(5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Travel List"),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Center(
          child: FutureBuilder<DiaryList>(
            future: diarylist,
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                return buildList(snapshot);
              } else if(snapshot.hasError) {
                return Text("${snapshot.error}에러ㅠ");
              }
              return CircularProgressIndicator();
            },
          ),
        )
    );
  }

  Widget buildList(snapshot) {
    return ListView.separated(
      itemCount: 1,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: (){
            Get.to(()=>DiaryListPage());
          },
          title: Text(snapshot.data!.title),
        );
      },
      separatorBuilder: (context, indext) {
        return Divider();
      },
    );
  }
}