import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_diary_front/data.dart';
import 'package:my_diary_front/util/validator_util.dart';
import 'package:my_diary_front/view/components/custom_date_picker.dart';
import 'package:my_diary_front/view/components/custom_elevated_button.dart';
import 'package:my_diary_front/view/components/custom_text_form_field.dart';
import 'package:my_diary_front/view/components/ui_view_model.dart';
import 'package:my_diary_front/view/pages/post/travel_list_page.dart';

import 'package:provider/provider.dart';

import '../../../controller/provider/travel_provider.dart';

class TravelPage extends StatefulWidget {
  final String id;
  final LatLng travelLatLng;

  const TravelPage(this.id, this.travelLatLng);

  @override
  State<TravelPage> createState() => _TravelPageState(id, travelLatLng);
}

class _TravelPageState extends State<TravelPage> {
  TravelProvider travelProvider = TravelProvider();

  final LatLng travelLatLng;
  final String id;

  _TravelPageState(this.id, this.travelLatLng);

  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _startdate = TextEditingController();
  final _enddate = TextEditingController();

  List<File> travelImage = [];
  List<String> base64 = [];
  final ImagePicker _picker = ImagePicker();
  ScrollController controller = ScrollController();

  bool isAwait = false;

  @override
  Widget build(BuildContext context) {
    travelProvider = Provider.of<TravelProvider>(context, listen: false);
    String startinit = "여행 시작 날짜";
    String endinit = "여행 종료 날짜";

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        extendBodyBehindAppBar: true,
        body: Stack(children: [
          UiViewModel.buildBackgroundContainer(
              context: context,
              backgroundType: BackgroundType.write,
              child: UiViewModel.buildSizedLayout(
                context,
                Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: CustomDatePicker(
                                    controller: _startdate,
                                    init: startinit,
                                    funValidator: validateDate())),
                            Padding(padding: EdgeInsets.all(5.0)),
                            Expanded(
                                child: CustomDatePicker(
                                    controller: _enddate,
                                    init: endinit,
                                    funValidator: validateDate())),
                          ],
                        ),
                        SizedBox(height: 10),
                        CustomTextFormField(
                            controller: _title,
                            hint: "Title",
                            funValidator: validateTitle()),
                        SizedBox(height: 10),
                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: this.travelImage.isEmpty
                                ? Center(child: Text("이미지를 등록해주세요"))
                                : Stack(children: <Widget>[
                                    Positioned(
                                      top: 0.0,
                                      bottom: 0.0,
                                      right: 0.0,
                                      left: 0.0,
                                      child: GestureDetector(
                                        child: Container(
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                            clipBehavior: Clip.antiAlias,
                                            borderOnForeground: false,
                                            child: Image.file(
                                                this.travelImage[0],
                                                fit: BoxFit.cover),
                                          ),
                                          padding: EdgeInsets.all(10.0),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            travelImage.remove(travelImage[0]);
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
                                  ])),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                color: this.travelImage.length >= 1
                                    ? Colors.white
                                    : Colors.grey,
                                icon: this.travelImage.length >= 1
                                    ? Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.6),
                                            shape: BoxShape.circle),
                                        child: Icon(
                                          CupertinoIcons.xmark,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ))
                                    : Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.6),
                                            shape: BoxShape.circle),
                                        child: Icon(
                                          CupertinoIcons.camera,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        )),
                                onPressed: this.travelImage.length >= 1
                                    ? () => print("이미지 초과")
                                    : () async {
                                        bool? check = await showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      title: Text(
                                                          "갤러리를 통해 업로드할 수 있습니다"),
                                                      actions: <Widget>[
                                                        ElevatedButton(
                                                          child: Text("앨범"),
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(false),
                                                        ),
                                                        ElevatedButton(
                                                          child: Text("취소"),
                                                          onPressed: () async =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(null),
                                                        ),
                                                      ],
                                                    )) ??
                                            null;
                                        setState(() {
                                          isAwait = true;
                                        });
                                        final pickgallery =
                                            await _picker.pickImage(
                                                source: ImageSource.gallery);
                                        setState(() {
                                          isAwait = false;
                                        });
                                        final gfile =
                                            File(pickgallery!.path.toString());
                                        travelImage.add(gfile);

                                        return setState(() {});
                                      },
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: CustomElavatedButton(
                                text: "여행 만들기",
                                funPageRoute: () async {
                                  this.travelImage.isEmpty
                                      ? null
                                      : this.travelImage.forEach((e) => base64.add(
                                          "data:image/png;base64,${base64Encode(e.readAsBytesSync())}"));
                                  base64.isEmpty ? base64 = [""] : base64;
                                  print(base64[0]);
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      isAwait = true;
                                    });
                                    await travelProvider.travelsave(
                                        id,
                                        _title.text,
                                        " ",
                                        "${travelLatLng.latitude}",
                                        "${travelLatLng.longitude}",
                                        base64[0],
                                        _startdate.text,
                                        _enddate.text);
                                    setState(() {
                                      isAwait = false;
                                    });
                                    Get.to(() => TravelListPage(
                                        travelLatLng: travelLatLng));
                                    //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => TravelListPage()), (route) => false);
                                  }
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )),
          isAwait ? UiViewModel.buildProgressBar() : Container(),
        ]));
  }
}
