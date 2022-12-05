import 'package:flutter/cupertino.dart';
import 'package:my_diary_front/controller/diary_repository.dart';

class DiaryUpdateProvider extends ChangeNotifier {

  bool loading = false;
  bool isBack = false;

  DiaryRepository _diaryRepository = DiaryRepository();

  update(int id, String title, String date, String content, String weather,
      String travel) async {
    loading = true;
    notifyListeners();
    int response = (await _diaryRepository.dioUpdate(id, title, date, content, weather, travel))!;
    if (response == 200) {
      isBack == true;
    }
    loading = false;
    notifyListeners();
  }
}