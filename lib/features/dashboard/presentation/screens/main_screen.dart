
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cyber_shield/features/dashboard/presentation/screens/profile_screen.dart';
import 'package:cyber_shield/features/links/presentation/screens/link_scanner_screen.dart';
import 'package:cyber_shield/features/report/presentation/screens/report_screen.dart';
import 'package:cyber_shield/features/sms/presentation/detection_history_screen.dart';
import 'package:cyber_shield/features/sms/presentation/providers/scam_detection_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
    required this.isDark,
    required this.onThemeChanged,
  });

  final bool isDark;
  final VoidCallback onThemeChanged;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeScreen(),
      const DetectionHistoryScreen(),
      const LinkScannerScreen(),
      const ReportScreen(),
      ProfileScreen(
        isDark: widget.isDark,
        onThemeChanged: widget.onThemeChanged,
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: screens),
      bottomNavigationBar: Container(
        height: 75,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border(
            top: BorderSide(color: Colors.blueGrey.withValues(alpha: 0.3)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            navItem(Icons.home_outlined, 'Home', 0),
            navItem(Icons.warning_amber_rounded, 'Threats', 1),
            navItem(Icons.link, 'Links', 2),
            navItem(Icons.info_outline, 'Report', 3),
            navItem(Icons.person_outline, 'Profile', 4),
          ],
        ),
      ),
    );
  }

  Widget navItem(IconData icon, String title, int index) {
    final active = selectedIndex == index;

    return InkWell(
      onTap: () => setState(() => selectedIndex = index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: active ? Colors.blue : Colors.grey, size: 25),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: active ? Colors.blue : Colors.grey,
              fontSize: 12,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

// ================= HOME SCREEN =================

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Scaffold(
      body: SafeArea(
        child: Consumer<ScamDetectionProvider>(
          builder: (context, provider, _) {
            final threats = provider.messages.length;
            final highRisk =
                provider.messages.where((m) => m.riskScore >= 80).length;

            final score =
                threats == 0 ? 100 : (100 - (highRisk * 10)).clamp(0, 100);

            final latest = provider.recentDetections;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello,\nStay Safe Today!',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildScoreCard(score, threats, highRisk),
                  const SizedBox(height: 30),
                  const Text(
                    'Recent Scam Detections',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  if (latest.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text("No scam detections yet."),
                      ),
                    )
                  else
                    Column(
                      children: latest.map((item) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Color(0x33FF5252),
                              child: Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.redAccent,
                              ),
                            ),
                            title: Text(
                              item.message,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "${_friendlyAppName(item.appName)} • Risk Score: ${item.riskScore}/100",
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildScoreCard(int score, int threats, int highRisk) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text('CyberShield Score', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 28),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 170,
                    width: 170,
                    child: CircularProgressIndicator(
                      value: score / 100,
                      strokeWidth: 18,
                      backgroundColor: Colors.grey.withValues(alpha: 0.2),
                      color: score >= 80
                          ? Colors.green
                          : score >= 50
                              ? Colors.orange
                              : Colors.red,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$score',
                        style: const TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'out of 100',
                        style: TextStyle(color: Colors.blue, fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Text(
                'Threats: $threats | High Risk: $highRisk',
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _friendlyAppName(String appName) {
    switch (appName.toLowerCase()) {
      case 'com.whatsapp':
        return 'WhatsApp';
      case 'com.facebook.orca':
        return 'Messenger';
      case 'com.google.android.apps.messaging':
        return 'Messages';
      default:
        return appName;
    }
  }
}
