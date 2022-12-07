import 'package:my_diary_front/controller/dto/DiaryResp.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_diary_front/controller/diary_repository.dart';
import 'package:my_diary_front/controller/dto/DiaryList_diaries.dart';

class DiaryProvider extends ChangeNotifier {

  DiaryRepository _diaryRepository = DiaryRepository();
  Diary _diary = Diary();

  Diary get diary => _diary;
  getdiary(int id) async {
    Diary diary = await _diaryRepository.fetchDiary(id);
    _diary = diary;
    notifyListeners();
  }
}