import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:my_diary_front/controller/provider/travel_delete_provider.dart';
import 'package:my_diary_front/controller/provider/travellist_provider.dart';
import 'package:my_diary_front/data.dart';
import 'package:my_diary_front/view/components/ui_view_model.dart';
import 'package:my_diary_front/view/pages/post/diary_list_page.dart';
import 'dart:async';
import 'package:my_diary_front/view/pages/post/travel_update_page.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../../diaryShare.dart';

class Menu {
  final String name;

  const Menu(this.name);
}

class TravelListPage extends StatefulWidget {
  final LatLng travelLatLng;
  final int id;

  // 좌표 받아야함
  const TravelListPage({
    super.key,
    required this.travelLatLng,
    required this.id,
  });

  @override
  State<TravelListPage> createState() =>
      _TravelListPage(travelLatLng: travelLatLng, id: id);
}

class _TravelListPage extends State<TravelListPage> {
  LatLng travelLatLng;
  int id;
  List<String> travelImageList = [];
  ScrollController controller = ScrollController();

  _TravelListPage({
    required this.travelLatLng,
    required this.id,
  });

  TravelListProvider _travelListProvider = TravelListProvider();
  TravelDeleteProvider _travelDeleteProvider = TravelDeleteProvider();

  late MainViewModel _mainViewModel;
  DiaryScreenshot diaryScreenshot = DiaryScreenshot();

  bool isAwait = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _travelListProvider =
        Provider.of<TravelListProvider>(context, listen: false);
    setState(() {
      isAwait = true;
    });
    await _travelListProvider.travelList(travelLatLng, id);
    setState(() {
      isAwait = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _travelDeleteProvider =
        Provider.of<TravelDeleteProvider>(context, listen: true);
    _mainViewModel = Provider.of<MainViewModel>(context, listen: true);

    UriData? data;
    Uint8List? bytes;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Text("Travel List", style: TextStyle(color: Colors.grey[700])),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          DiarySocialShareViewModel().buildPopupMenu(context,
                  (DiarySocialShare item) async {
                setState(() {
                  isAwait = true;
                });
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
                setState(() {
                  isAwait = false;
                });
              }, Colors.black),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(children: [
        Consumer<TravelListProvider>(
            builder: (context, TravelListProvider value, child) {
              travelImageList.clear();
              for (int i = 0; i < value.travels.length; i++) {
                travelImageList.add("${value.travels[i].image}");
              }

              int count = 0;
              bool imagenull = false;

              for (int i = 0; i < travelImageList.length; i++) {
                if (travelImageList[i] == "") {
                  count++;
                }
              }
              if (count == travelImageList.length) {
                imagenull = true;
              }

              if (value.travels != null && value.travels.length > 0) {
                return Screenshot(
                  controller: diaryScreenshot.screenshotController,
                  child: UiViewModel.buildBackgroundContainer(
                      context: context,
                      backgroundType: BackgroundType.write,
                      child: UiViewModel.buildSizedLayout(
                        context,
                        Center(
                          child: Column(
                            children: [
                              imagenull == true
                                  ? Container()
                                  : Container(
                                width: UiViewModel.getSizedLayoutSize(context)
                                    .width *
                                    0.9,
                                height: 300.0,
                                child: ListView.builder(
                                    padding: EdgeInsets.all(10.0),
                                    scrollDirection: Axis.horizontal,
                                    controller: this.controller,
                                    itemCount: travelImageList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      travelImageList[index] == "" ||
                                          travelImageList[index] == null
                                          ? data = null
                                          : data = Uri.parse(
                                          travelImageList[index])
                                          .data;
                                      data == null
                                          ? bytes = null
                                          : bytes = data!.contentAsBytes();
                                      if (bytes != null) {
                                        return Container(
                                          width:
                                          UiViewModel.getSizedLayoutSize(
                                              context)
                                              .width *
                                              0.45 -
                                              5,
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    20.0)),
                                            clipBehavior: Clip.antiAlias,
                                            borderOnForeground: false,
                                            child: Image.memory(bytes!,
                                                fit: BoxFit.cover),
                                          ),
                                          padding: EdgeInsets.all(10.0),
                                        );
                                      } else {
                                        return SizedBox();
                                      }
                                    }),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: ColumnBuilder(
                                    itemCount: value.travels.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        onTap: () {
                                          Get.to(() => DiaryListPage(
                                              value.travels[index].id));
                                        },
                                        title: Text("${value.travels[index].title}"),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                                DateFormat('yyyy-MM-dd').format(
                                                    value.travels[index].startdate),
                                                style: TextStyle(fontSize: 10)),
                                            Text("  -  ",
                                                style: TextStyle(fontSize: 10)),
                                            Text(
                                                DateFormat('yyyy-MM-dd').format(
                                                    value.travels[index].enddate),
                                                style: TextStyle(fontSize: 10)),
                                            PopupMenuButton(
                                              itemBuilder: (context) => [
                                                PopupMenuItem(
                                                  value: 1,
                                                  child: Text('수정'),
                                                  onTap: () async {
                                                    final navigator =
                                                    Navigator.of(context);
                                                    setState(() {
                                                      isAwait = true;
                                                    });
                                                    await Future.delayed(Duration.zero);
                                                    setState(() {
                                                      isAwait = false;
                                                    });
                                                    navigator.push(
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              TravelUpdatePage(
                                                                  travelLatLng,
                                                                  value.travels[index]
                                                                      .id,
                                                                  value.travels[index]
                                                                      .title,
                                                                  value.travels[index]
                                                                      .image)),
                                                    );
                                                  },
                                                ),
                                                PopupMenuItem(
                                                  child: Text('삭제'),
                                                  onTap: () async {
                                                    setState(() {
                                                      isAwait = true;
                                                    });
                                                    await _travelDeleteProvider
                                                        .travelDelete(
                                                        value.travels[index].id!);
                                                    setState(() {
                                                      isAwait = false;
                                                    });
                                                    Get.off(() => TravelListPage(
                                                      travelLatLng: travelLatLng, id: id,
                                                    ));
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                );
              }
              return Center(child: Text("여행을 추가해주세요."));
            }),
        isAwait ? UiViewModel.buildProgressBar() : Container(),
      ]),
    );
  }
}