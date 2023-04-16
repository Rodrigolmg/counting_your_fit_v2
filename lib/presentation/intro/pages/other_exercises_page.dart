import 'package:counting_your_fit_v2/color_app.dart';
import 'package:counting_your_fit_v2/context_extension.dart';
import 'package:flutter/material.dart';

class OtherExercisesPage extends StatelessWidget {
  const OtherExercisesPage({Key? key}) : super(key: key);

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
            const SizedBox(
              width: 150,
              child: Image(
                image: AssetImage('assets/images/plus.png'),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              context.translate.get('intro.fourthPageLabel'),
              style: TextStyle(
                  color: ColorApp.mainColor,
                  fontSize: 24
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}