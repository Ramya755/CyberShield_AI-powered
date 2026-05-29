import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cyber_shield/features/links/presentation/provider/scanner_provider.dart';
import 'package:cyber_shield/features/report/presentation/controllers/report_controller.dart';
import 'features/dashboard/presentation/providers/auth_provider.dart';
import 'features/dashboard/presentation/screens/login_screen.dart';
import 'features/dashboard/presentation/screens/main_screen.dart';
import 'features/sms/presentation/providers/scam_detection_provider.dart';
import 'features/sms/data/local/realm/repositories/scam_detection_realm_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'features/sms/data/local/notifications/providers/notification_listener_provider.dart';
import 'features/sms/data/local/notifications/presentation/notification_permission_gate.dart';
import 'features/sms/data/local/notifications/notification_service.dart';
import 'package:cyber_shield/core/shared/navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await NotificationService.initialize();

  runApp(const CyberShieldApp());
}

class CyberShieldApp extends StatelessWidget {
  const CyberShieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) => NotificationListenerProvider(
                realmRepository: ScamDetectionRealmRepository(),
              ),
        ),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ScannerProvider()),
        ChangeNotifierProvider(create: (_) => ReportController()),
        ChangeNotifierProvider(
          create:
              (_) => ScamDetectionProvider(
                repository: ScamDetectionRealmRepository(),
              ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CyberShield',
        navigatorKey: navigatorKey,
        theme: ThemeData.dark(),
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.isLoggedIn) {
      return NotificationPermissionGate(
        child: MainScreen(isDark: true, onThemeChanged: () {}),
      );
    }

    return const LoginScreen();
  }
}
