import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:my_diary_front/data.dart';

import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_share/social_share.dart';

class DiaryScreenshot {
  ScreenshotController screenshotController = ScreenshotController();

  Future<File?> screenshot([Uint8List? googleMapScreenshot]) async {
    Uint8List? data;

    if (googleMapScreenshot == null) {
      data = await screenshotController.capture();
    } else {
      data = googleMapScreenshot;
    }

    if (data == null) {
      return null;
    }

    final tempDir = await getTemporaryDirectory();
    final assetPath = '${tempDir.path}/temp.png';
    File file = await File(assetPath).create();
    await file.writeAsBytes(data);
    return file;
  }
}

class DiarySocialShareViewModel {
  List<DiarySocialShare> shares = [DiaryInstagramShare(), DiaryFacebookShare(),DiaryKakaostoryShare()];

  PopupMenuButton<DiarySocialShare> buildPopupMenu(
      BuildContext context, Function onSelected) {
    print("buildPopupMenu");
    return PopupMenuButton<DiarySocialShare>(
        icon: const Icon(
          Icons.share_outlined,
          color: Colors.white,
        ),
        color: Colors.blueGrey[400]!.withOpacity(0.4),
        offset: Offset(0, AppBar().preferredSize.height + 8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        constraints: BoxConstraints.expand(
            width: AppBar().preferredSize.height * 3,
            height:
                (AppBar().preferredSize.height + 16.0) * shares.length + 16.0),
        itemBuilder: (context) => _popupMenuItemBuilder(context),
        onSelected: (item) => onSelected(item));
  }

  List<PopupMenuEntry<DiarySocialShare>> _popupMenuItemBuilder(context) {
    List<PopupMenuEntry<DiarySocialShare>> items = [];
    for (DiarySocialShare e in shares) {
      items.add(PopupMenuItem(
        value: e,
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Image.asset('img/${e.name}_icon.png',
                height: AppBar().preferredSize.height, fit: BoxFit.fitHeight),
            const Spacer(),
            Text(
              e.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ));
    }
    return items;
  }
}

abstract class DiarySocialShare {
  late String name;

  Future share(DiaryScreenshot diaryShare, [Uint8List? googleMapScreenshot]);
}

class DiaryInstagramShare implements DiarySocialShare {
  @override
  String name = "Instagram";

  @override
  Future share(DiaryScreenshot diaryShare,
      [Uint8List? googleMapScreenshot]) async {
    var file = await diaryShare.screenshot(googleMapScreenshot);

    if(file == null) {
      return;
    }

    var path = file.path;

    print("####$path");

    await SocialShare.shareInstagramStory(
            appId: dotenv.get("FACEBOOK_APP_ID"), imagePath: path)
        .then((value) => print(value));
/*    await SocialSharePlugin.shareToFeedInstagram(path: path);*/
  }
}

class DiaryFacebookShare implements DiarySocialShare {
  @override
  String name = "Facebook";

  @override
  Future share(DiaryScreenshot diaryShare,
      [Uint8List? googleMapScreenshot]) async {
    var file = await diaryShare.screenshot(googleMapScreenshot);

    if(file == null) {
      return;
    }

    var path = file.path;

    print(path);

    await SocialShare.shareFacebookStory(
            appId: dotenv.get("FACEBOOK_APP_ID"), imagePath: path)
        .then((value) => print(value));
/*    await SocialSharePlugin.shareToFeedFacebook(path: path);*/
  }
}

class DiaryKakaostoryShare implements DiarySocialShare{
  @override
  String name = "Kakaostory";

  KakaoLogin kakaoLogin = KakaoLogin();

  @override
  Future share(DiaryScreenshot diaryShare,
      [Uint8List? googleMapScreenshot]) async {
    var file = await diaryShare.screenshot(googleMapScreenshot);
    bool isKakao = true;

    if(file == null) {
      return;
    }

    List<String> images;

    try {
      images = await StoryApi.instance.upload([file]);
      print('사진 업로드 성공 $images');
    }catch (error){
      print('사진 업로드 실패 $error');
      isKakao = false;
      await kakaoLogin.login();
      try{
        images = await StoryApi.instance.upload([file]);
      } catch (error) {
        return;
      }
    }

    // 업로드한 사진 파일 정보로 사진 스토리 쓰기
    try {
      String content = '여기에 공유 내용 작성';
      StoryPostResult storyPostResult = await StoryApi.instance
          .postPhoto(images: images, content: content);
      print('스토리 쓰기 성공 [${storyPostResult.id}]');
    } catch (error) {
      print('스토리 쓰기 실패 $error');
    }

    if(!isKakao) {
      print("is not kakao");
      await kakaoLogin.logout();
    }
  }

}
