import 'package:my_diary_front/controller/dto/DiaryImageResp.dart';
import 'package:my_diary_front/controller/dto/DiaryResp.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_diary_front/controller/diary_repository.dart';

class DiaryImageProvider extends ChangeNotifier {

  DiaryRepository _diaryRepository = DiaryRepository();
  DiaryImage _diaryImage = DiaryImage();
  bool _isImgUpdate = false;
  bool get isImgUpdate => _isImgUpdate;

  DiaryImage get diaryImage => _diaryImage;
  getdiaryImage(int id) async {
    _isImgUpdate = true;
    notifyListeners();
    DiaryImage diaryImage = await _diaryRepository.fetchDiaryImage(id);
    _diaryImage = diaryImage;
    _isImgUpdate = false;
    notifyListeners();
  }
}