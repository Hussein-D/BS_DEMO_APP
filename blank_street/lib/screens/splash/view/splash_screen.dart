import 'package:blank_street/screens/home/view/home_screen.dart';
import 'package:blank_street/screens/signup/bloc/signup_bloc.dart';
import 'package:blank_street/screens/signup/view/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _scale;
  late final Animation<double> _fade;
  late final Animation<double> _progress;
  static const cream = Color(0xFFFCF7F2);
  static const beige = Color(0xFFECDBCB);
  static const green = Color(0xFF0E8A5C);
  @override
  void initState() {
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..forward();
    _scale = Tween(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _c,
        curve: Interval(0, 0.7, curve: Curves.easeOutBack),
      ),
    );
    _fade = CurvedAnimation(
      parent: _c,
      curve: Interval(0, 0.6, curve: Curves.easeOutCubic),
    );
    _progress = CurvedAnimation(
      parent: _c,
      curve: Interval(0.35, 1, curve: Curves.easeInOutCubic),
    );
    _c.addStatusListener((AnimationStatus s) {
      if (s == AnimationStatus.completed) {
        context.read<SignupBloc>().add(AutloLogin());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
        if(state is SignupInitial){
          if(state.user != null){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
          }else {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignupScreen()));
          }
        }
      },
      child: Scaffold(
        backgroundColor: cream,
        body: Stack(
          children: [
            Positioned(
              left: -60,
              top: -40,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: beige.withValues(alpha: 0.5),
                ),
              ),
            ),
            Positioned(
              right: -40,
              bottom: 80,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: beige.withValues(alpha: 0.5),
                ),
              ),
            ),
            Center(
              child: FadeTransition(
                opacity: _fade,
                child: ScaleTransition(
                  scale: _scale,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 104,
                        width: 104,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.coffee_rounded,
                          color: green,
                          size: 50,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Blank Street Coffee",
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      AnimatedBuilder(
                        animation: _progress,
                        builder: (x, y) => ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            width: 180,
                            height: 10,
                            child: LinearProgressIndicator(
                              value: _progress.value,
                              color: green,
                              backgroundColor: beige,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Preparing your order...",
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(),
                      ),
                    ],
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
