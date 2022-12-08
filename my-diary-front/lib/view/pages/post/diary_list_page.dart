import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_diary_front/controller/provider/diarylist_provider.dart';
import 'package:my_diary_front/view/components/ui_view_model.dart';
import 'package:my_diary_front/view/pages/post/diary_page.dart';
import 'package:my_diary_front/view/pages/post/write_page.dart';

import 'package:provider/provider.dart';

class DiaryListPage extends StatefulWidget {
  final int? id;

  const DiaryListPage(this.id, {super.key});

  @override
  State<DiaryListPage> createState() => _DiaryListPage(id!);
}

class _DiaryListPage extends State<DiaryListPage> {
  DiaryListProvider _diaryListProvider = DiaryListProvider();

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _diaryListProvider = Provider.of<DiaryListProvider>(context, listen: false);
    setState(() {
      isAwait = true;
    });
    await _diaryListProvider.diaryList(id);
    setState(() {
      isAwait = false;
    });
  }

  var refreshKey = GlobalKey<RefreshIndicatorState>();
  final int id;

  bool isAwait = false;

  _DiaryListPage(this.id);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Text("Diary List", style: TextStyle(color: Colors.grey[700])),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(children: [
        UiViewModel.buildBackgroundContainer(
            context: context,
            backgroundType: BackgroundType.write,
            child: UiViewModel.buildSizedLayout(context,
                Consumer<DiaryListProvider>(
              builder: (context, DiaryListProvider value, child) {
                if (value.diaries != null && value.diaries.length > 0) {
                  return Center(
                    child: SingleChildScrollView(
                      child: ColumnBuilder(
                        itemCount: value.diaries.length ?? 0,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              Get.to(
                                  () => DiaryPage(value.diaries[index].id, id));
                            },
                            title: Text("${value.diaries[index].title}"),
                          );
                        },
                      ),
                    ),
                  );
                }
                return Center(child: Text('일기를 추가해주세요'));
              },
            ))),
        isAwait ? UiViewModel.buildProgressBar() : Container(),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.off(() => WritePage(id));
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
