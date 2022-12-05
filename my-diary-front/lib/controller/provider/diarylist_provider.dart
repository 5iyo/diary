
import 'package:flutter/cupertino.dart';
import 'package:my_diary_front/controller/diary_repository.dart';
import 'package:my_diary_front/controller/dto/DiaryList_diaries.dart';

class DiaryListProvider extends ChangeNotifier {

  DiaryRepository _diaryRepository = DiaryRepository();
  List<Diaries> _diaries = [];
  bool loading = false;
  bool isBack = false;

  List<Diaries> get diaries => _diaries;
  diaryList(int id) async {
    List<Diaries> diaries = await _diaryRepository.fetchDiaryList(id);
    _diaries = diaries;
    notifyListeners();
  }
}