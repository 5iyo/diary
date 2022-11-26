import 'package:flutter/material.dart';

class CustomElavatedButton extends StatelessWidget {

  final String text;
  final funPageRoute;

  const CustomElavatedButton({required this.text, required this.funPageRoute});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey[400],
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          )
      ),
      onPressed: funPageRoute,
      child: Text("$text"),
    );
  }
}