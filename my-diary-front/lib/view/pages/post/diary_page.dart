import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_diary_front/view/pages/post/update_page.dart';
import 'package:my_diary_front/view/pages/post/diary_list_page.dart';
import 'package:my_diary_front/controller/dto/DiaryResp.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const host = "http://192.168.20.3:8080";

Future<Diary> fetchDiary(int id) async {
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

Future<void> fetchDelete(int id) async{
  var url = '$host/api/diaries/$id';
  final response = await http.delete(Uri.parse(url));

  if(response.statusCode == 200) {
    print("삭제 성공");
  } else {
    throw Exception("삭제 실패");
  }
}

class DiaryPage extends StatefulWidget {

  @override
  State<DiaryPage> createState() => _DiaryPage();
}


class _DiaryPage extends State<DiaryPage> {

  Future<Diary>? diary;

  void initState() {
    super.initState();
    diary = fetchDiary(6);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("일기")
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Diary>(
          future: diary,
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              return buildDiary(snapshot);
            } else if(snapshot.hasError) {
              return Text("${snapshot.error}에러ㅠ");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Widget buildDiary(snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          (snapshot.data!.title),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  DateFormat.yMMMd('en_US').format(snapshot.data!.traveldate)
              ),
              SizedBox(width: 10),
              Text(
                  (snapshot.data!.weather)
              ),
              SizedBox(width: 10),
              Text(
                  (snapshot.data!.travel)
              ),
            ],
          ),
        ),
        Divider(),
        Expanded(
            child: SingleChildScrollView(
              child: Text(snapshot.data!.content),
            )
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  DateFormat.yMd().add_jm().format(snapshot.data!.created)
              ),
              SizedBox(width: 10),
              Text(
                  DateFormat.yMd().add_jm().format(snapshot.data!.updated)
              ),
            ],
          ),
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                //fetchDelete(snapshot.data!.id);
                Get.off(() => DiaryListPage());
              },
              child: Text("삭제"),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: (){
                Get.to(()=>UpdatePage());
              },
              child: Text("수정"),
            ),
          ],
        ),
      ],
    );
  }
}
