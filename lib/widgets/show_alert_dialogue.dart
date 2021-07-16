import 'package:flutter/material.dart';

Future<void> showMyDialog(context, text) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Error"),
        content: Text(text),
        elevation: 24.0,
        backgroundColor: Colors.grey,
      );
    },
  );
}
