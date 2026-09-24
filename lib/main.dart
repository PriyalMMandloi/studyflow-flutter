import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'firebase_options.dart';

Future<void>? _revenueCatReady;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  const revenueCatApiKey = String.fromEnvironment(
    'REVENUECAT_ANDROID_API_KEY',
  );

  runApp(const StudyFlowApp());
  _revenueCatReady = _configureRevenueCat(revenueCatApiKey);
  unawaited(_revenueCatReady!);
}

Future<void> _configureRevenueCat(String apiKey) async {
  try {
    if (apiKey.isEmpty) return;

    if (!await Purchases.isConfigured) {
      await Purchases.configure(PurchasesConfiguration(apiKey));
    }

  } catch (_) {
  }
}

Future<void> _syncRevenueCatUser(User? user) async {
  try {
    final ready = _revenueCatReady;
    if (ready == null) return;
    await ready;
    if (!await Purchases.isConfigured) return;

    if (user == null) {
      await Purchases.logOut();
    } else {
      await Purchases.logIn(user.uid);
    }
  } catch (_) {
  }
}

Future<void> _logOutRevenueCat() async {
  try {
    final ready = _revenueCatReady;
    if (ready == null) return;
    await ready;
    if (!await Purchases.isConfigured) return;

    await Purchases.logOut();
  } catch (_) {
  }
}

class MyApp extends StudyFlowApp {
  const MyApp({super.key});
}

class StudyFlowApp extends StatelessWidget {
  const StudyFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: StudyFlowThemeController.instance,
      builder: (context, themeMode, _) => MaterialApp(
        title: 'StudyFlow',
        debugShowCheckedModeBanner: false,
        theme: StudyFlowTheme.lightTheme,
        darkTheme: StudyFlowTheme.lightTheme,
        themeMode: themeMode,
        home: const AuthGate(),
      ),
    );
  }
}

class StudyFlowThemeController extends ValueNotifier<ThemeMode> {
  StudyFlowThemeController._() : super(ThemeMode.light);
  static final instance = StudyFlowThemeController._();
}

class StudyFlowTheme {
  static const Color backgroundLight = Color(0xFFF4F6F2);
  static const Color backgroundWarm = Color(0xFFF8F5F1);
  static const Color glassFill = Color(0xCCFFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color sage = Color(0xFF5C8D72);
  static const Color sageStrong = Color(0xFF3F7758);
  static const Color sageSoft = Color(0xFFEAF5EE);
  static const Color mint = Color(0xFFBFE6D1);
  static const Color charcoal = Color(0xFF1B2A22);
  static const Color muted = Color(0xFF607067);
  static const Color cream = Color(0xFFF9F7F3);
  static const Color amber = Color(0xFFE9B85D);
  static const Color danger = Color(0xFFDA6A5D);

  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: backgroundLight,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: sage,
        brightness: Brightness.light,
        primary: sage,
        secondary: sageStrong,
        surface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: charcoal,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.55),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: TextStyle(color: muted.withValues(alpha: 0.7), fontSize: 14),
        labelStyle: const TextStyle(color: muted, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          borderSide: BorderSide(color: Color(0x1F647067)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          borderSide: BorderSide(color: Color(0x1F647067)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          borderSide: BorderSide(color: sage, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          borderSide: BorderSide(color: danger, width: 1.2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: sage,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        indicatorColor: const Color(0xFFD8E9DE),
        labelTextStyle: WidgetStatePropertyAll(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ),
    );

    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        headlineLarge: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: charcoal, letterSpacing: -0.9),
        headlineMedium: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: charcoal, letterSpacing: -0.7),
        titleLarge: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: charcoal),
        titleMedium: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: charcoal),
        bodyLarge: const TextStyle(fontSize: 16, color: charcoal),
        bodyMedium: const TextStyle(fontSize: 14, color: charcoal),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white.withValues(alpha: 0.75),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        titleTextStyle: const TextStyle(
          color: charcoal,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xCC1F2B25),
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}

class StudyFlowBackground extends StatelessWidget {
  final Widget child;
  const StudyFlowBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            StudyFlowTheme.backgroundWarm,
            StudyFlowTheme.backgroundLight,
            Color(0xFFEFF5F0),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -60,
            right: -40,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: const Color(0xFFDBEEDC).withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(110),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: const Color(0xFFE8E2D6).withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(90),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBack;
  const GlassAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBack = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      automaticallyImplyLeading: showBack,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      actions: actions,
    );
  }
}

class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double radius;
  final bool blur;
  final Color? color;
  final List<BoxShadow>? boxShadow;
  final Border? border;
  const GlassContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.radius = 28,
    this.blur = true,
    this.color,
    this.boxShadow,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Colors.white.withValues(alpha: 0.38);
    final decoration = BoxDecoration(
      color: effectiveColor,
      borderRadius: BorderRadius.circular(radius),
      border: border ?? Border.all(color: const Color(0x26FFFFFF), width: 1),
      boxShadow: boxShadow ?? [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ],
    );

    final content = Container(
      margin: margin,
      padding: padding,
      decoration: decoration,
      child: child,
    );

    if (!blur) return content;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: content,
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double radius;
  final Color? color;
  final VoidCallback? onTap;
  final Border? border;
  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.radius = 24,
    this.color,
    this.onTap,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final card = GlassContainer(
      padding: padding ?? const EdgeInsets.all(18),
      margin: margin,
      radius: radius,
      color: color ?? Colors.white.withValues(alpha: 0.42),
      border: border ?? Border.all(color: const Color(0x3DFFFFFF), width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.03),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ],
      child: child,
    );

    if (onTap == null) return card;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onTap,
        child: card,
      ),
    );
  }
}

class GlassButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool filled;
  final bool fullWidth;
  final double height;
  const GlassButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.filled = true,
    this.fullWidth = true,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    final button = FilledButton.icon(
      onPressed: onPressed,
      icon: icon == null ? const SizedBox.shrink() : Icon(icon),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: filled ? StudyFlowTheme.sage : Colors.white.withValues(alpha: 0.45),
        foregroundColor: filled ? Colors.white : StudyFlowTheme.charcoal,
        minimumSize: Size.fromHeight(height),
        side: filled ? null : const BorderSide(color: Color(0x2A5C8D72), width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );

    if (!fullWidth) {
      return button;
    }

    return SizedBox(width: double.infinity, child: button);
  }
}

class GlassTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;
  const GlassTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final TextAlign? textAlign;
  const SectionHeader({super.key, required this.title, this.subtitle, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.4)),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(subtitle!, style: TextStyle(color: StudyFlowTheme.muted, fontSize: 12.5, fontWeight: FontWeight.w600), textAlign: textAlign),
        ],
      ],
    );
  }
}

class StudyFlowNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  const StudyFlowNavBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      child: GlassContainer(
        radius: 30,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        color: Colors.white.withValues(alpha: 0.34),
        child: NavigationBar(
          height: 70,
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          backgroundColor: Colors.transparent,
          indicatorColor: const Color(0xFFE2F0E5),
          indicatorShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 0,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined, size: 22), selectedIcon: Icon(Icons.home_rounded, size: 22), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.calendar_today_outlined, size: 22), selectedIcon: Icon(Icons.calendar_today_rounded, size: 22), label: 'Plan'),
            NavigationDestination(icon: Icon(Icons.timer_outlined, size: 22), selectedIcon: Icon(Icons.timer_rounded, size: 22), label: 'Focus'),
            NavigationDestination(icon: Icon(Icons.sticky_note_2_outlined, size: 22), selectedIcon: Icon(Icons.sticky_note_2_rounded, size: 22), label: 'Notes'),
            NavigationDestination(icon: Icon(Icons.grid_view_outlined, size: 22), selectedIcon: Icon(Icons.grid_view_rounded, size: 22), label: 'More'),
          ],
        ),
      ),
    );
  }
}

class ProgressPill extends StatelessWidget {
  final String text;
  final Color? color;
  const ProgressPill({super.key, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: (color ?? StudyFlowTheme.sageSoft).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color == null ? StudyFlowTheme.sageStrong : Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.05,
        ),
      ),
    );
  }
}

