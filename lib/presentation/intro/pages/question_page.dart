import 'package:counting_your_fit_v2/color_app.dart';
import 'package:counting_your_fit_v2/context_extension.dart';
import 'package:flutter/material.dart';

class QuestionPage extends StatelessWidget {
  const QuestionPage({Key? key}) : super(key: key);

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
              image: AssetImage('assets/images/question.png'),
              height: 200,
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              context.translate.get('intro.firstPageLabel'),
              style: TextStyle(
                color: ColorApp.mainColor,
                fontSize: 25,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
