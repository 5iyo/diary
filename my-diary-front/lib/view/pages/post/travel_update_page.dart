import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_diary_front/util/validator_util.dart';
import 'package:my_diary_front/view/components/custom_date_picker.dart';
import 'package:my_diary_front/view/components/custom_elevated_button.dart';
import 'package:my_diary_front/view/components/custom_text_form_field.dart';
import 'package:my_diary_front/view/components/ui_view_model.dart';
import 'package:my_diary_front/view/pages/post/travel_list_page.dart';
import 'package:provider/provider.dart';
import '../../../controller/dto/TravelListResp.dart';
import 'dart:async';
import '../../../controller/provider/travel_update_provider.dart';

class TravelUpdatePage extends StatefulWidget {
  final LatLng? travelLatLng;
  final int? id;
  final String? title;
  final String? image;

  const TravelUpdatePage(this.travelLatLng, this.id, this.title, this.image);

  @override
  State<TravelUpdatePage> createState() =>
      _TravelUpdatePageState(travelLatLng!, id!, title!, image!);
}

class _TravelUpdatePageState extends State<TravelUpdatePage> {
  TravelUpdateProvider travelUpdateProvider = TravelUpdateProvider();

  LatLng travelLatLng;
  final int id;
  final String title;
  final String image;

  _TravelUpdatePageState(this.travelLatLng, this.id, this.title, this.image);

  final _formKey = GlobalKey<FormState>();

  final _title = TextEditingController();
  final _startDate = TextEditingController();
  final _endDate = TextEditingController();

  Future<TravelList>? travelList;
  List<File> updateImage = [];
  List<String> travelImage = [];
  List<String> base64 = [];
  final ImagePicker _picker = ImagePicker();
  ScrollController controller = ScrollController();

  bool isAwait = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [UiViewModel.buildBackgroundContainer(
              context: context,
              backgroundType: BackgroundType.write,
              child: UiViewModel.buildSizedLayout(context, buildTravel())),isAwait ? UiViewModel.buildProgressBar() : Container(),]
        ));
  }

  Widget buildTravel() {
    travelUpdateProvider =
        Provider.of<TravelUpdateProvider>(context, listen: false);

    String startInit = "여행 시작 날짜";
    String endInit = "여행 종료 날짜";
    _title.text = title;
    UriData? data;
    Uint8List? bytes;
    travelImage.add(image); //travelImage[0] = image

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: <Widget>[
                Expanded(
                    child: CustomDatePicker(
                        controller: _startDate,
                        init: startInit,
                        funValidator: validateDate())),
                Padding(padding: EdgeInsets.all(5.0)),
                Expanded(
                    child: CustomDatePicker(
                        controller: _endDate,
                        init: endInit,
                        funValidator: validateDate())),
              ],
            ),
            SizedBox(height: 10),
            CustomTextFormField(
                controller: _title, hint: " ", funValidator: validateTitle()),
            SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  Stack(children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 200.0,
                        child: travelImage[0] == ""
                            ? Center(child: Text("이미지를 등록해주세요"))
                            : ListView.builder(
                                padding: EdgeInsets.all(10.0),
                                scrollDirection: Axis.horizontal,
                                controller: this.controller,
                                itemCount: 1,
                                itemBuilder: (BuildContext context, int index) {
                                  travelImage[0] == "" || travelImage[0] == null
                                      ? data = null
                                      : data = Uri.parse(travelImage[0]).data;
                                  data == null
                                      ? bytes = null
                                      : bytes = data!.contentAsBytes();
                                  if (bytes != null) {
                                    return Stack(children: <Widget>[
                                      GestureDetector(
                                        child: Container(
                                          width: 200.0,
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                            clipBehavior: Clip.antiAlias,
                                            borderOnForeground: false,
                                            child: Image.memory(bytes!,
                                                fit: BoxFit.cover),
                                          ),
                                          padding: EdgeInsets.all(10.0),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              travelImage[0] = "";
                                            });
                                          },
                                          child: Container(
                                              width: 30.0,
                                              height: 30.0,
                                              margin: EdgeInsets.all(5.0),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0)),
                                              child: Center(
                                                  child: Icon(
                                                Icons.close,
                                                size: 20.0,
                                                color: Colors.white,
                                              ))),
                                        ),
                                      ),
                                    ]);
                                  } else {
                                    return Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 200.0,
                                        child:
                                            Center(child: Text("이미지를 등록해주세요")));
                                  }
                                })),
                  ]),
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: IconButton(
                    color: travelImage[0] != "" ? Colors.white : Colors.grey,
                    icon: travelImage[0] != ""
                        ? Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.6),
                                shape: BoxShape.circle),
                            child: Icon(
                              CupertinoIcons.xmark,
                              color: Theme.of(context).colorScheme.primary,
                            ))
                        : Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.6),
                                shape: BoxShape.circle),
                            child: Icon(
                              CupertinoIcons.camera,
                              color: Theme.of(context).colorScheme.primary,
                            )),
                    onPressed: travelImage[0] != ""
                        ? () => print("이미지 초과")
                        : () async {
                            bool? check = await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text("갤러리를 통해 업로드할 수 있습니다"),
                                          actions: <Widget>[
                                            ElevatedButton(
                                              child: Text("앨범"),
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                            ),
                                            ElevatedButton(
                                              child: Text("취소"),
                                              onPressed: () async =>
                                                  Navigator.of(context)
                                                      .pop(null),
                                            ),
                                          ],
                                        )) ??
                                null;
                            setState(() {
                              isAwait = true;
                            });
                            final pickgallery = await _picker.pickImage(
                                source: ImageSource.gallery);
                            setState(() {
                              isAwait = false;
                            });
                            final gfile = File(pickgallery!.path.toString());

                            updateImage.add(gfile);
                            this.updateImage.isEmpty
                                ? null
                                : this.updateImage.forEach((e) => base64.add(
                                    "data:image/png;base64,${base64Encode(e.readAsBytesSync())}"));
                            base64.isEmpty ? base64 = travelImage : base64;
                            travelImage[0] = base64[base64.length - 1];

                            return setState(() {});
                          },
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: CustomElavatedButton(
                    text: "수정하기",
                    funPageRoute: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isAwait = true;
                        });
                        await travelUpdateProvider.travelUpdate(id, _title.text,
                            travelImage[0], _startDate.text, _endDate.text);
                        setState(() {
                          isAwait = false;
                        });
                        Get.offAll(
                            () => TravelListPage(travelLatLng: travelLatLng));
                      }
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
