import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

Future<void> showAlertDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String defaultActionText,
  VoidCallback? onOkPressed, 
}) async {
  if (Platform.isIOS) {
    return await showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: () {
              onOkPressed?.call(); 
              Navigator.of(context).pop();
            },
            child: Text(defaultActionText),
          ),
        ],
      ),
    );
  }

  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            onOkPressed?.call(); 
            Navigator.of(context).pop(); 
          },
          child: Text(defaultActionText),
        ),
      ],
    ),
  );
}
