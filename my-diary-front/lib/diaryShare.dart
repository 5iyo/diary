import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_share/social_share.dart';

class DiaryScreenshot {
  ScreenshotController screenshotController = ScreenshotController();

  Future<String?> screenshot() async {
    var data = await screenshotController.capture();

    if (data == null) {
      return null;
    }

    final tempDir = await getTemporaryDirectory();
    final assetPath = '${tempDir.path}/temp.png';
    File file = await File(assetPath).create();
    await file.writeAsBytes(data);
    return file.path;
  }
}

abstract class DiarySocialShare {
  Future share(DiaryScreenshot diaryShare);
}

class DiaryInstagramShare implements DiarySocialShare {
  @override
  Future share(DiaryScreenshot diaryShare) async {
    var path = await diaryShare.screenshot();

    print("####$path");

    if (path == null) {
      return;
    }

    await SocialShare.shareInstagramStory(appId: dotenv.get("FACEBOOK_APP_ID"), imagePath: path).then((value) => print(value));
/*    await SocialSharePlugin.shareToFeedInstagram(path: path);*/
  }
}

class DiaryFacebookShare implements DiarySocialShare {
  @override
  Future share(DiaryScreenshot diaryShare) async {
    var path = await diaryShare.screenshot();

    print(path);

    if (path == null) {
      return;
    }
    await SocialShare.shareFacebookStory(appId: dotenv.get("FACEBOOK_APP_ID"), imagePath: path).then((value) => print(value));
/*    await SocialSharePlugin.shareToFeedFacebook(path: path);*/
  }
}