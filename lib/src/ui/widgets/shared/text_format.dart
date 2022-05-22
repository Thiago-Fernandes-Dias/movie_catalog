library movie_list.text_format;

import 'package:flutter/material.dart';

Widget showMessage(String message, bool isError) {
  TextStyle msgStyle = TextStyle(
    fontSize: 24,
    color: isError ? Colors.red : Colors.grey,
  );

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
    child: Center(
      child: Text(
        message,
        style: msgStyle,
        textAlign: TextAlign.center,
      ),
    ),
  );
}

Widget fieldTitle(String title) {
  const titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  return Container(
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.only(bottom: 20),
    child: Text(
      title,
      style: titleStyle,
      textAlign: TextAlign.left,
    ),
  );
}

String validate(String? text) {
  if (['0', '0.0', '', null].contains(text)) return 'none';
  return text!;
}
