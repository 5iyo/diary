import 'package:flutter/cupertino.dart';
import 'package:my_diary_front/controller/diary_repository.dart';

class DiaryImageDeleteProvider extends ChangeNotifier {

  bool loading = false;
  bool isDelete = false;

  DiaryRepository _diaryRepository = DiaryRepository();

  diaryImageDelete(int id) async {
    loading = true;
    notifyListeners();
    int response = (await _diaryRepository.fetchDeleteImage(id))!;
    if (response == 200) {
      isDelete == true;
    }
    loading = false;
    notifyListeners();
  }
}