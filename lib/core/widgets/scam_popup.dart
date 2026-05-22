import 'package:flutter/material.dart';

class ScamPopup {
  static Future<void> show({
    required BuildContext context,
    dynamic notification,
    String? title,
    String? message,
  }) async {
    final popupTitle = title ?? "Scam Alert";
    final popupMessage = message ??
        notification?.message?.toString() ??
        notification?.body?.toString() ??
        notification?.content?.toString() ??
        notification?.toString() ??
        "Suspicious activity detected";

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(popupTitle),
        content: Text(popupMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}