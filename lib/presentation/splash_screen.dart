import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:counting_your_fit_v2/counting_your_fit_router.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class CustomSplashScreen extends StatefulWidget {
  const CustomSplashScreen({Key? key}) : super(key: key);

  @override
  State<CustomSplashScreen> createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen> {

  _onSpashEnd(){
    Future.delayed(
      const Duration(seconds: 4),
      (){
        Navigator.pushReplacementNamed(
          context, CountingYourFitRoutes.timerSetting
        );
      }
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onSpashEnd();
    });
  }


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: RiveAnimation.asset("assets/anims/clockanim.riv"),
      ),
    );
  }
}
