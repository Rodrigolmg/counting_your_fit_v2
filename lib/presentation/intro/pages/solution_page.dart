import 'package:counting_your_fit_v2/color_app.dart';
import 'package:counting_your_fit_v2/context_extension.dart';
import 'package:flutter/material.dart';

class SolutionPage extends StatelessWidget {
  const SolutionPage({Key? key}) : super(key: key);

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
            const Image(
              image: AssetImage('assets/images/light_idea.png'),
              height: 250,
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              context.translate.get('intro.secondPageLabel'),
              style: TextStyle(
                color: ColorApp.mainColor,
                fontSize: 25
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}