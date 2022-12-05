
import 'package:flutter/cupertino.dart';
import 'package:my_diary_front/controller/diary_repository.dart';

class TravelUpdateProvider extends ChangeNotifier {

  DiaryRepository _diaryRepository = DiaryRepository();
  bool isupdate = false;

  travelUpdate(int id, String title, String image, String startdate, String enddate) async {
    notifyListeners();
    int response = (await _diaryRepository.dioTravelUpdate(id, title, image, startdate, enddate))!;
    if (response == 200) {
      isupdate == true;
    }
    notifyListeners();
  }
}