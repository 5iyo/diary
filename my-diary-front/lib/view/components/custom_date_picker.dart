import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomDatePicker extends StatefulWidget {

  final controller;
  final init;
  final funValidator;

  const CustomDatePicker({this.controller, this.init, this.funValidator});

  @override
  State<CustomDatePicker> createState() => _CustomDatePicker(controller, init, funValidator);
}

class _CustomDatePicker extends State<CustomDatePicker> {
  //TextEditingController _DataTimeEditingController = TextEditingController();
  TextEditingController _EstimatedEditingController = TextEditingController();

  DateTime? tempPickedDate;

  final controller;
  final init;
  final funValidator;
  _CustomDatePicker(this.controller, this.init, this.funValidator);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        _selectDateCalendar(context);
      },
      child: AbsorbPointer(
        child: Container(
/*          decoration: BoxDecoration(
            border: Border.all(),
          ),*/
          // width: MediaQuery
          //     .of(context)
          //     .size
          //     .width,
          color: Colors.white,
          child: Center(
            child: TextFormField(
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                isDense: true,
                hintText: "$init",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              controller: controller,
              validator: funValidator,
              //_DataTimeEditingController,
            ),
          ),
        ),
      ),
    );
  }

  void _selectDateCalendar(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return SafeArea(
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.1,
                  height: 550,
                  child: SfDateRangePicker(
                    monthViewSettings: DateRangePickerMonthViewSettings(
                      dayFormat: 'EEE',
                    ),
                    monthFormat: 'MMM',
                    showNavigationArrow: true,
                    headerStyle: DateRangePickerHeaderStyle(
                      textAlign: TextAlign.center,
                      textStyle: TextStyle(fontSize: 25, color: Colors.blueAccent),
                    ),
                    headerHeight: 80,
                    view: DateRangePickerView.month,
                    allowViewNavigation: false,
                    backgroundColor: ThemeData.light().scaffoldBackgroundColor,
                    initialSelectedDate: DateTime.now(),
                    //minDate: DateTime.now(),
                    // 아래코드는 tempPickedDate를 전역으로 받아 시작일을 선택한 날자로 시작할 수 있음
                    minDate: tempPickedDate,
                    maxDate: DateTime.now().add(new Duration(days: 365)),
                    // 아래 코드는 선택시작일로부터 2주까지밖에 날자 선택이 안됌
                    //maxDate: tempPickedDate!.add(new Duration(days: 14)),
                    selectionMode: DateRangePickerSelectionMode.single,
                    confirmText: '완료',
                    cancelText: '취소',
                    onSubmit: (args) => {
                      setState(() {
                        _EstimatedEditingController.clear();
                        //tempPickedDate = args as DateTime?;
                        controller.text = args.toString();
                        convertDateTimeDisplay(
                            controller.text, '방문');
                        Navigator.of(context).pop();
                      }),
                    },
                    onCancel: () => Navigator.of(context).pop(),
                    showActionButtons: true,
                  ),
                ),
              ));
        });
  }

  String convertDateTimeDisplay(String date, String text) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
    final DateTime displayDate = displayFormater.parse(date);
    if (text == '방문') {
      _EstimatedEditingController.clear();
      return controller.text =
          serverFormater.format(displayDate);
    } else
      return _EstimatedEditingController.text =
          serverFormater.format(displayDate);
  }
}
