import 'dart:async';

import 'package:direct_whats/view/styles/app_color.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _animation = Tween<Offset>(
      begin: const Offset(-5.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(_controller);
    _controller.forward();

    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const HomeScreen(),
          ));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.greenDark,
      body: Center(
        child: SlideTransition(
          position: _animation,
          child: Image.asset(
            "assets/images/transp_logo.png",
            width: 200.0,
            height: 200.0,
          ),
        ),
      ),
    );
  }
}
