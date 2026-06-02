import 'package:flutter/material.dart';

class ScamPopup {
  static Future<void> show({
    required BuildContext context,
    dynamic notification,
    String? title,
    String? message,
  }) async {
    final popupTitle = title ?? "CyberShield Alert";

    final popupMessage =
        message ??
        notification?.message?.toString() ??
        notification?.body?.toString() ??
        notification?.content?.toString() ??
        notification?.toString() ??
        "Suspicious activity detected";

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF030B2D),
                Color(0xFF060C24),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: const Color(0xFF42D7FF).withValues(alpha: 0.20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 72,
                width: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.redAccent.withValues(alpha: 0.15),
                ),
                child: const Icon(
                  Icons.security_rounded,
                  color: Colors.redAccent,
                  size: 38,
                ),
              ),

              const SizedBox(height: 18),

              Text(
                popupTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                popupMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFAAB6D3),
                  fontSize: 15,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text(
                    "Understood",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF42D7FF),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}