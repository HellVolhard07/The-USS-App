import 'package:flutter/material.dart';

Future<void> showMyDialog(context, text) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "Error",
          style: TextStyle(color: Colors.black),
        ),
        content: Text(
          text,
          style: TextStyle(color: Colors.black),
        ),
        elevation: 24.0,
        backgroundColor: Colors.white,
        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      );
    },
  );
}
