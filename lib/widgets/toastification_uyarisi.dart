import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showToastification(
  BuildContext context,
  String title,
  String description,
  ToastificationType type,
) {
  toastification.show(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
    type: type,
    style: ToastificationStyle.fillColored,
    title: Text(title),
    description: Text(description),
    autoCloseDuration: const Duration(seconds: 3),
    animationDuration: const Duration(milliseconds: 300),
    showProgressBar: true,
  );
}
