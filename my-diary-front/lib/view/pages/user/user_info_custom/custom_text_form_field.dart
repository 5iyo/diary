import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomTextFormField extends StatelessWidget {
  final String hint;
  final funValidator;
  final controller;

  const CustomTextFormField(
      {required this.hint, required this.funValidator, this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          _selectDateCalendar(context);
        },
        child: AbsorbPointer(
          child: TextFormField(
            controller: controller,
            validator: funValidator,
            decoration: InputDecoration(
              suffixIcon: const Icon(Icons.calendar_month_outlined, color: Colors.blueGrey,),
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
            ),
          ),
        ),
      ),
    );
  }

  void _selectDateCalendar(BuildContext context) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat birthDateFormat = DateFormat('yyyy-MM-dd');
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
                allowViewNavigation: true,
                backgroundColor: ThemeData.light().scaffoldBackgroundColor,
                initialSelectedDate: DateTime.now(),
                maxDate: DateTime.now(),
                selectionMode: DateRangePickerSelectionMode.single,
                confirmText: '선택',
                cancelText: '취소',
                showActionButtons: true,
                onSubmit: (args) => {
                  controller.text = birthDateFormat.format(displayFormater.parse(args.toString())),
                  Navigator.of(context).pop(),
                },
                onCancel: () => Navigator.of(context).pop(),
              ),
            ),
          ));
        });
  }
}
