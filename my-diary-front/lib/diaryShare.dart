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

import 'package:image/image.dart' as IMG;

class DiaryScreenshot {
  ScreenshotController screenshotController = ScreenshotController();

  Future<File?> screenshot([Uint8List? googleMapScreenshot]) async {
    Uint8List? data;

    if (googleMapScreenshot == null) {
      data = await screenshotController.capture(delay: Duration(milliseconds: 500));
    } else {
      data = googleMapScreenshot;
    }

    if (data == null) {
      return null;
    }

    IMG.Image? img = IMG.decodeImage(data);
    IMG.Image resized = IMG.copyResize(img!, width: (img.width / 2).round(), height: (img.height / 2).round());
    data = Uint8List.fromList(IMG.encodePng(resized));

    final tempDir = await getTemporaryDirectory();
    final assetPath = '${tempDir.path}/temp.png';
    File file = await File(assetPath).create();
    await file.writeAsBytes(data);
    return file;
  }
}

class DiarySocialShareViewModel {
  List<DiarySocialShare> shares = [
    DiaryInstagramShare(),
    DiaryFacebookShare(),
    DiaryKakaostoryShare(),
    DiaryKakaoTalkShare()
  ];

  PopupMenuButton<DiarySocialShare> buildPopupMenu(
      BuildContext context, Function onSelected, [Color iconColor = Colors.white]) {
    print("buildPopupMenu");
    return PopupMenuButton<DiarySocialShare>(
        icon: Icon(
          Icons.share_outlined,
          color: iconColor,
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppBar().preferredSize.height * 1),
            )
          ],
        ),
      ));
    }
    return items;
  }

  static FeedTemplate buildDefaultFeed({
    required String title,
    required String uri,
  }) {
    return FeedTemplate(
      content: Content(
        title: title,
        imageUrl: Uri.parse(uri),
        link: Link(
            webUrl: Uri.parse(uri),
            mobileWebUrl: Uri.parse(uri)),
      ),
    );
  }
}

abstract class DiarySocialShare {
  late String name;

  Future<bool> share(DiaryScreenshot diaryShare, [Uint8List? googleMapScreenshot]);
}

class DiaryInstagramShare implements DiarySocialShare {
  @override
  String name = "Instagram";

  @override
  Future<bool> share(DiaryScreenshot diaryShare,
      [Uint8List? googleMapScreenshot]) async {
    var file = await diaryShare.screenshot(googleMapScreenshot);

    if (file == null) {
      return false;
    }

    var path = file.path;

    print("####$path");

    var result = await SocialShare.shareInstagramStory(
            appId: dotenv.get("FACEBOOK_APP_ID"), imagePath: path);
    if(result == 'error') {
      return false;
    } else {
      return true;
    }
/*    await SocialSharePlugin.shareToFeedInstagram(path: path);*/
  }
}

class DiaryFacebookShare implements DiarySocialShare {
  @override
  String name = "Facebook";

  @override
  Future<bool> share(DiaryScreenshot diaryShare,
      [Uint8List? googleMapScreenshot]) async {
    var file = await diaryShare.screenshot(googleMapScreenshot);

    if (file == null) {
      return false;
    }

    var path = file.path;

    print(path);

    var result = await SocialShare.shareFacebookStory(
            appId: dotenv.get("FACEBOOK_APP_ID"), imagePath: path);
    if(result == 'error') {
      return false;
    } else {
      return true;
    }
/*    await SocialSharePlugin.shareToFeedFacebook(path: path);*/
  }
}

class DiaryKakaostoryShare implements DiarySocialShare {
  @override
  String name = "Kakaostory";

  KakaoLogin kakaoLogin = KakaoLogin();

  @override
  Future<bool> share(DiaryScreenshot diaryShare,
      [Uint8List? googleMapScreenshot]) async {
    var file = await diaryShare.screenshot(googleMapScreenshot);
    bool isKakao = true;

    if (file == null) {
      return false;
    }

    List<String> images;

    try {
      images = await StoryApi.instance.upload([file]);
      print('?????? ????????? ?????? $images');
    } catch (error) {
      isKakao = false;
      await kakaoLogin.login();
      try {
        images = await StoryApi.instance.upload([file]);
      } catch (error) {
        print('?????? ????????? ?????? $error');
        return false;
      }
    }

    // ???????????? ?????? ?????? ????????? ?????? ????????? ??????
    try {
      String content = '????????? ?????? ?????? ??????';
      StoryPostResult storyPostResult =
          await StoryApi.instance.postPhoto(images: images, content: content);
      print('????????? ?????? ?????? [${storyPostResult.id}]');
    } catch (error) {
      print('????????? ?????? ?????? $error');
      return false;
    }

    if (!isKakao) {
      print("is not kakao");
      await kakaoLogin.logout();
    }

    return true;
  }
}

class DiaryKakaoTalkShare implements DiarySocialShare {
  @override
  String name = "KakaoTalk";

  KakaoLogin kakaoLogin = KakaoLogin();

  @override
  Future<bool> share(DiaryScreenshot diaryShare,
      [Uint8List? googleMapScreenshot]) async {
    var file = await diaryShare.screenshot(googleMapScreenshot);
    bool isKakao = true;

    if (file == null) {
      return false;
    }

    ImageUploadResult imageUploadResult;

    try {
      // ????????? ????????? ????????? ?????????
      imageUploadResult = await ShareClient.instance.uploadImage(image: file);
      print('????????? ????????? ??????'
          '\n${imageUploadResult.infos.original}');
    } catch (error) {
      isKakao = false;
      await kakaoLogin.login();
      try {
        imageUploadResult = await ShareClient.instance.uploadImage(image: file);
      } catch (error) {
        print('????????? ????????? ?????? $error');
        return false;
      }
    }

    print(imageUploadResult.infos.original.url);

    // ?????? ?????????, ????????? ????????? ??????
    FeedTemplate template = DiarySocialShareViewModel.buildDefaultFeed(
        title: "OIYO MY DIARY", uri: imageUploadResult.infos.original.url);

    bool isKakaoTalkSharingAvailable =
        await ShareClient.instance.isKakaoTalkSharingAvailable();

    if (isKakaoTalkSharingAvailable) {
      try {
        Uri uri = await ShareClient.instance.shareDefault(template: template);
        await ShareClient.instance.launchKakaoTalk(uri);
        print('???????????? ?????? ??????');
      } catch (error) {
        print('???????????? ?????? ?????? $error');
      }
    } else {
      try {
        Uri shareUrl =
            await WebSharerClient.instance.makeDefaultUrl(template: template);
        await launchBrowserTab(shareUrl);
      } catch (error) {
        print('???????????? ?????? ?????? $error');
        return false;
      }
    }
    if (!isKakao) {
      print("is not kakao");
      await kakaoLogin.logout();
    }

    return true;
  }
}
