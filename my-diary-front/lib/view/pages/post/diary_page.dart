import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_diary_front/controller/provider/diary_delete_provider.dart';
import 'package:my_diary_front/controller/provider/diarylist_provider.dart';
import 'package:my_diary_front/view/pages/post/update_page.dart';
import 'package:my_diary_front/view/pages/post/diary_list_page.dart';
import 'package:my_diary_front/controller/dto/DiaryResp.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:provider/provider.dart';

const host = "http://192.168.20.2:8080";

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

class DiaryPage extends StatefulWidget {

  final int? id;
  final int travelId;

  const DiaryPage(this.id, this.travelId);

  @override
  State<DiaryPage> createState() => _DiaryPage(id!, travelId);
}

class _DiaryPage extends State<DiaryPage> {
  DiaryListProvider diaryListProvider = DiaryListProvider();
  DiaryDeleteProvider diaryDeleteProvider = DiaryDeleteProvider();

  final int id;
  final int travelId;

  _DiaryPage(this.id, this.travelId);

  Future<Diary>? diary;
  ScrollController controller = ScrollController();

  void initState() {
    super.initState();
    diary = fetchDiary(id);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Text("Diary",
            style: TextStyle(color: Colors.grey[700])),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      body: Padding(
        padding:EdgeInsets.all(16.0),
        child: FutureBuilder<Diary>(
          future: diary,
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              return buildDiary(context, snapshot);
            } else if(snapshot.hasError) {
              return Text("${snapshot.error}에러");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Widget buildDiary(context, snapshot) {
    diaryListProvider = Provider.of<DiaryListProvider>(context, listen: false);
    diaryDeleteProvider = Provider.of<DiaryDeleteProvider>(context, listen: true);

    UriData data;
    Uint8List bytes;
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Column(
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

          snapshot.data!.images[0].imagefile == "" && snapshot.data!.images.length == 1
              ? Container() : Expanded(
              child: SingleChildScrollView(
                child: ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  controller: this.controller,
                  itemCount: snapshot.data?.images.length ?? 0,
                  itemBuilder: (context, index) {
                    if(snapshot.data.images[index].imagefile == "" ) return Container();
                    else {
                      data = Uri.parse(snapshot.data.images[index].imagefile).data!;
                      bytes = data.contentAsBytes();
                      return Container(
                          width: 200.0,
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                            clipBehavior: Clip.antiAlias,
                            borderOnForeground: false,
                            child: Image.memory(bytes, fit: BoxFit.cover),
                          )
                      );
                    }
                  },
                ),
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
                onPressed: () async {
                  await diaryDeleteProvider.diaryDelete(id);
                  Get.off(() => DiaryListPage(travelId));
                },
                child: Text("삭제"),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () async {
                  await Get.off(()=>UpdatePage(id, travelId));
                },
                child: Text("수정"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
