import 'package:flutter/cupertino.dart';
import 'package:my_diary_front/controller/diary_repository.dart';

class DiaryWriteProvider extends ChangeNotifier {

  bool loading = false;
  bool isBack = false;

  DiaryRepository _diaryRepository = DiaryRepository();

  save(int id, String title, String date, String content, String weather,
      String travel, List<String> images) async {
    loading = true;
    notifyListeners();
    int response = (await _diaryRepository.dioWrite(id, title, date, content, weather, travel, images))!;
    if (response == 200) {
      isBack == true;
    }
    loading = false;
    notifyListeners();
  }
}