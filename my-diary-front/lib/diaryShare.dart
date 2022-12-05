import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_share/social_share.dart';

class DiaryScreenshot {
  ScreenshotController screenshotController = ScreenshotController();

  Future<String?> screenshot([Uint8List? googleMapScreenshot]) async {
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
    return file.path;
  }
}

class DiarySocialShareViewModel {
  List<DiarySocialShare> shares = [DiaryInstagramShare(), DiaryFacebookShare()];

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
    var path = await diaryShare.screenshot(googleMapScreenshot);

    print("####$path");

    if (path == null) {
      return;
    }

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
    var path = await diaryShare.screenshot(googleMapScreenshot);

    print(path);

    if (path == null) {
      return;
    }
    await SocialShare.shareFacebookStory(
            appId: dotenv.get("FACEBOOK_APP_ID"), imagePath: path)
        .then((value) => print(value));
/*    await SocialSharePlugin.shareToFeedFacebook(path: path);*/
  }
}
