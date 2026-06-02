import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/notification_listener_provider.dart';

const Color kPermissionBgTop = Color(0xFF030B2D);
const Color kPermissionBgBottom = Color(0xFF060C24);
const Color kPermissionCyan = Color(0xFF42D7FF);
const Color kPermissionViolet = Color(0xFF9A63FF);
const Color kPermissionMuted = Color(0xFFAAB6D3);

class NotificationPermissionScreen extends StatelessWidget {
  const NotificationPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationListenerProvider>();

    return Scaffold(
      backgroundColor: kPermissionBgBottom,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kPermissionBgTop, kPermissionBgBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 92,
                    width: 92,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [kPermissionCyan, kPermissionViolet],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(
                      Icons.shield_rounded,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                const Center(
                  child: Text(
                    'Activate CyberShield',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                const Center(
                  child: Text(
                    'Enable notification access to detect scam SMS, WhatsApp and Messenger alerts in real time.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kPermissionMuted,
                      fontSize: 14,
                      height: 1.45,
                    ),
                  ),
                ),

                const SizedBox(height: 26),

                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: _cardDecoration(),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.lock_outline_rounded,
                        color: kPermissionCyan,
                        size: 28,
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'CyberShield only reads notification text locally for scam detection. Your messages are not shown publicly.',
                          style: TextStyle(
                            color: kPermissionMuted,
                            fontSize: 13.5,
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 26),

                const Text(
                  'Quick Setup',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 14),

                const _StepTile(
                  index: '01',
                  title: 'Open Android Settings',
                  subtitle: 'We will take you directly to notification access.',
                ),

                const SizedBox(height: 12),

                const _StepTile(
                  index: '02',
                  title: 'Enable CyberShield',
                  subtitle: 'Turn on notification access permission.',
                ),

                const SizedBox(height: 12),

                const _StepTile(
                  index: '03',
                  title: 'Return to App',
                  subtitle: 'CyberShield will start monitoring alerts.',
                ),

                const SizedBox(height: 26),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await provider.openNotificationAccessSettings();
                      await Future<void>.delayed(
                        const Duration(milliseconds: 600),
                      );
                      await provider.refreshPermission();
                    },
                    icon: const Icon(Icons.settings_rounded),
                    label: const Text(
                      'Enable Protection',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPermissionCyan,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                Center(
                  child: Text(
                    provider.permissionEnabled
                        ? 'Protection permission is enabled.'
                        : 'Permission is disabled. Please enable it to continue.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: provider.permissionEnabled
                          ? Colors.greenAccent
                          : kPermissionMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  final String index;
  final String title;
  final String subtitle;

  const _StepTile({
    required this.index,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: kPermissionCyan.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: kPermissionCyan.withValues(alpha: 0.25),
              ),
            ),
            child: Text(
              index,
              style: const TextStyle(
                color: kPermissionCyan,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: kPermissionMuted,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white.withValues(alpha: 0.08),
    borderRadius: BorderRadius.circular(22),
    border: Border.all(
      color: Colors.white.withValues(alpha: 0.12),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.18),
        blurRadius: 18,
        offset: const Offset(0, 8),
      ),
    ],
  );
}