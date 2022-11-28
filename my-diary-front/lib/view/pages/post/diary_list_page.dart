import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_diary_front/controller/dto/DiaryListResp.dart';
import 'package:my_diary_front/view/pages/post/diary_page.dart';
import 'package:http/http.dart' as http;
import 'package:my_diary_front/view/pages/post/write_page.dart';
import 'dart:async';
import 'dart:convert';


const host = "http://192.168.20.7:8080";


Future<DiaryList> fetchDiaryList(int id) async {
  var url = '$host/api/diaries/$id/inquiry-diary-list';
  final response = await http.get(Uri.parse(url));

  if(response.statusCode == 200) {
    print("리스트 요청 성공");
    print(json.decode(utf8.decode(response.bodyBytes)));
    return DiaryList.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  } else if(response.statusCode == 500) {
    throw Exception("일기를 추가해주세요");
  }
  else{
    throw Exception("리스트 요청을 실패했습니다.");
  }
}

class DiaryListPage extends StatefulWidget {

  final int id;
  const DiaryListPage(this.id);

  @override
  State<DiaryListPage> createState() => _DiaryListPage(id);
}

class _DiaryListPage extends State<DiaryListPage> {

  final int id;
  _DiaryListPage(this.id);

  Future<DiaryList>? diarylist;

  void initState() {
    super.initState();
    diarylist = fetchDiaryList(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Text("Diary List",
            style: TextStyle(color: Colors.grey[700])),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: EdgeInsets.only(top: 10),
        child: Center(
          child: FutureBuilder<DiaryList>(
            future: diarylist,
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                return buildList(snapshot);
              } else if(snapshot.hasError) {
                return Text("${snapshot.error}error");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(()=>WritePage(id));
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget buildList(snapshot) {
    return ListView.separated(
      itemCount: snapshot.data?.data.length ?? 0,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: (){
            Get.to(()=>DiaryPage(snapshot.data!.data[index].id, id));
          },
          title: Text(snapshot.data!.data[index].title),
        );
      },
      separatorBuilder: (context, indext) {
        return Divider();
      },
    );
  }
}