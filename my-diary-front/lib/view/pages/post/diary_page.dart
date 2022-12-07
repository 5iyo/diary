import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:my_diary_front/controller/provider/diary_delete_provider.dart';
import 'package:my_diary_front/controller/provider/diarylist_provider.dart';
import 'package:my_diary_front/data.dart';
import 'package:my_diary_front/view/components/ui_view_model.dart';
import 'package:my_diary_front/view/pages/post/update_page.dart';
import 'package:my_diary_front/view/pages/post/diary_list_page.dart';
import 'package:my_diary_front/controller/dto/DiaryResp.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../../controller/provider/diary_provider.dart';
import '../../../diaryShare.dart';

class DiaryPage extends StatefulWidget {
  final int? id;
  final int travelId;

  const DiaryPage(this.id, this.travelId);

  @override
  State<DiaryPage> createState() => _DiaryPage(id!, travelId);
}

class _DiaryPage extends State<DiaryPage> {
  DiaryProvider diaryProvider = DiaryProvider();
  DiaryDeleteProvider diaryDeleteProvider = DiaryDeleteProvider();

  final int id;
  final int travelId;

  _DiaryPage(this.id, this.travelId);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    diaryProvider = Provider.of<DiaryProvider>(context, listen: false);
    diaryProvider.getdiary(id);
  }

  ScrollController controller = ScrollController();

  late MainViewModel _mainViewModel;

  DiaryScreenshot diaryScreenshot = DiaryScreenshot();

  @override
  Widget build(BuildContext context) {
    _mainViewModel = Provider.of<MainViewModel>(context, listen: true);
    diaryDeleteProvider = Provider.of<DiaryDeleteProvider>(context, listen: true);

    UriData data;
    Uint8List bytes;

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Text("Diary", style: TextStyle(color: Colors.grey[700])),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          DiarySocialShareViewModel().buildPopupMenu(context,
              (DiarySocialShare item) async {
            await _mainViewModel
                .share(
                  item,
                  diaryScreenshot,
                )
                .then((value) => value
                    ? ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${item.name} 공유 완료")))
                    : ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${item.name} 공유 실패"))));
          }, Colors.black),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Consumer<DiaryProvider>(
        builder: (context, DiaryProvider value, child) {
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Screenshot(
              controller: diaryScreenshot.screenshotController,
              child: UiViewModel.buildBackgroundContainer(
                  context: context,
                  backgroundType: BackgroundType.write,
                  child: UiViewModel.buildSizedLayout(
                      context, SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  (value.diary.title == null ? "" :value.diary.title!),
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                                ),
                                Divider(),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          DateFormat.yMMMd('en_US').format(
                                              value.diary.traveldate == null ? DateTime.now()
                                                  : value.diary.traveldate!
                                          )
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                          (value.diary.weather == null ? "" :value.diary.weather!)
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                          (value.diary.travel == null ? "" :value.diary.travel!)
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(),
                                SingleChildScrollView(
                                  child: Text("${value.diary.content}"),
                                ),
                                value.diary.images == null ? Container() :
                                value.diary.images![0].imagefile == "" && value.diary.images!.length == 1
                                    ? Container()
                                    : SizedBox(
                                  width: UiViewModel.getSizedLayoutSize(context).width * 0.7,
                                  child: ColumnBuilder(
                                    itemCount: value.diary.images!.length ?? 0,
                                    itemBuilder: (context, index) {
                                      if (value.diary.images![index].imagefile == "" ) {
                                        return Container();
                                      } else {
                                        data = Uri.parse("${value.diary.images![index].imagefile}").data!;
                                        bytes = data.contentAsBytes();
                                        return Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16.0)),
                                          clipBehavior: Clip.antiAlias,
                                          borderOnForeground: false,
                                          child: Image.memory(bytes, fit: BoxFit.fitWidth),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          DateFormat.yMd().add_jm().format(
                                              value.diary.created == null ? DateTime.now()
                                                  : value.diary.created!
                                          ), style: TextStyle(fontSize: 11),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                          DateFormat.yMd().add_jm().format(
                                              value.diary.updated == null ? DateTime.now()
                                                  : value.diary.updated!
                                          ), style: TextStyle(fontSize: 11),
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
                                        await Get.off(() => UpdatePage(id, travelId));
                                      },
                                      child: Text("수정"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        ),
                    ),
                  ),
                )
            );
          }
      )
    );
  }
}
