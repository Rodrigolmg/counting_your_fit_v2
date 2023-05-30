import 'package:counting_your_fit_v2/color_app.dart';
import 'package:counting_your_fit_v2/context_extension.dart';
import 'package:flutter/material.dart';

class StepHelperSheet extends StatelessWidget {
  const StepHelperSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      minChildSize: .4,
      initialChildSize: .4,
      maxChildSize: .4,
      expand: false,
      builder: (context, scrollController){
        return Stack(
          fit: StackFit.passthrough,
          children: [
            Positioned(
              right: 10,
              top: 10,
              child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close_rounded,
                    size: 25,
                    color: ColorApp.backgroundColor,
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 25),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: context.width * .9,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.translate.get('exerciseList.quantity'),
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: ColorApp.backgroundColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                shadows: const [
                                  Shadow(
                                      color: Colors.black26,
                                      offset: Offset(1, 1)
                                  )
                                ]
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            context.translate.get('helpPage.exerciseListSettingPage.stepQuantityHelp'),
                            style: TextStyle(
                                color: ColorApp.backgroundColor,
                                fontSize: 18,
                                shadows: const [
                                  Shadow(
                                      color: Colors.black26,
                                      offset: Offset(1, 1)
                                  )
                                ]
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      }
    );
  }
}
