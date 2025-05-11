import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GeriButonu extends StatelessWidget {
  const GeriButonu({super.key});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoNavigationBarBackButton(
            onPressed: () {
              Navigator.pop(context);
            },
            previousPageTitle: "Geri",
            color: Colors.black,
          )
        : BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.black,
          );
  }
}
