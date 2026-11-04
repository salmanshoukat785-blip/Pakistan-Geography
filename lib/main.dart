import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const ArabicGrammarApp());

const Color kGreen = Color(0xFF0B6E4F);
const Color kDarkGreen = Color(0xFF064E3B);
const Color kGold = Color(0xFFD4A017);

class ArabicGrammarApp extends StatelessWidget {
  const ArabicGrammarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arabic Grammar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: kGreen),
      ),
      home: const SplashScreen(),
    );
  }
}

/// App logo drawn with code (no image file needed).
class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, this.size = 140});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: kGold, width: size * 0.04),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, 6)),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        'ع',
        style: TextStyle(
          fontSize: size * 0.62,
          color: kGreen,
          fontWeight: FontWeight.bold,
          height: 1.1,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- Splash
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..forward();
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _timer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kGreen, kDarkGreen],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FadeTransition(
          opacity: _fade,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              AppLogo(size: 160),
              SizedBox(height: 24),
              Text(
                'Arabic Grammar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'قواعد اللغة العربية',
                style: TextStyle(color: kGold, fontSize: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------ Onboarding
class OnboardData {
  final IconData icon;
  final String arabic;
  final String titleEn;
  final String titleUr;
  final String bodyEn;
  final String bodyUr;
  const OnboardData({
    required this.icon,
    required this.arabic,
    required this.titleEn,
    required this.titleUr,
    required this.bodyEn,
    required this.bodyUr,
  });
}

const List<OnboardData> kPages = [
  OnboardData(
    icon: Icons.waving_hand_rounded,
    arabic: 'السلام عليكم',
    titleEn: 'Assalamu Alaikum! Welcome',
    titleUr: 'السلام علیکم! خوش آمدید',
    bodyEn: 'Welcome to Arabic Grammar. Learn the Arabic language step by step.',
    bodyUr: 'عربی گرامر میں خوش آمدید۔ عربی زبان قدم بہ قدم سیکھیں۔',
  ),
  OnboardData(
    icon: Icons.menu_book_rounded,
    arabic: 'تعلم القواعد',
    titleEn: 'Learn Grammar Easily',
    titleUr: 'گرامر آسانی سے سیکھیں',
    bodyEn: 'Simple lessons on nouns, verbs, particles and sentence structure.',
    bodyUr: 'اسم، فعل، حرف اور جملے کی ساخت پر آسان اسباق۔',
  ),
  OnboardData(
    icon: Icons.emoji_events_rounded,
    arabic: 'ابدأ الآن',
    titleEn: 'Practice & Improve',
    titleUr: 'مشق کریں اور بہتر بنیں',
    bodyEn: 'Practice every day and track your progress. Let\'s begin!',
    bodyUr: 'روزانہ مشق کریں اور اپنی ترقی دیکھیں۔ چلیں شروع کریں!',
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  bool get _isLast => _index == kPages.length - 1;

  void _goToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _next() {
    if (_isLast) {
      _goToLogin();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button (hidden on last page, space kept)
            SizedBox(
              height: 52,
              child: Align(
                alignment: Alignment.centerRight,
                child: _isLast
                    ? const SizedBox.shrink()
                    : TextButton(
                        onPressed: _goToLogin,
                        child: const Text('Skip',
                            style: TextStyle(fontSize: 16, color: kGreen)),
                      ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: kPages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (_, i) => _OnboardPage(data: kPages[i]),
              ),
            ),
            // Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(kPages.length, (i) {
                final active = i == _index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active ? kGreen : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _next,
                  child: Text(
                    _isLast ? 'Get Started' : 'Next',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardPage extends StatelessWidget {
  final OnboardData data;
  const _OnboardPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kGreen.withOpacity(0.1),
              ),
              child: Icon(data.icon, size: 72, color: kGreen),
            ),
            const SizedBox(height: 24),
            Text(
              data.arabic,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 34, color: kGold, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              data.titleEn,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: kDarkGreen),
            ),
            const SizedBox(height: 6),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                data.titleUr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: kDarkGreen),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              data.bodyEn,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 8),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                data.bodyUr,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------- Login
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                const AppLogo(size: 100),
                const SizedBox(height: 16),
                const Text('Login',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: kDarkGreen)),
                const SizedBox(height: 24),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    ),
                    child: const Text('Login',
                        style: TextStyle(fontSize: 18)),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  ),
                  child: const Text('Continue as Guest',
                      style: TextStyle(color: kGreen)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------ Home
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kGreen,
        foregroundColor: Colors.white,
        title: const Text('Arabic Grammar'),
      ),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppLogo(size: 110),
            SizedBox(height: 16),
            Text('السلام علیکم! Home Screen',
                style: TextStyle(fontSize: 20, color: kDarkGreen)),
          ],
        ),
      ),
    );
  }
}
