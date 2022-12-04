import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomTextFormField extends StatelessWidget {

  final String hint;
  final funValidator;
  final controller;

  CustomTextFormField({super.key, required this.hint, required this.funValidator, this.controller});
  final DateFormat serverFormater = DateFormat('yyyy-MM-dd', 'ko');

  @override
  Widget build(BuildContext context) {
    TextEditingController estimatedEditingController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          showCupertinoDialog(
              context: context,
              builder: (context) {
                return SafeArea(
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.1,
                        height: 550,
                        child: SfDateRangePicker(
                          monthViewSettings: const DateRangePickerMonthViewSettings(
                            dayFormat: 'EEE',
                          ),
                          monthFormat: 'MMM',
                          showNavigationArrow: true,
                          headerStyle: const DateRangePickerHeaderStyle(
                            textAlign: TextAlign.center,
                            textStyle: TextStyle(fontSize: 25, color: Colors.blueAccent),
                          ),
                          headerHeight: 80,
                          view: DateRangePickerView.month,
                          allowViewNavigation: false,
                          backgroundColor: ThemeData.light().scaffoldBackgroundColor,
                          initialSelectedDate: DateTime.now().subtract(const Duration(days: 365 * 10)),
                          //minDate: DateTime.now(),
                          // 아래코드는 tempPickedDate를 전역으로 받아 시작일을 선택한 날자로 시작할 수 있음
                          minDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
                          maxDate: DateTime.now().subtract(const Duration(days: 365 * 10)),
                          // 아래 코드는 선택시작일로부터 2주까지밖에 날자 선택이 안됌
                          //maxDate: tempPickedDate!.add(new Duration(days: 14)),
                          selectionMode: DateRangePickerSelectionMode.single,
                          confirmText: '완료',
                          cancelText: '취소',
                          onSubmit: (args) {
                            estimatedEditingController.clear();
                            controller.text = serverFormater.format(DateTime.parse(args.toString()));
                            Navigator.of(context).pop();
                          },
                          onCancel: () => Navigator.of(context).pop(),
                          showActionButtons: true,
                        ),
                      ),
                    ));
              });
        },
        child: AbsorbPointer(
          child: TextFormField(
            controller: controller,
            validator: funValidator,
            decoration: InputDecoration(
              hintText: "Enter $hint",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              prefixIcon:const Icon(Icons.calendar_month_rounded)
            ),
          ),
        ),
      ),
    );
  }
}
