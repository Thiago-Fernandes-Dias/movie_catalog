import 'package:flutter/material.dart';

Widget fetchImage(String url, String asset) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(5.0),
    child: !url.contains('null')
        ? Image.network(
            url,
            fit: BoxFit.fitHeight,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return loadingArea();
            },
          )
        : Image.asset(
            asset,
            fit: BoxFit.fitHeight,
          ),
  );
}

Widget loadingField() {
  return Container(
    width: 40,
    height: 1,
    child: LinearProgressIndicator(),
  );
}

Widget loadingArea() {
  return Center(
    child: CircularProgressIndicator(),
  );
}
