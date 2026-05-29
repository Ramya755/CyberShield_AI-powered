import 'package:cyber_shield/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;

  const EmptyStateWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon, size: 48),
          Text(title),
          if (subtitle != null) Text(subtitle!),
        ],
      ),
    );
  }
}

class DetectionCard extends StatelessWidget {
  final dynamic detection;
  final dynamic message;
  final VoidCallback? onDismiss;

  const DetectionCard({
    super.key,
    this.detection,
    this.message,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final data = detection ?? message;
    String appName = data?.appName?.toString() ?? 'Unknown App';

switch (appName.toLowerCase()) {
  case 'com.whatsapp':
    appName = 'WhatsApp';
    break;

  case 'com.facebook.orca':
    appName = 'Messenger';
    break;

  case 'com.google.android.apps.messaging':
    appName = 'Messages';
    break;
}
    final sender = data?.sender?.toString() ?? 'Unknown Sender';
    final text = data?.message?.toString() ?? 'No message';
    final isScam = data?.isScam == true;
    final score = data?.riskScore is int
    ? data.riskScore as int
    : int.tryParse(data?.riskScore?.toString() ?? '0') ?? 0;

final riskLabel = score >= 80
    ? '🔴 High Risk Scam'
    : score >= 50
        ? '🟠 Medium Risk Scam'
        : '🟡 Low Risk Suspicious';

    return Card(
      color: AppColors.cardDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: isScam ? Colors.redAccent : AppColors.border,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isScam
              ? Colors.red.withValues(alpha: 0.15)
              : Colors.green.withValues(alpha: 0.15),
          child: Icon(
            isScam ? Icons.warning_amber_rounded : Icons.check_circle,
            color: isScam ? Colors.redAccent : Colors.greenAccent,
          ),
        ),
        title: Text(
          sender,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            '$appName\n$text\n${isScam ? riskLabel : "Safe"}\nRisk Score: $score/100',
            style: const TextStyle(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ),
        isThreeLine: true,
        trailing: onDismiss == null
            ? null
            : IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: onDismiss,
              ),
      ),
    );
  }
}