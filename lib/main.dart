import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String kNameKey = 'user_name';

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
      padding: EdgeInsets.all(size * 0.16),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          'القرآن',
          style: TextStyle(
            fontSize: size * 0.34,
            color: kGreen,
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
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
    _timer = Timer(const Duration(seconds: 3), _next);
  }

  Future<void> _next() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(kNameKey);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => (name != null && name.isNotEmpty)
            ? HomeScreen(name: name)
            : const OnboardingScreen(),
      ),
    );
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
/// Only a name is asked. It is saved on the phone so it can be used later
/// for scoring / progress.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? _error;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Please enter your name / اپنا نام لکھیں');
      return;
    }
    setState(() {
      _error = null;
      _saving = true;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kNameKey, name);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => HomeScreen(name: name)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                const AppLogo(size: 150),
                const SizedBox(height: 20),
                const Text('Welcome',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: kDarkGreen)),
                const SizedBox(height: 6),
                Text('اپنا نام لکھیں',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade700)),
                const SizedBox(height: 24),
                TextField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _continue(),
                  decoration: InputDecoration(
                    labelText: 'Name / نام',
                    errorText: _error,
                    prefixIcon: const Icon(Icons.person_outline),
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
                    onPressed: _saving ? null : _continue,
                    child: const Text('Continue',
                        style: TextStyle(fontSize: 18)),
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

// ------------------------------------------------------------------ Home
class HomeScreen extends StatelessWidget {
  final String name;
  const HomeScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kGreen,
        foregroundColor: Colors.white,
        title: const Text('Arabic Grammar'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppLogo(size: 130),
            const SizedBox(height: 16),
            Text('السلام علیکم، $name',
                style: const TextStyle(fontSize: 22, color: kDarkGreen)),
            const SizedBox(height: 6),
            Text('Home Screen',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}
