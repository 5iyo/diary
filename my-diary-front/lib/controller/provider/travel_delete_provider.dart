
import 'package:flutter/cupertino.dart';
import 'package:my_diary_front/controller/diary_repository.dart';

class TravelDeleteProvider extends ChangeNotifier {

  DiaryRepository _diaryRepository = DiaryRepository();
  bool loading = false;
  bool isdelete = false;

  travelDelete(int id) async {
    loading = true;
    notifyListeners();
    int response = (await _diaryRepository.fetchTravelDelete(id))!;
    if (response == 200) {
      isdelete == true;
    }
    loading = false;
    notifyListeners();
  }
}