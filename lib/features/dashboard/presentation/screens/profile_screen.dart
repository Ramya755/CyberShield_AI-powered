import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cyber_shield/features/sms/presentation/providers/scam_detection_provider.dart';

const Color kProfileBgTop = Color(0xFF030B2D);
const Color kProfileBgBottom = Color(0xFF060C24);
const Color kProfileCyan = Color(0xFF42D7FF);
const Color kProfileViolet = Color(0xFF9A63FF);
const Color kProfileMuted = Color(0xFFAAB6D3);
const Color kProfileCard = Color(0x1AFFFFFF);

class ProfileScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onThemeChanged;

  const ProfileScreen({
    super.key,
    required this.isDark,
    required this.onThemeChanged,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> _editName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final controller = TextEditingController(text: user.displayName ?? '');

    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter your name',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (newName != null && newName.isNotEmpty) {
      await user.updateDisplayName(newName);
      if (!mounted) return;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }

  Future<void> _sendPasswordReset() async {
    final email = FirebaseAuth.instance.currentUser?.email;

    if (email == null) return;

    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password reset email sent successfully'),
      ),
    );
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final displayName = user?.displayName?.isNotEmpty == true
        ? user!.displayName!
        : 'CyberShield User';

    final email = user?.email ?? 'No email found';

    return Scaffold(
      backgroundColor: kProfileBgBottom,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kProfileBgTop, kProfileBgBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Consumer<ScamDetectionProvider>(
            builder: (context, provider, _) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Manage your identity, protection and security status',
                      style: TextStyle(
                        color: kProfileMuted,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 22),

                    _ProfileHeader(
                      displayName: displayName,
                      email: email,
                      onEdit: _editName,
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'Threats',
                            value: provider.totalThreats.toString(),
                            icon: Icons.warning_amber_rounded,
                            color: Colors.redAccent,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            title: 'High Risk',
                            value: provider.highRiskThreats.toString(),
                            icon: Icons.local_fire_department_rounded,
                            color: Colors.orangeAccent,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'Medium',
                            value: provider.mediumRiskThreats.toString(),
                            icon: Icons.shield_moon_rounded,
                            color: kProfileCyan,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            title: 'Status',
                            value: provider.isProtectionEnabled ? 'ON' : 'OFF',
                            icon: Icons.verified_user_rounded,
                            color: Colors.greenAccent,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    const _SectionTitle(title: 'Protection Controls'),

                    const SizedBox(height: 12),

                    _ActionTile(
                      icon: Icons.dark_mode_rounded,
                      title: widget.isDark ? 'Dark Mode Enabled' : 'Light Mode Enabled',
                      subtitle: 'Tap to switch app theme',
                      trailing: Switch(
                        value: widget.isDark,
                        onChanged: (_) => widget.onThemeChanged(),
                      ),
                      onTap: widget.onThemeChanged,
                    ),

                    const SizedBox(height: 12),

                    _ActionTile(
                      icon: Icons.password_rounded,
                      title: 'Reset Password',
                      subtitle: 'Send password reset link to your email',
                      onTap: _sendPasswordReset,
                    ),

                    const SizedBox(height: 12),

                    _ActionTile(
                      icon: Icons.info_outline_rounded,
                      title: 'About CyberShield',
                      subtitle: 'AI-powered SMS and link scam detection',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AboutScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 26),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _logout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        icon: const Icon(Icons.logout_rounded),
                        label: const Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String displayName;
  final String email;
  final VoidCallback onEdit;

  const _ProfileHeader({
    required this.displayName,
    required this.email,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            height: 76,
            width: 76,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [kProfileCyan, kProfileViolet],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 42,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: kProfileMuted,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 10),
                const Row(
                  children: [
                    Icon(
                      Icons.shield_rounded,
                      color: Colors.greenAccent,
                      size: 18,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'CyberShield Active',
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(
              Icons.edit_rounded,
              color: kProfileCyan,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: kProfileMuted,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration(),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            color: kProfileCyan.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: kProfileCyan),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: kProfileMuted),
        ),
        trailing: trailing ??
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: kProfileMuted,
              size: 16,
            ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: kProfileCard,
    borderRadius: BorderRadius.circular(22),
    border: Border.all(
      color: Colors.white.withValues(alpha: 0.16),
    ),
    boxShadow: [
      BoxShadow(
        color: kProfileCyan.withValues(alpha: 0.08),
        blurRadius: 18,
        offset: const Offset(0, 8),
      ),
    ],
  );
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kProfileBgBottom,
      appBar: AppBar(
        backgroundColor: kProfileBgBottom,
        title: const Text('About CyberShield'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'CyberShield is an AI-powered cybersecurity app that detects suspicious SMS notifications and unsafe links using Flutter, TFLite, Realm, Firebase and MongoDB.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            height: 1.6,
          ),
        ),
      ),
    );
  }
}