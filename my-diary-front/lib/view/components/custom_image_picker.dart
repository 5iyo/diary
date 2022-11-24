import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:http_parser/http_parser.dart';

class ImageUploader extends StatefulWidget {

  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  @override
  void initState() {
    super.initState();
  }

  final ImagePicker _picker = ImagePicker();
  List<XFile> _pickedImgs = [];

  Future<void> _pickImg() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if(images != null) {
      setState(() {
        _pickedImgs = images;
      });
    }
  }

  // uploadImage() async {
  //   print(_pickedImgs.toString());
  //   var dio = Dio();
  //   try {
  //     List<MultipartFile> multipartImgList = [];
  //
  //     for (int i = 0; i < _pickedImgs.length; i++) {
  //       var pic = await MultipartFile.fromFile(_pickedImgs[i].path,
  //           contentType: new MediaType("image", "jpg"));
  //       multipartImgList.add(pic);
  //     }
  //
  //     FormData formData = new FormData.fromMap({
  //       "images": multipartImgList,
  //     });
  //
  //     // dio.options.headers["authorization"] =
  //     //     context.read<AuthProvider>().token.toString();
  //     dio.post('URL', data: formData).then((value) => print(value));
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    bool isPadMode = MediaQuery.of(context).size.width > 700;

    List<Widget> _boxContents = [
      IconButton(
          onPressed: () {
            _pickImg();
          },
          icon: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6), shape: BoxShape.circle),
              child: Icon(
                CupertinoIcons.camera,
                color: Theme.of(context).colorScheme.primary,
              ))),
      Container(),
      Container(),
      Container(),
    ];

    return GridView.count(
      shrinkWrap: true,
      padding: EdgeInsets.all(2),
      crossAxisCount: isPadMode ? 4 : 2,
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      children: List.generate(4, (index) => DottedBorder(
        child: Container(
          child: Center(child: _boxContents[index]),
          decoration: index <= _pickedImgs.length -1 ?
            BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: FileImage(File(_pickedImgs[index].path))))
            :null
        ),
        color: Colors.grey,
        dashPattern: [5, 3],
        borderType: BorderType.RRect,
        radius: Radius.circular(10))).toList(),
    );
  }
}
