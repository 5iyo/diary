
import 'package:flutter/cupertino.dart';
import 'package:my_diary_front/controller/diary_repository.dart';

class DiaryImageInputProvider extends ChangeNotifier {

  bool loading = false;
  bool isBack = false;

  DiaryRepository _diaryRepository = DiaryRepository();

  imageInput(int id, String image) async {
    loading = true;
    notifyListeners();
    int response = (await _diaryRepository.dioInputImage(id, image))!;
    if (response == 200) {
      isBack == true;
    }
    loading = false;
    notifyListeners();
  }
}