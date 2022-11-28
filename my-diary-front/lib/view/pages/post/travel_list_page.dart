import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_diary_front/controller/dto/TravelListResp.dart';
import 'package:my_diary_front/view/pages/post/diary_list_page.dart';
import 'package:my_diary_front/view/pages/post/travel_page.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:my_diary_front/view/pages/post/travel_update_page.dart';

const get_host = "192.168.20.7:8080";
const host = "http://192.168.20.7:8080";

Future<TravelList> fetchTravelList() async {
  //var url = "$host/api/travels";
  Map<String, String> queryParams = {
    "travelLatitude": "35.8561",
    "travelLongitude": "129.224"
  };
  final response = await http.get(
    Uri.http('$get_host', 'api/travels', queryParams),
  );
  if(response.statusCode == 200) {
    print("여행 리스트 요청 성공");
    print(json.decode(utf8.decode(response.bodyBytes)));
    return TravelList.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  } else if(response.statusCode == 500) {
    throw Exception("여행을 추가해주세요!");
  }
  else{
    throw Exception("여행 리스트 요청을 실패했습니다.");
  }
}

Future<void> fetchTravelDelete(int id) async{
  var url = '$host/api/travels/$id';
  final response = await http.delete(Uri.parse(url));

  if(response.statusCode == 200) {
    print("삭제 성공");
  } else {
    throw Exception("삭제 실패");
  }
}

class Menu {
  final String name;
  const Menu(this.name);
}

class TravelListPage extends StatefulWidget {

  @override
  State<TravelListPage> createState() => _TravelListPage();
}

class _TravelListPage extends State<TravelListPage> {

  Future<TravelList>? travellist;
  List<String> travelImageList = [];
  ScrollController controller = ScrollController();

  void initState() {
    super.initState();
    travellist = fetchTravelList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Text("Travel List",
            style: TextStyle(color: Colors.grey[700])),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: EdgeInsets.only(top: 10),
        child: Center(
          child: FutureBuilder<TravelList>(
            future: travellist,
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                return buildList(snapshot);
              } else if(snapshot.hasError) {
                return Text("${snapshot.error}에러");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String member = "member";
          Get.to(()=>TravelPage(member));
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget buildList(snapshot) {

    UriData? data;
    Uint8List? bytes;

    for(int i=0; i<snapshot.data.travels.length; i++) {
      travelImageList.add(snapshot.data.travels[i].image);
    }

    int count = 0;
    bool imagenull = false;

    for(int i=0; i<travelImageList.length; i++) {
      if(travelImageList[i] == "") {
        count ++;
      }
    }
    if(count == travelImageList.length) {
      imagenull = true;
    }

    return Column(
      children: [
        imagenull == true ? Container()
            : SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(5.0),
              child: Column(
                children: <Widget>[
                  Stack(
                      children : <Widget>[
                        Container(
                            width: MediaQuery.of(context).size.width,
                            height: 200.0,
                            child: ListView.builder(
                                padding: EdgeInsets.all(10.0),
                                scrollDirection: Axis.horizontal,
                                controller: this.controller,
                                itemCount: travelImageList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  travelImageList[index] == "" ? data = null : data = Uri.parse(travelImageList[index]).data!;
                                  data == null ? bytes = null : bytes = data!.contentAsBytes();
                                  return Stack(
                                      children: <Widget>[
                                        GestureDetector(
                                          child: Container(
                                            width: 200.0,
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(20.0)),
                                              clipBehavior: Clip.antiAlias,
                                              borderOnForeground: false,
                                              child: bytes == null? null : Image.memory(bytes!, fit: BoxFit.cover),
                                            ),
                                            padding: EdgeInsets.all(10.0),
                                          ),
                                        ),
                                      ]
                                  );
                                }
                            )
                        ),
                      ]
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child : ListView.separated(
            itemCount: snapshot.data.travels.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: (){
                  Get.to(()=>DiaryListPage(snapshot.data!.travels[index].id));
                },
                title: Row(
                  children: [
                    Text(snapshot.data!.travels[index].title),
                    SizedBox(width: 20),
                    Text(DateFormat.yMd().format(snapshot.data!.travels[index].startdate),
                        style: TextStyle(fontSize: 10)),
                    Text("  -  ", style: TextStyle(fontSize: 10)),
                    Text(DateFormat.yMd().format(snapshot.data!.travels[index].enddate),
                        style: TextStyle(fontSize: 10)),
                  ],
                ),
                trailing: PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value : 1,
                      child: Text('수정'),
                      onTap : () async {
                        final navigator = Navigator.of(context);
                        await Future.delayed(Duration.zero);
                        navigator.push(
                          MaterialPageRoute(builder : (_) => TravelUpdatePage(
                              snapshot.data!.travels[index].id,
                              snapshot.data!.travels[index].title,
                              snapshot.data!.travels[index].image)),
                        );
                      },
                    ),
                    PopupMenuItem(
                      child: Text('삭제'),
                      onTap: () {
                        fetchTravelDelete(snapshot.data!.travels[index].id);
                        Get.off(() => TravelListPage());
                      },
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          ),
        )
      ],
    );
  }
}