class ProgressRing extends StatelessWidget {
  final double value;
  final double size;
  final double strokeWidth;
  final Color? color;
  final String? label;
  const ProgressRing({
    super.key,
    required this.value,
    this.size = 110,
    this.strokeWidth = 10,
    this.color,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final ringColor = color ?? StudyFlowTheme.sageStrong;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: value.clamp(0.0, 1.0),
              strokeWidth: strokeWidth,
              backgroundColor: const Color(0xFFE7EEE9),
              valueColor: AlwaysStoppedAnimation<Color>(ringColor),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${(value * 100).round()}%', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: StudyFlowTheme.charcoal)),
              if (label != null) ...[
                const SizedBox(height: 3),
                Text(label!, style: TextStyle(color: StudyFlowTheme.muted, fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class StatTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color? accent;
  const StatTile({super.key, required this.icon, required this.value, required this.label, this.accent});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: (accent ?? StudyFlowTheme.sageSoft).withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: accent == null ? StudyFlowTheme.sageStrong : Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, letterSpacing: -0.4)),
                Text(label, style: TextStyle(color: StudyFlowTheme.muted, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StudyFlowData extends ChangeNotifier {
  StudyFlowData._();
  static final StudyFlowData instance = StudyFlowData._();

  int goalMinutes = 120;
  int completedMinutes = 0;
  int completedTasks = 0;

  final List<int> weeklyMinutes = List<int>.filled(7, 0);
  final Map<DateTime, int> _activityCounts = {};

  DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  void _updateActivity(DateTime date, int change) {
    final day = _dateOnly(date);
    final count = (_activityCounts[day] ?? 0) + change;
    if (count > 0) {
      _activityCounts[day] = count;
    } else {
      _activityCounts.remove(day);
    }
  }

  bool hasActivityOn(DateTime date) =>
      (_activityCounts[_dateOnly(date)] ?? 0) > 0;

  int get currentStreak {
    final today = _dateOnly(DateTime.now());
    if (!hasActivityOn(today)) return 0;

    var streak = 0;
    var day = today;
    while (hasActivityOn(day)) {
      streak++;
      day = day.subtract(const Duration(days: 1));
    }
    return streak;
  }

  int get longestStreak {
    if (_activityCounts.isEmpty) return 0;

    final dates = _activityCounts.keys.toList()..sort();
    var longest = 1;
    var streak = 1;
    for (var i = 1; i < dates.length; i++) {
      if (dates[i].difference(dates[i - 1]).inDays == 1) {
        streak++;
        if (streak > longest) longest = streak;
      } else {
        streak = 1;
      }
    }
    return longest;
  }

  void setGoal(int minutes) {
    goalMinutes = minutes;
    notifyListeners();
  }

  void recordTask({required bool completed, required int minutes}) {
    final dayIndex = DateTime.now().weekday - 1;
    if (completed) {
      completedTasks++;
      completedMinutes += minutes;
      weeklyMinutes[dayIndex] += minutes;
      _updateActivity(DateTime.now(), 1);
    } else {
      if (completedTasks > 0) completedTasks--;
      completedMinutes = (completedMinutes - minutes).clamp(0, 100000).toInt();
      weeklyMinutes[dayIndex] =
          (weeklyMinutes[dayIndex] - minutes).clamp(0, 100000).toInt();
      _updateActivity(DateTime.now(), -1);
    }
    notifyListeners();
  }

  void recordFocusSession(int minutes) {
    completedMinutes += minutes;
    weeklyMinutes[DateTime.now().weekday - 1] += minutes;
    _updateActivity(DateTime.now(), 1);
    notifyListeners();
  }

  double get goalProgress =>
      goalMinutes <= 0 ? 0.0 : (completedMinutes / goalMinutes).clamp(0.0, 1.0).toDouble();
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  StreamSubscription<User?>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen(
      _syncRevenueCatUser,
    );
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasData) {
          return const MainNavigation();
        }

        return const LoginScreen();
      },
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  bool _loading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage(
        'Please enter your email and password.',
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      _showMessage(_authMessage(e));
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _forgotPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showMessage(
        'Enter your email first.',
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );

      _showMessage(
        'Password reset email sent. Check your inbox.',
      );
    } on FirebaseAuthException catch (e) {
      _showMessage(_authMessage(e));
    }
  }

  String _authMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';

      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Incorrect email or password.';

      case 'user-disabled':
        return 'This account has been disabled.';

      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';

      default:
        return e.message ??
            'Something went wrong. Please try again.';
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StudyFlowBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: GlassContainer(
                  radius: 32,
                  padding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 78,
                          height: 78,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFB9D8C0), Color(0xFF85B998)],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF7FA991).withValues(alpha: 0.25),
                                blurRadius: 18,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.menu_book_rounded, size: 38, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Text('Welcome back', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, letterSpacing: -0.8)),
                      const SizedBox(height: 8),
                      Text('Sign in to continue your StudyFlow journey.', style: TextStyle(color: StudyFlowTheme.muted, fontSize: 15, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 28),
                      GlassTextField(
                        controller: _emailController,
                        labelText: 'Email',
                        hintText: 'you@example.com',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        prefixIcon: const Icon(Icons.email_outlined, color: StudyFlowTheme.sageStrong),
                      ),
                      const SizedBox(height: 16),
                      GlassTextField(
                        controller: _passwordController,
                        labelText: 'Password',
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _login(),
                        prefixIcon: const Icon(Icons.lock_outline, color: StudyFlowTheme.sageStrong),
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: StudyFlowTheme.muted),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _loading ? null : _forgotPassword,
                          child: const Text('Forgot password?', style: TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton(
                          onPressed: _loading ? null : _login,
                          style: FilledButton.styleFrom(
                            backgroundColor: StudyFlowTheme.sage,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          ),
                          child: _loading
                              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Text('Sign In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: TextButton(
                          onPressed: _loading ? null : () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpScreen()));
                          },
                          child: const Text('New to StudyFlow? Create an account', style: TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() =>
      _SignUpScreenState();
}

class _SignUpScreenState
    extends State<SignUpScreen> {
  final TextEditingController _nameController =
      TextEditingController();

  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  final TextEditingController _confirmController =
      TextEditingController();

  bool _loading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirm.isEmpty) {
      _showMessage(
        'Please fill in all fields.',
      );
      return;
    }

    if (password.length < 6) {
      _showMessage(
        'Password must be at least 6 characters.',
      );
      return;
    }

    if (password != confirm) {
      _showMessage(
        'Passwords do not match.',
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final credential =
          await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user?.updateDisplayName(
        name,
      );

      if (mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      _showMessage(_authMessage(e));
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  String _authMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';

      case 'email-already-in-use':
        return 'An account already exists with this email.';

      case 'weak-password':
        return 'Choose a stronger password.';

      default:
        return e.message ??
            'Could not create the account.';
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StudyFlowBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const GlassAppBar(title: 'Create account', showBack: true),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: GlassContainer(
                radius: 32,
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Start your StudyFlow journey', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.7)),
                    const SizedBox(height: 8),
                    Text('Create your account to save your study progress.', style: TextStyle(color: StudyFlowTheme.muted, fontSize: 14.5, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 28),
                    GlassTextField(
                      controller: _nameController,
                      labelText: 'Name',
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(Icons.person_outline, color: StudyFlowTheme.sageStrong),
                    ),
                    const SizedBox(height: 16),
                    GlassTextField(
                      controller: _emailController,
                      labelText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(Icons.email_outlined, color: StudyFlowTheme.sageStrong),
                    ),
                    const SizedBox(height: 16),
                    GlassTextField(
                      controller: _passwordController,
                      labelText: 'Password',
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(Icons.lock_outline, color: StudyFlowTheme.sageStrong),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: StudyFlowTheme.muted),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GlassTextField(
                      controller: _confirmController,
                      labelText: 'Confirm password',
                      obscureText: _obscureConfirm,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _createAccount(),
                      prefixIcon: const Icon(Icons.lock_reset_outlined, color: StudyFlowTheme.sageStrong),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                        icon: Icon(_obscureConfirm ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: StudyFlowTheme.muted),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton(
                        onPressed: _loading ? null : _createAccount,
                        style: FilledButton.styleFrom(
                          backgroundColor: StudyFlowTheme.sage,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        ),
                        child: _loading
                            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Text('Create Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: TextButton(
                        onPressed: _loading ? null : () => Navigator.pop(context),
                        child: const Text('Already have an account? Sign in', style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    PlannerScreen(),
    FocusScreen(),
    NotesScreen(),
    MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return StudyFlowBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: StudyFlowNavBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() => _currentIndex = index);
            },
          ),
        ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _chapter1Completed = false;
  bool _chapter2Completed = false;
  bool _sqlCompleted = false;
  DateTime _selectedDate = DateTime.now();

  int get _completedTasks {
    int count = 0;
    if (_chapter1Completed) count++;
    if (_chapter2Completed) count++;
    if (_sqlCompleted) count++;
    return count;
  }

  double get _progress => _completedTasks / 3;

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Good morning';
    if (hour >= 12 && hour < 17) return 'Good afternoon';
    if (hour >= 17 && hour < 21) return 'Good evening';
    return 'Good night';
  }

  String _dateLabel() {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${weekdays[_selectedDate.weekday - 1]}, ${_selectedDate.day}';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: 'Choose a study date',
    );

    if (picked != null && mounted) {
      setState(() => _selectedDate = picked);
    }
  }

  void _openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
  }

  void _openFocus(String title, String subject, int minutes) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FocusScreen(
          taskTitle: title,
          subject: subject,
          durationMinutes: minutes,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final rawName = user?.displayName?.trim();
    final firstName = rawName != null && rawName.isNotEmpty ? rawName.split(' ').first : 'there';

    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 8),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${_greeting()} 👋', style: TextStyle(color: StudyFlowTheme.muted, fontSize: 14, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text('Hi, $firstName', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800, letterSpacing: -0.8, color: StudyFlowTheme.charcoal)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _openProfile,
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFFDDEFE2), Color(0xFFBFDCC6)]),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.75), width: 3),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 18, offset: const Offset(0, 10))],
                      ),
                      child: const Icon(Icons.person_rounded, color: StudyFlowTheme.sageStrong, size: 25),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            sliver: SliverToBoxAdapter(
              child: GestureDetector(
                onTap: _pickDate,
                child: GlassContainer(
                  radius: 20,
                  padding: const EdgeInsets.all(7),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 46,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF5EE),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          alignment: Alignment.center,
                          child: Text(_dateLabel(), style: const TextStyle(fontWeight: FontWeight.w800, color: StudyFlowTheme.sageStrong)),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text('Today', style: TextStyle(color: StudyFlowTheme.muted, fontWeight: FontWeight.w700)),
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down_rounded, size: 21, color: StudyFlowTheme.muted),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            sliver: SliverToBoxAdapter(
              child: GlassCard(
                radius: 30,
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                child: Row(
                  children: [
                    ProgressRing(value: _progress, size: 112, strokeWidth: 10, color: const Color(0xFF4F8D60)),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProgressPill(text: 'TODAY', color: Colors.white),
                          const SizedBox(height: 12),
                          const Text('Your study progress', style: TextStyle(color: StudyFlowTheme.charcoal, fontSize: 22, height: 1.05, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 8),
                          Text('$_completedTasks of 3 planned tasks completed', style: TextStyle(color: StudyFlowTheme.muted, fontSize: 12.5, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Quick actions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.4)),
                  Text('Stay consistent', style: TextStyle(color: StudyFlowTheme.muted, fontSize: 12, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(
                    child: GlassCard(
                      radius: 22,
                      onTap: () => _openFocus('Chapter 2 — IP', 'Information Practices', 45),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(width: 42, height: 42, decoration: BoxDecoration(color: const Color(0xFFEAF5EE), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.timer_rounded, color: StudyFlowTheme.sageStrong)),
                            const SizedBox(height: 13),
                            const Text('Focus', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 3),
                            Text('Start a session', style: TextStyle(fontSize: 11.5, color: StudyFlowTheme.muted, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlassCard(
                      radius: 22,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StudyStreakScreen())),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(width: 42, height: 42, decoration: BoxDecoration(color: const Color(0xFFFFF1D7), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.local_fire_department_rounded, color: Color(0xFFF0A13A))),
                            const SizedBox(height: 13),
                            const Text('7 days', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 3),
                            Text('Study streak', style: TextStyle(fontSize: 11.5, color: StudyFlowTheme.muted, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 10),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Today's plan", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.4)),
                  Text('$_completedTasks/3 done', style: const TextStyle(color: StudyFlowTheme.sageStrong, fontWeight: FontWeight.w800, fontSize: 13)),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _TaskCard(title: 'Chapter 1 — IP', subject: 'Information Practices', duration: '60 min', completed: _chapter1Completed, onToggle: () => setState(() => _chapter1Completed = !_chapter1Completed), onTap: () => _openFocus('Chapter 1 — IP', 'Information Practices', 60)),
                _TaskCard(title: 'Chapter 2 — IP', subject: 'Information Practices', duration: '45 min', completed: _chapter2Completed, onToggle: () => setState(() => _chapter2Completed = !_chapter2Completed), onTap: () => _openFocus('Chapter 2 — IP', 'Information Practices', 45)),
                _TaskCard(title: 'Practice SQL queries', subject: 'Database', duration: '30 min', completed: _sqlCompleted, onToggle: () => setState(() => _sqlCompleted = !_sqlCompleted), onTap: () => _openFocus('Practice SQL queries', 'Database', 30)),
              ]),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 34),
            sliver: SliverToBoxAdapter(
              child: GlassCard(
                radius: 22,
                child: Row(
                  children: [
                    Container(width: 44, height: 44, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.lightbulb_rounded, color: StudyFlowTheme.sageStrong)),
                    const SizedBox(width: 13),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Small steps, big progress.', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: StudyFlowTheme.charcoal)),
                          SizedBox(height: 4),
                          Text('Focus on one task at a time and keep your momentum going.', style: TextStyle(color: StudyFlowTheme.muted, fontSize: 12, height: 1.35)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isRestoring = false;

  Future<void> _restorePurchases() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _isRestoring) return;

    setState(() {
      _isRestoring = true;
    });

    try {
      await Purchases.logIn(user.uid);
      final customerInfo = await Purchases.restorePurchases();
      final restored = customerInfo.entitlements.active
          .containsKey('studyflow_pro');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              restored
                  ? 'StudyFlow Pro restored successfully.'
                  : 'No active StudyFlow Pro purchase was found for this account.',
            ),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not restore purchases. Please try again.'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRestoring = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final String name =
        user?.displayName?.trim().isNotEmpty == true
            ? user!.displayName!
            : 'StudyFlow User';

    final String email = user?.email ?? 'No email available';

    return Scaffold(
      backgroundColor: StudyFlowTheme.backgroundLight,
      appBar: const GlassAppBar(title: 'Profile'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(colors: [Color(0xFFDCEFE0), Color(0xFFBBD5C1)]),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 18, offset: const Offset(0, 10))],
                ),
                child: const Icon(Icons.person_outline, size: 48, color: StudyFlowTheme.sageStrong),
              ),
              const SizedBox(height: 18),
              Text(name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
              const SizedBox(height: 6),
              Text(email, textAlign: TextAlign.center, style: TextStyle(color: StudyFlowTheme.muted, fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 28),

              GlassCard(
                radius: 20,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Container(width: 46, height: 46, decoration: BoxDecoration(color: const Color(0xFFEAF5EE), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.person_outline, color: StudyFlowTheme.sageStrong)),
                  title: const Text('Name', style: TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: Padding(padding: const EdgeInsets.only(top: 4), child: Text(name, style: TextStyle(color: StudyFlowTheme.muted, fontWeight: FontWeight.w600))),
                ),
              ),

              const SizedBox(height: 12),

              GlassCard(
                radius: 20,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Container(width: 46, height: 46, decoration: BoxDecoration(color: const Color(0xFFEAF5EE), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.email_outlined, color: StudyFlowTheme.sageStrong)),
                  title: const Text('Email', style: TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: Padding(padding: const EdgeInsets.only(top: 4), child: Text(email, style: TextStyle(color: StudyFlowTheme.muted, fontWeight: FontWeight.w600))),
                ),
              ),

              const SizedBox(height: 12),

              GlassCard(
                radius: 20,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Container(width: 46, height: 46, decoration: BoxDecoration(color: const Color(0xFFEAF5EE), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.lock_outline, color: StudyFlowTheme.sageStrong)),
                  title: const Text('Reset Password', style: TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: const Padding(padding: EdgeInsets.only(top: 4), child: Text('Send a password reset email', style: TextStyle(fontWeight: FontWeight.w600))),
                  trailing: const Icon(Icons.chevron_right, color: StudyFlowTheme.muted),
                  onTap: () async {
                    if (user?.email == null) return;

                    try {
                      await FirebaseAuth.instance.sendPasswordResetEmail(email: user!.email!);

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password reset email sent. Check your inbox.')));
                      }
                    } on FirebaseAuthException catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'Could not send password reset email.')));
                      }
                    }
                  },
                ),
              ),

              const SizedBox(height: 20),

              GlassCard(
                radius: 20,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Container(width: 46, height: 46, decoration: BoxDecoration(color: const Color(0xFFEAF5EE), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.restore_outlined, color: StudyFlowTheme.sageStrong)),
                  title: const Text('Restore purchases', style: TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: const Padding(padding: EdgeInsets.only(top: 4), child: Text('Restore Pro access on this account', style: TextStyle(fontWeight: FontWeight.w600))),
                  trailing: _isRestoring ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.chevron_right, color: StudyFlowTheme.muted),
                  onTap: _isRestoring ? null : _restorePurchases,
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await _logOutRevenueCat();
                    await FirebaseAuth.instance.signOut();

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.logout, color: Colors.redAccent),
                  label: const Text('Sign Out', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w800)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
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
class _StudyTask {
  String title;
  String subject;
  int durationMinutes;
  bool completed = false;

  _StudyTask({
    required this.title,
    required this.subject,
    required this.durationMinutes,
   });
}

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  final List<_StudyTask> _tasks = [
    _StudyTask(
      title: 'Chapter 1 — IP',
      subject: 'Information Practices',
      durationMinutes: 60,
    ),
    _StudyTask(
      title: 'Chapter 2 — IP',
      subject: 'Information Practices',
      durationMinutes: 45,
    ),
    _StudyTask(
      title: 'SQL Practice',
      subject: 'Database',
      durationMinutes: 30,
    ),
  ];

  Future<void> _showAddTaskDialog() async {
    final titleController = TextEditingController();
    final subjectController = TextEditingController();
    final durationController = TextEditingController();

    final task = await showDialog<_StudyTask>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Add Task',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Task title',
                    hintText: 'e.g. Python Revision',
                    prefixIcon: const Icon(Icons.task_alt_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: subjectController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Subject',
                    hintText: 'e.g. Machine Learning',
                    prefixIcon: const Icon(Icons.book_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: durationController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: 'Duration (minutes)',
                    hintText: 'e.g. 45',
                    prefixIcon: const Icon(Icons.timer_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
            FilledButton(
              onPressed: () {
                final title = titleController.text.trim();
                final subject = subjectController.text.trim();
                final duration = int.tryParse(
                  durationController.text.trim(),
                );

                if (title.isEmpty || subject.isEmpty || duration == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please enter title, subject and a valid duration.',
                      ),
                    ),
                  );
                  return;
                }

                if (duration <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Duration must be greater than 0.'),
                    ),
                  );
                  return;
                }

                Navigator.pop(
                  dialogContext,
                  _StudyTask(
                    title: title,
                    subject: subject,
                    durationMinutes: duration,
                  ),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: StudyFlowTheme.sage,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Add Task', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ],
        );
      },
    );

    if (task != null && mounted) {
      setState(() {
        _tasks.add(task);
      });
    }
  }

  String _durationText(int minutes) => '$minutes min';

  void _openFocus(_StudyTask task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FocusScreen(
          taskTitle: task.title,
          subject: task.subject,
          durationMinutes: task.durationMinutes,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Study Planner', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.7)),
            const SizedBox(height: 6),
            Text('Plan your study sessions and stay on track.', style: TextStyle(color: StudyFlowTheme.muted, fontSize: 14.5, fontWeight: FontWeight.w600)),
            const SizedBox(height: 24),
            GlassContainer(
              radius: 22,
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  ...List.generate(4, (index) {
                    final date = DateTime.now().add(Duration(days: index));
                    final label = index == 0 ? 'Today' : const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][date.weekday - 1];
                    return [
                      if (index > 0) const SizedBox(width: 10),
                      Expanded(
                        child: _PlannerDate(
                          day: '${date.day}',
                          label: label,
                          selected: index == 0,
                        ),
                      ),
                    ];
                  }).expand((children) => children),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Today’s tasks', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, letterSpacing: -0.2)),
                FloatingActionButton.small(
                  heroTag: 'plannerAdd',
                  onPressed: _showAddTaskDialog,
                  backgroundColor: StudyFlowTheme.sage,
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Expanded(
              child: _tasks.isEmpty
                  ? Center(
                      child: GlassContainer(
                        radius: 22,
                        padding: const EdgeInsets.all(18),
                        child: Text('No tasks yet.\nTap + to add your first task.', textAlign: TextAlign.center, style: TextStyle(color: StudyFlowTheme.muted, fontSize: 15, height: 1.5, fontWeight: FontWeight.w600)),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          for (final task in _tasks)
                            _TaskCard(
                              title: task.title,
                              subject: task.subject,
                              duration: _durationText(task.durationMinutes),
                              completed: task.completed,
                              onToggle: () {
                                final next = !task.completed;
                                setState(() { task.completed = next; });
                                StudyFlowData.instance.recordTask(completed: next, minutes: task.durationMinutes);
                              },
                              onTap: () => _openFocus(task),
                            ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlannerDate extends StatelessWidget {
  final String day;
  final String label;
  final bool selected;

  const _PlannerDate({
    required this.day,
    required this.label,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: BoxDecoration(
        gradient: selected ? const LinearGradient(colors: [Color(0xFF5F9C75), Color(0xFF407D5E)]) : null,
        color: selected ? null : Colors.white.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: selected ? const Color(0xFF5E9A74) : const Color(0x1F5E7B5A), width: 1),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: selected ? Colors.white70 : StudyFlowTheme.muted, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(day, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: selected ? Colors.white : StudyFlowTheme.charcoal)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// FOCUS
// ─────────────────────────────────────────────

class FocusScreen extends StatefulWidget {
  final String taskTitle;
  final String subject;
  final int durationMinutes;

  const FocusScreen({
    super.key,
    this.taskTitle = 'Chapter 2 — IP',
    this.subject = 'Information Practices',
    this.durationMinutes = 45,
  });

  @override
  State<FocusScreen> createState() =>
      _FocusScreenState();
}

class _FocusScreenState
    extends State<FocusScreen> {
  Timer? _timer;

  late int _remainingSeconds;

  bool _isRunning = false;

  @override
  void initState() {
    super.initState();

    _remainingSeconds =
        widget.durationMinutes * 60;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_remainingSeconds <= 0) {
      _resetTimer();
    }

    _timer?.cancel();

    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_remainingSeconds <= 1) {
          timer.cancel();

          if (mounted) {
            setState(() {
              _remainingSeconds = 0;
              _isRunning = false;
            });

            StudyFlowData.instance.recordFocusSession(
              widget.durationMinutes,
            );
            _showCompletedMessage();
          }

          return;
        }

        if (mounted) {
          setState(() {
            _remainingSeconds--;
          });
        }
      },
    );
  }

  void _pauseTimer() {
    _timer?.cancel();

    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();

    setState(() {
      _remainingSeconds =
          widget.durationMinutes * 60;
      _isRunning = false;
    });
  }

  void _showCompletedMessage() {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Focus session completed! 🎉',
        ),
      ),
    );
  }

  String _formatTime() {
    final minutes =
        _remainingSeconds ~/ 60;

    final seconds =
        _remainingSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final totalSeconds = widget.durationMinutes * 60;
    final progress = totalSeconds == 0 ? 0.0 : _remainingSeconds / totalSeconds;

    return Scaffold(
      backgroundColor: StudyFlowTheme.backgroundLight,
      appBar: const GlassAppBar(title: 'Focus Session'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: GlassContainer(
            radius: 32,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(widget.taskTitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
                const SizedBox(height: 6),
                Text(widget.subject, textAlign: TextAlign.center, style: TextStyle(color: StudyFlowTheme.muted, fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 28),
                SizedBox(
                  width: 260,
                  height: 260,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 250,
                        height: 250,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 10,
                          backgroundColor: const Color(0xFFE7F0E8),
                          valueColor: const AlwaysStoppedAnimation<Color>(StudyFlowTheme.sage),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_formatTime(), style: const TextStyle(fontSize: 46, fontWeight: FontWeight.w800, color: StudyFlowTheme.charcoal)),
                          const SizedBox(height: 5),
                          Text(_isRunning ? 'Stay focused' : 'Focus session', style: TextStyle(color: StudyFlowTheme.muted, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _isRunning ? _pauseTimer : _startTimer,
                        icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                        label: Text(_isRunning ? 'Pause' : 'Start Session'),
                        style: FilledButton.styleFrom(
                          backgroundColor: StudyFlowTheme.sage,
                          minimumSize: const Size(0, 52),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      height: 52,
                      width: 52,
                      child: OutlinedButton(
                        onPressed: _resetTimer,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          side: const BorderSide(color: Color(0x2E5D8E71)),
                        ),
                        child: const Icon(Icons.restart_alt, color: StudyFlowTheme.sageStrong),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// NOTES
// ─────────────────────────────────────────────

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final List<Map<String, String>> _notes = [
    {
      'title': 'IP — Chapter 1',
      'subject': 'Information Practices',
      'preview':
          'Introduction to Python and basic concepts...',
    },
    {
      'title': 'SQL Commands',
      'subject': 'Database',
      'preview':
          'SELECT, INSERT, UPDATE and DELETE...',
    },
    {
      'title': 'ML Revision',
      'subject': 'Machine Learning',
      'preview':
          'Important concepts for upcoming revision...',
    },
  ];

  void _showAddNoteDialog() {
    final titleController = TextEditingController();
    final subjectController = TextEditingController();
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Add Note',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    hintText: 'e.g. Python Functions',
                    prefixIcon: const Icon(
                      Icons.title_outlined,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                TextField(
                  controller: subjectController,
                  decoration: InputDecoration(
                    labelText: 'Subject',
                    hintText: 'e.g. Programming',
                    prefixIcon: const Icon(
                      Icons.book_outlined,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                TextField(
                  controller: noteController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Note',
                    hintText: 'Write your note...',
                    prefixIcon: const Icon(
                      Icons.notes_outlined,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),

            FilledButton(
              onPressed: () {
                final title =
                    titleController.text.trim();
                final subject =
                    subjectController.text.trim();
                final note =
                    noteController.text.trim();

                if (title.isEmpty ||
                    subject.isEmpty ||
                    note.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please fill in all fields.',
                      ),
                    ),
                  );
                  return;
                }

                setState(() {
                  _notes.add({
                    'title': title,
                    'subject': subject,
                    'preview': note,
                  });
                });

                Navigator.pop(dialogContext);
              },
              style: FilledButton.styleFrom(
                backgroundColor:
                    const Color(0xFF6FA67A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('Save Note'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(child: Text('My Notes', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.7))),
                IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded, color: StudyFlowTheme.sageStrong)),
                IconButton(onPressed: _showAddNoteDialog, icon: const Icon(Icons.add_rounded, color: StudyFlowTheme.sageStrong)),
              ],
            ),
            const SizedBox(height: 6),
            Text('Keep your learning organized.', style: TextStyle(color: StudyFlowTheme.muted, fontSize: 14.5, fontWeight: FontWeight.w600)),
            const SizedBox(height: 22),
            Expanded(
              child: ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  final note = _notes[index];
                  return _NoteCard(
                    title: note['title'] ?? '',
                    subject: note['subject'] ?? '',
                    preview: note['preview'] ?? '',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NoteDetailScreen(
                            title: note['title'] ?? '',
                            subject: note['subject'] ?? '',
                            content: note['preview'] ?? '',
                            onSave: (title, subject, content) {
                              setState(() {
                                note['title'] = title;
                                note['subject'] = subject;
                                note['preview'] = content;
                              });
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final String title;
  final String subject;
  final String preview;
  final VoidCallback onTap;

  const _NoteCard({
    required this.title,
    required this.subject,
    required this.preview,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      radius: 22,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF5EE),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.description_outlined, color: StudyFlowTheme.sageStrong),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, letterSpacing: -0.2)),
                const SizedBox(height: 4),
                Text(subject, style: const TextStyle(color: StudyFlowTheme.sageStrong, fontSize: 12, fontWeight: FontWeight.w700)),
                const SizedBox(height: 5),
                Text(preview, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: StudyFlowTheme.muted, fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NoteDetailScreen extends StatefulWidget {
  final String title;
  final String subject;
  final String content;
  final void Function(String title, String subject, String content) onSave;

  const NoteDetailScreen({
    super.key,
    required this.title,
    required this.subject,
    required this.content,
    required this.onSave,
  });

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late String _title = widget.title;
  late String _subject = widget.subject;
  late String _content = widget.content;

  Future<void> _showEditDialog() async {
    final titleController = TextEditingController(text: _title);
    final subjectController = TextEditingController(text: _subject);
    final contentController = TextEditingController(text: _content);

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Edit Note',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    prefixIcon: const Icon(Icons.title_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: subjectController,
                  decoration: InputDecoration(
                    labelText: 'Subject',
                    prefixIcon: const Icon(Icons.book_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: contentController,
                  minLines: 4,
                  maxLines: 8,
                  decoration: InputDecoration(
                    labelText: 'Note',
                    prefixIcon: const Icon(Icons.notes_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final title = titleController.text.trim();
                final subject = subjectController.text.trim();
                final content = contentController.text.trim();

                if (title.isEmpty || subject.isEmpty || content.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all fields.'),
                    ),
                  );
                  return;
                }

                setState(() {
                  _title = title;
                  _subject = subject;
                  _content = content;
                });
                widget.onSave(title, subject, content);
                Navigator.pop(dialogContext);
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF6FA67A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StudyFlowTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Note', style: TextStyle(fontWeight: FontWeight.w700)),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        actions: [
          IconButton(tooltip: 'Edit note', icon: const Icon(Icons.edit_outlined), onPressed: _showEditDialog),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: GlassContainer(
          radius: 30,
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -0.4)),
              const SizedBox(height: 8),
              Text(_subject, style: const TextStyle(color: StudyFlowTheme.sageStrong, fontSize: 14, fontWeight: FontWeight.w700)),
              const SizedBox(height: 24),
              Text(_content, style: const TextStyle(fontSize: 16, height: 1.6, color: StudyFlowTheme.charcoal)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ─────────────────────────────────────────────
// MORE
// ─────────────────────────────────────────────

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  Future<void> _showThemeDialog(BuildContext context) async {
    final selected = await showDialog<ThemeMode>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: const Text('Appearance'),
        children: [
          ListTile(
            leading: Icon(
              StudyFlowThemeController.instance.value == ThemeMode.light
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
            ),
            title: const Text('Light'),
            subtitle: const Text('Always use the light StudyFlow theme'),
            onTap: () => Navigator.pop(dialogContext, ThemeMode.light),
          ),
          ListTile(
            leading: Icon(
              StudyFlowThemeController.instance.value == ThemeMode.system
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
            ),
            title: const Text('Device setting'),
            subtitle: const Text('Follow your device preference safely'),
            onTap: () => Navigator.pop(dialogContext, ThemeMode.system),
          ),
        ],
      ),
    );

    if (selected != null) {
      StudyFlowThemeController.instance.value = selected;
    }
  }

  Future<void> _openAnalytics(BuildContext context) async {
    bool isPro = false;
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      isPro = customerInfo.entitlements.active.containsKey('studyflow_pro');
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not verify Pro access. Try again.')),
        );
      }
      return;
    }

    if (!context.mounted) return;

    if (isPro) {
      _open(context, 'Analytics');
    } else {
      try {
        await RevenueCatUI.presentPaywallIfNeeded('studyflow_pro');
      } catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('The Pro screen is unavailable right now.')),
          );
        }
      }
    }
  }

  void _open(BuildContext context, String title) {
    final pages = <String, Widget>{
      'Goals': const GoalsScreen(),
      'Analytics': const AnalyticsScreen(),
      'Study Streak': const StudyStreakScreen(),
      'Motivation': const MotivationScreen(),
    };

    final page = pages[title];
    if (page == null) return;

    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 30),
        children: [
          const Text('More', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.7)),
          const SizedBox(height: 22),
          _MoreTile(icon: Icons.flag_outlined, title: 'Goals', subtitle: 'Set and track your daily study goal', onTap: () => _open(context, 'Goals')),
          _MoreTile(icon: Icons.bar_chart_outlined, title: 'Analytics', subtitle: 'View your weekly study progress', onTap: () => _openAnalytics(context)),
          _MoreTile(icon: Icons.local_fire_department_outlined, title: 'Study Streak', subtitle: 'Keep your study consistency going', onTap: () => _open(context, 'Study Streak')),
          _MoreTile(icon: Icons.lightbulb_outline, title: 'Motivation', subtitle: 'Daily quotes and study tips', onTap: () => _open(context, 'Motivation')),
          _MoreTile(icon: Icons.brightness_6_outlined, title: 'Appearance', subtitle: 'Light or follow your device setting', onTap: () => _showThemeDialog(context)),
          const SizedBox(height: 4),
          GlassCard(
            radius: 22,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              leading: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE9E8),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.logout, color: Colors.redAccent),
              ),
              title: const Text('Sign Out', style: TextStyle(fontWeight: FontWeight.w800)),
              subtitle: const Padding(padding: EdgeInsets.only(top: 3), child: Text('Sign out of your StudyFlow account')),
              trailing: const Icon(Icons.chevron_right, color: StudyFlowTheme.muted),
              onTap: () async {
                await _logOutRevenueCat();
                await FirebaseAuth.instance.signOut();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MoreTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MoreTile({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      radius: 22,
      margin: const EdgeInsets.only(bottom: 12),
      onTap: onTap,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        leading: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF5EE),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: StudyFlowTheme.sageStrong),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Padding(padding: const EdgeInsets.only(top: 3), child: Text(subtitle, style: TextStyle(color: StudyFlowTheme.muted, fontWeight: FontWeight.w500))),
        trailing: const Icon(Icons.chevron_right, color: StudyFlowTheme.muted),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// GOALS
// ─────────────────────────────────────────────

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  String _formatMinutes(int minutes) {
    if (minutes < 60) return '$minutes min';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}m';
  }

  Future<void> _changeGoal(BuildContext context) async {
    final controller = TextEditingController(
      text: StudyFlowData.instance.goalMinutes.toString(),
    );

    final value = await showDialog<int>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Set daily goal'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Study minutes',
            hintText: 'Example: 120',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final value = int.tryParse(controller.text.trim());
              if (value != null && value > 0) {
                Navigator.pop(dialogContext, value);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    controller.dispose();

    if (value != null) {
      StudyFlowData.instance.setGoal(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StudyFlowTheme.backgroundLight,
      appBar: const GlassAppBar(title: 'Goals'),
      body: AnimatedBuilder(
        animation: StudyFlowData.instance,
        builder: (context, _) {
          final data = StudyFlowData.instance;
          final progress = data.goalProgress;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
            children: [
              GlassContainer(
                radius: 28,
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.flag_rounded, size: 34, color: StudyFlowTheme.sageStrong),
                    const SizedBox(height: 14),
                    const Text('Today’s study goal', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Text('${_formatMinutes(data.completedMinutes)} of ${_formatMinutes(data.goalMinutes)} completed', style: TextStyle(color: StudyFlowTheme.muted, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 12,
                        backgroundColor: Colors.white.withValues(alpha: 0.55),
                        valueColor: const AlwaysStoppedAnimation<Color>(StudyFlowTheme.sage),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('${(progress * 100).round()}% complete', style: const TextStyle(fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              GlassCard(
                radius: 22,
                child: ListTile(
                  leading: const Icon(Icons.timer_outlined, color: StudyFlowTheme.sageStrong),
                  title: const Text('Daily target', style: TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: Text(_formatMinutes(data.goalMinutes), style: TextStyle(color: StudyFlowTheme.muted, fontWeight: FontWeight.w600)),
                  trailing: const Icon(Icons.edit_outlined, color: StudyFlowTheme.muted),
                  onTap: () => _changeGoal(context),
                ),
              ),
              const SizedBox(height: 12),
              GlassCard(
                radius: 22,
                child: ListTile(
                  leading: const Icon(Icons.task_alt, color: StudyFlowTheme.sageStrong),
                  title: const Text('Tasks completed', style: TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: Text('${data.completedTasks} tasks completed', style: TextStyle(color: StudyFlowTheme.muted, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 20),
              const Text('How goals work', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text('Complete a planned task or finish a Focus session. Your study progress updates automatically.', style: TextStyle(color: StudyFlowTheme.muted, height: 1.5, fontWeight: FontWeight.w600)),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ANALYTICS
// ─────────────────────────────────────────────

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  String _format(int minutes) {
    if (minutes < 60) return '$minutes min';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}m';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StudyFlowTheme.backgroundLight,
      appBar: const GlassAppBar(title: 'Analytics'),
      body: AnimatedBuilder(
        animation: StudyFlowData.instance,
        builder: (context, _) {
          final data = StudyFlowData.instance;
          final total = data.weeklyMinutes.fold<int>(0, (a, b) => a + b);

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
            children: [
              Row(
                children: [
                  Expanded(child: StatTile(icon: Icons.timer_outlined, value: _format(data.completedMinutes), label: 'Today', accent: StudyFlowTheme.sageStrong)),
                  const SizedBox(width: 12),
                  Expanded(child: StatTile(icon: Icons.task_alt, value: '${data.completedTasks}', label: 'Tasks done', accent: const Color(0xFF4F8D60))),
                ],
              ),
              const SizedBox(height: 12),
              StatTile(icon: Icons.calendar_month_outlined, value: _format(total), label: 'Last 7 days', accent: const Color(0xFFA3C9B0)),
              const SizedBox(height: 20),
              GlassContainer(
                radius: 28,
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Weekly progress', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text('Study time over the last 7 days', style: TextStyle(color: StudyFlowTheme.muted, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 18),
                    SizedBox(height: 220, width: double.infinity, child: _WeeklyLineChart(values: data.weeklyMinutes)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              GlassContainer(
                radius: 22,
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    const Icon(Icons.insights_outlined, color: StudyFlowTheme.sageStrong, size: 30),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        data.completedMinutes >= data.goalMinutes ? 'Great work! You reached your daily goal. 🎉' : 'Keep going — you are building your study habit.',
                        style: const TextStyle(fontWeight: FontWeight.w700, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _WeeklyLineChart extends StatelessWidget {
  final List<int> values;

  const _WeeklyLineChart({required this.values});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _WeeklyChartPainter(values),
      child: const SizedBox.expand(),
    );
  }
}

class _WeeklyChartPainter extends CustomPainter {
  final List<int> values;

  _WeeklyChartPainter(this.values);

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final chartLeft = 28.0;
    final chartRight = size.width - 8;
    final chartTop = 10.0;
    final chartBottom = size.height - 28;
    final chartWidth = chartRight - chartLeft;
    final chartHeight = chartBottom - chartTop;

    final gridPaint = Paint()
      ..color = const Color(0xFFE2E7E2)
      ..strokeWidth = 1;

    final linePaint = Paint()
      ..color = const Color(0xFF6FA67A)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final dotPaint = Paint()
      ..color = const Color(0xFF5B9067)
      ..style = PaintingStyle.fill;

    final maxValue = (values.reduce((a, b) => a > b ? a : b)).clamp(10, 999999);

    for (int i = 0; i < 4; i++) {
      final y = chartTop + chartHeight * i / 3;
      canvas.drawLine(
        Offset(chartLeft, y),
        Offset(chartRight, y),
        gridPaint,
      );
    }

    final path = Path();

    for (int i = 0; i < values.length; i++) {
      final x = chartLeft +
          (chartWidth * i / (values.length - 1).clamp(1, 100));
      final y = chartBottom -
          (values[i] / maxValue) * chartHeight;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, linePaint);

    for (int i = 0; i < values.length; i++) {
      final x = chartLeft +
          (chartWidth * i / (values.length - 1).clamp(1, 100));
      final y = chartBottom -
          (values[i] / maxValue) * chartHeight;

      canvas.drawCircle(Offset(x, y), 5, dotPaint);
    }

    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final textStyle = const TextStyle(
      color: Color(0xFF6F756F),
      fontSize: 11,
    );

    for (int i = 0; i < labels.length; i++) {
      final x = chartLeft +
          (chartWidth * i / (labels.length - 1).clamp(1, 100));
      final tp = TextPainter(
        text: TextSpan(text: labels[i], style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(x - tp.width / 2, chartBottom + 8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WeeklyChartPainter oldDelegate) {
    return true;
  }
}

// ─────────────────────────────────────────────
// STUDY STREAK
// ─────────────────────────────────────────────

class StudyStreakScreen extends StatelessWidget {
  const StudyStreakScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StudyFlowTheme.backgroundLight,
      appBar: const GlassAppBar(title: 'Study Streak'),
      body: AnimatedBuilder(
        animation: StudyFlowData.instance,
        builder: (context, _) {
          final data = StudyFlowData.instance;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
            children: [
              GlassContainer(
                radius: 28,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                child: Column(
                  children: [
                    const Text('🔥', style: TextStyle(fontSize: 64)),
                    const SizedBox(height: 8),
                    Text('${data.currentStreak} Day Streak', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.6)),
                    const SizedBox(height: 6),
                    Text('Keep studying every day to maintain your streak.', textAlign: TextAlign.center, style: TextStyle(color: StudyFlowTheme.muted, height: 1.4, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _StreakStat(value: '${data.currentStreak}', label: 'Current streak')),
                  const SizedBox(width: 12),
                  Expanded(child: _StreakStat(value: '${data.longestStreak}', label: 'Longest streak')),
                ],
              ),
              const SizedBox(height: 20),
              const Text('This week', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              GlassContainer(
                radius: 24,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(7, (index) {
                    final today = DateTime.now();
                    final monday = today.subtract(Duration(days: today.weekday - 1));
                    final date = monday.add(Duration(days: index));
                    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                    return _StreakDay(day: labels[index], active: data.hasActivityOn(date));
                  }),
                ),
              ),
              const SizedBox(height: 14),
              Text('Complete at least one task or Focus session each day to keep building your streak.', style: TextStyle(color: StudyFlowTheme.muted, height: 1.5, fontWeight: FontWeight.w600)),
            ],
          );
        },
      ),
    );
  }
}

class _StreakStat extends StatelessWidget {
  final String value;
  final String label;

  const _StreakStat({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      radius: 22,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
            const SizedBox(height: 4),
            Text(label, textAlign: TextAlign.center, style: TextStyle(color: StudyFlowTheme.muted, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _StreakDay extends StatelessWidget {
  final String day;
  final bool active;

  const _StreakDay({
    required this.day,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          active ? '🔥' : '○',
          style: TextStyle(
            fontSize: active ? 24 : 22,
            color: active ? null : Colors.grey.shade400,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          day,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// MOTIVATION
// ─────────────────────────────────────────────

class MotivationScreen extends StatefulWidget {
  const MotivationScreen({super.key});

  @override
  State<MotivationScreen> createState() => _MotivationScreenState();
}

class _MotivationScreenState extends State<MotivationScreen> {
  final List<Map<String, String>> _quotes = const [
    {
      'quote': 'Small progress is still progress.',
      'tip': 'Focus on one task at a time instead of trying to finish everything together.',
    },
    {
      'quote': 'Consistency beats intensity.',
      'tip': 'A focused 30-minute session every day can build a strong habit.',
    },
    {
      'quote': 'Your future self will thank you for studying today.',
      'tip': 'Start with the easiest task to build momentum.',
    },
    {
      'quote': 'Don’t wait for motivation. Start, and motivation follows.',
      'tip': 'Set a timer and give yourself just five minutes to begin.',
    },
    {
      'quote': 'One chapter. One concept. One step at a time.',
      'tip': 'Break difficult topics into smaller study blocks.',
    },
  ];

  int _index = 0;

  void _nextQuote() {
    setState(() {
      _index = (_index + 1) % _quotes.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final item = _quotes[_index];

    return Scaffold(
      backgroundColor: StudyFlowTheme.backgroundLight,
      appBar: const GlassAppBar(title: 'Motivation'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        children: [
          GlassContainer(
            radius: 32,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Icon(Icons.format_quote_rounded, size: 42, color: StudyFlowTheme.sageStrong),
                const SizedBox(height: 18),
                Text('“${item['quote']}”', textAlign: TextAlign.center, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w800, height: 1.35, letterSpacing: -0.2)),
                const SizedBox(height: 22),
                Text(item['tip']!, textAlign: TextAlign.center, style: TextStyle(color: StudyFlowTheme.muted, fontSize: 15, height: 1.45, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _nextQuote,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('New Quote'),
            style: FilledButton.styleFrom(
              backgroundColor: StudyFlowTheme.sage,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            ),
          ),
          const SizedBox(height: 22),
          const Text('Today’s reminder', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          GlassCard(
            radius: 22,
            child: const Padding(
              padding: EdgeInsets.all(18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.self_improvement_outlined, color: StudyFlowTheme.sageStrong),
                  SizedBox(width: 12),
                  Expanded(child: Text('Put your phone away, open your current task, and give it your full attention. 🌱', style: TextStyle(height: 1.45, fontWeight: FontWeight.w600))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// SHARED WIDGETS
// ─────────────────────────────────────────────

class _TaskCard extends StatelessWidget {
  final String title;
  final String subject;
  final String duration;
  final bool completed;
  final VoidCallback? onTap;
  final VoidCallback? onToggle;

  const _TaskCard({
    required this.title,
    required this.subject,
    required this.duration,
    required this.completed,
    this.onTap,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      radius: 22,
      margin: const EdgeInsets.only(bottom: 12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            GestureDetector(
              onTap: onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: completed ? StudyFlowTheme.sage : Colors.transparent,
                  border: Border.all(color: completed ? StudyFlowTheme.sage : const Color(0xFFC9CEC9), width: 2),
                ),
                child: completed ? const Icon(Icons.check_rounded, size: 18, color: Colors.white) : null,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: completed ? Colors.grey.shade500 : StudyFlowTheme.charcoal,
                      decoration: completed ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.book_outlined, size: 13, color: StudyFlowTheme.muted),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          subject,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: StudyFlowTheme.muted, fontSize: 11.5, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF5EE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.schedule_rounded, size: 14, color: StudyFlowTheme.sageStrong),
                  const SizedBox(width: 4),
                  Text(duration, style: const TextStyle(color: StudyFlowTheme.sageStrong, fontSize: 11, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
            const SizedBox(width: 2),
            Icon(Icons.chevron_right_rounded, color: StudyFlowTheme.muted),
          ],
        ),
      ),
    );
  }
}
