import 'package:flutter/material.dart';
import 'package:cyber_shield/main.dart'; // for AuthGate

// ─────────────────────────────────────────────
//  CyberShield — Animated Splash Screen
//  Navigation: SplashScreen → AuthGate
//  AuthGate then decides: MainScreen or LoginScreen
//  based on AuthProvider.isLoggedIn (unchanged)
// ─────────────────────────────────────────────

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ── Brand colours (match your app exactly) ──
  static const Color _navyTop    = Color(0xFF030B2D);
  static const Color _navyBottom = Color(0xFF060C24);
  static const Color _cyan       = Color(0xFF42D7FF);
  static const Color _violet     = Color(0xFF9A63FF);
  static const Color _mutedText  = Color(0xFFAAB6D3);

  // ── Animation controllers ──
  late final AnimationController _shieldCtrl;   // shield fade + scale
  late final AnimationController _pulseCtrl;    // glow ring pulse (repeating)
  late final AnimationController _textCtrl;     // title + subtitle slide-in
  late final AnimationController _subtitleCtrl; // subtitle slight delay
  late final AnimationController _footerCtrl;   // bottom "Initializing…" fade

  // ── Shield animations ──
  late final Animation<double> _shieldFade;
  late final Animation<double> _shieldScale;

  // ── Pulse ring animations ──
  late final Animation<double> _pulseScale;
  late final Animation<double> _pulseOpacity;

  // ── Title animations ──
  late final Animation<double>   _titleFade;
  late final Animation<Offset>   _titleSlide;

  // ── Subtitle animations ──
  late final Animation<double>   _subtitleFade;
  late final Animation<Offset>   _subtitleSlide;

  // ── Footer animation ──
  late final Animation<double> _footerFade;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startSequence();
  }

  void _setupAnimations() {
    // ── 1. Shield: fades + scales in over 700 ms ──
    _shieldCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _shieldFade = CurvedAnimation(
      parent: _shieldCtrl,
      curve: Curves.easeOut,
    );
    _shieldScale = Tween<double>(begin: 0.55, end: 1.0).animate(
      CurvedAnimation(parent: _shieldCtrl, curve: Curves.elasticOut),
    );

    // ── 2. Pulse ring: repeating scale + fade (glow effect) ──
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _pulseScale = Tween<double>(begin: 1.0, end: 1.28).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
    _pulseOpacity = Tween<double>(begin: 0.55, end: 0.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    // ── 3. Title slides up + fades in ──
    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _titleFade = CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut);
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeOutCubic));

    // ── 4. Subtitle slides up slightly after title ──
    _subtitleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _subtitleFade = CurvedAnimation(
      parent: _subtitleCtrl,
      curve: Curves.easeOut,
    );
    _subtitleSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _subtitleCtrl, curve: Curves.easeOutCubic),
    );

    // ── 5. Footer "Initializing…" fades in last ──
    _footerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _footerFade = CurvedAnimation(parent: _footerCtrl, curve: Curves.easeIn);
  }

  Future<void> _startSequence() async {
    // Step 1 – Shield appears
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    _shieldCtrl.forward();

    // Step 2 – Title slides in after shield is mostly visible
    await Future.delayed(const Duration(milliseconds: 550));
    if (!mounted) return;
    _textCtrl.forward();

    // Step 3 – Subtitle follows title
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    _subtitleCtrl.forward();

    // Step 4 – Footer hint
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    _footerCtrl.forward();

    // Step 5 – Navigate after total ~2.8 s from start
    await Future.delayed(const Duration(milliseconds: 1050));
    if (!mounted) return;
    _navigate();
  }

  void _navigate() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => const AuthGate(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeIn),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _shieldCtrl.dispose();
    _pulseCtrl.dispose();
    _textCtrl.dispose();
    _subtitleCtrl.dispose();
    _footerCtrl.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _navyTop,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_navyTop, _navyBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Main centred content ──
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildShieldWithGlow(),
                    const SizedBox(height: 36),
                    _buildTitle(),
                    const SizedBox(height: 10),
                    _buildSubtitle(),
                  ],
                ),
              ),

              // ── Footer hint ──
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  SHIELD + GLOW RINGS
  // ─────────────────────────────────────────────
  Widget _buildShieldWithGlow() {
    return ScaleTransition(
      scale: _shieldScale,
      child: FadeTransition(
        opacity: _shieldFade,
        child: SizedBox(
          width: 160,
          height: 160,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // ── Outer pulse ring ──
              AnimatedBuilder(
                animation: _pulseCtrl,
                builder: (_, __) {
                  return Transform.scale(
                    scale: _pulseScale.value,
                    child: Container(
                      width: 148,
                      height: 148,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _cyan.withOpacity(
                            _pulseOpacity.value * 0.7,
                          ),
                          width: 1.5,
                        ),
                      ),
                    ),
                  );
                },
              ),

              // ── Second pulse ring (violet, slightly offset phase) ──
              AnimatedBuilder(
                animation: _pulseCtrl,
                builder: (_, __) {
                  // Invert phase for violet ring so they alternate
                  final invertedValue = 1.0 - _pulseCtrl.value;
                  final scale = 1.0 + (invertedValue * 0.22);
                  final opacity = (1.0 - invertedValue) * 0.45;
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 148,
                      height: 148,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _violet.withOpacity(opacity),
                          width: 1.5,
                        ),
                      ),
                    ),
                  );
                },
              ),

              // ── Glow background circle ──
              AnimatedBuilder(
                animation: _pulseCtrl,
                builder: (_, __) {
                  return Container(
                    width: 112,
                    height: 112,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          _cyan.withOpacity(
                            0.12 + (_pulseCtrl.value * 0.08),
                          ),
                          _violet.withOpacity(
                            0.08 + ((1 - _pulseCtrl.value) * 0.06),
                          ),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  );
                },
              ),

              // ── Solid circle background ──
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0D1B4B), Color(0xFF080F2E)],
                  ),
                  border: Border.all(
                    color: _cyan.withOpacity(0.35),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _cyan.withOpacity(0.18),
                      blurRadius: 24,
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: _violet.withOpacity(0.14),
                      blurRadius: 16,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),

              // ── Shield icon ──
              ShaderMask(
                shaderCallback:
                    (bounds) => const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [_cyan, _violet],
                    ).createShader(bounds),
                child: const Icon(
                  Icons.security_rounded,
                  size: 46,
                  color: Colors.white, // overridden by ShaderMask
                ),
              ),

              // ── Small cyan scan-line decoration ──
              Positioned(
                bottom: 28,
                left: 32,
                right: 32,
                child: AnimatedBuilder(
                  animation: _pulseCtrl,
                  builder: (_, __) {
                    return Opacity(
                      opacity: 0.3 + (_pulseCtrl.value * 0.3),
                      child: Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              _cyan.withOpacity(0.8),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  APP NAME
  // ─────────────────────────────────────────────
  Widget _buildTitle() {
    return SlideTransition(
      position: _titleSlide,
      child: FadeTransition(
        opacity: _titleFade,
        child: ShaderMask(
          shaderCallback:
              (bounds) => const LinearGradient(
                colors: [Colors.white, Color(0xFFDDE8FF)],
              ).createShader(bounds),
          child: const Text(
            'CyberShield',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  SUBTITLE
  // ─────────────────────────────────────────────
  Widget _buildSubtitle() {
    return SlideTransition(
      position: _subtitleSlide,
      child: FadeTransition(
        opacity: _subtitleFade,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Cyan dot accent
            Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: _cyan,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'AI-Powered Scam Protection',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: _mutedText,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: _violet,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  FOOTER
  // ─────────────────────────────────────────────
  Widget _buildFooter() {
    return FadeTransition(
      opacity: _footerFade,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 12,
              height: 12,
              child: AnimatedBuilder(
                animation: _pulseCtrl,
                builder: (_, __) {
                  return CircularProgressIndicator(
                    strokeWidth: 1.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _cyan.withOpacity(0.5 + (_pulseCtrl.value * 0.5)),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Initializing protection…',
              style: TextStyle(
                fontSize: 11.5,
                color: _mutedText,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
