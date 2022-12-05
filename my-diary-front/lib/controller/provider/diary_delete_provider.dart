import 'package:flutter/cupertino.dart';
import 'package:my_diary_front/controller/diary_repository.dart';

class DiaryDeleteProvider extends ChangeNotifier {

  bool loading = false;
  bool isDelete = false;

  DiaryRepository _diaryRepository = DiaryRepository();

  diaryDelete(int id) async {
    loading = true;
    notifyListeners();
    int response = (await _diaryRepository.fetchDelete(id))!;
    if (response == 200) {
      isDelete == true;
    }
    loading = false;
    notifyListeners();
  }
}