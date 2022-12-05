
import 'package:flutter/cupertino.dart';
import 'package:my_diary_front/controller/diary_repository.dart';

class TravelProvider extends ChangeNotifier {

  bool loading = false;
  bool isBack = false;

  DiaryRepository _diaryRepository = DiaryRepository();

  travelsave(String id, String title, String area, String latitude, String longitude,
      String image, String start, String end) async {
    loading = true;
    notifyListeners();
    int response = (await _diaryRepository.dioTravel(id, title, area, latitude, longitude, image, start, end))!;
    if (response == 200) {
      isBack == true;
    }
    loading = false;
    notifyListeners();
  }
}