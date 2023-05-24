import 'package:counting_your_fit_v2/color_app.dart';
import 'package:counting_your_fit_v2/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: ColorApp.backgroundColor
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: SizedBox(
                width: 300,
                height: 300,
                child: RiveAnimation.asset(
                  'assets/anims/biceps.riv',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              context.translate.get('intro.fifthPageLabel'),
              style: TextStyle(
                color: ColorApp.mainColor,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}