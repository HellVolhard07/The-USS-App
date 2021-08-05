import 'package:flutter/material.dart';

Future<void> showMyDialog(context, text, {bool showAction = false}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
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
        actions: <Widget>[
          showAction
              ? TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                )
              : Container(),
        ],
      );
    },
  );
}
