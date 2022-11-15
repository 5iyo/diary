import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_diary_front/controller/dto/DiaryListResp.dart';
import 'package:my_diary_front/controller/dto/DiaryResp.dart';
import 'package:my_diary_front/view/pages/post/diary_page.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const host = "http://192.168.20.3:8080";


Future<Diary> fetchDiaryList(int id) async {
  var url = '$host/api/diaries/$id';
  final response = await http.get(Uri.parse(url));

  if(response.statusCode == 200) {
    print("리스트 요청 성공");
    print(json.decode(utf8.decode(response.bodyBytes)));
    return Diary.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  } else {
    throw Exception("리스트 요청을 실패했습니다.");
  }
}


class DiaryListPage extends StatefulWidget {

  @override
  State<DiaryListPage> createState() => _DiaryListPage();
}

class _DiaryListPage extends State<DiaryListPage> {

  Future<Diary>? diarylist;

  void initState() {
    super.initState();
    diarylist = fetchDiaryList(6);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Diary List"),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Center(
        child: FutureBuilder<Diary>(
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
      //snapshot.data?.length ?? 0,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: (){
            Get.to(()=>DiaryPage());
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