import 'package:flutter/material.dart';

Widget fetchImage({
  required String url,
  required String assetOption,
}) {
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
            assetOption,
            fit: BoxFit.fitHeight,
          ),
  );
}

Widget loadingField() {
  return const SizedBox(
    width: 40,
    height: 1,
    child: LinearProgressIndicator(),
  );
}

Widget loadingArea() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}
