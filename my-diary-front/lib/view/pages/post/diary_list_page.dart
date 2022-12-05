import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_diary_front/controller/provider/diarylist_provider.dart';
import 'package:my_diary_front/view/pages/post/diary_page.dart';
import 'package:my_diary_front/view/pages/post/write_page.dart';

import 'package:provider/provider.dart';

class DiaryListPage extends StatefulWidget {

  final int? id;
  const DiaryListPage(this.id);

  @override
  State<DiaryListPage> createState() => _DiaryListPage(id!);
}

class _DiaryListPage extends State<DiaryListPage> {
  DiaryListProvider _diaryListProvider = DiaryListProvider();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _diaryListProvider = Provider.of<DiaryListProvider>(context, listen: false);
    _diaryListProvider.diaryList(id);
  }

  var refreshKey = GlobalKey<RefreshIndicatorState>();
  final int id;
  _DiaryListPage(this.id);

  @override
  void initState() {
    super.initState();
  }

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
      body: Consumer<DiaryListProvider>(
        builder: (context, DiaryListProvider value, child) {
          if(value.diaries != null && value.diaries.length>0) {
            return Padding(
                padding: EdgeInsets.only(top: 10),
                child: Center(
                  child: ListView.separated(
                    itemCount: value.diaries.length ?? 0,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: (){
                          Get.to(()=>DiaryPage(value.diaries[index].id, id));
                        },
                        title: Text("${value.diaries[index].title}"),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                  ),
                )
            );
          }
          return Center(child: Text('일기를 추가해주세요'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.off(() => WritePage(id));
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}