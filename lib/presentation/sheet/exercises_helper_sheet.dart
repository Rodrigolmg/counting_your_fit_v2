import 'package:counting_your_fit_v2/color_app.dart';
import 'package:counting_your_fit_v2/context_extension.dart';
import 'package:flutter/material.dart';

class ExercisesHelperSheet extends StatelessWidget {
  const ExercisesHelperSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        minChildSize: 1,
        initialChildSize: 1,
        maxChildSize: 1,
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
                padding: const EdgeInsets.only(top: 60, left: 20),
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: context.width * .8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: context.width * .89,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.translate.get('sets'),
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
                                context.translate.get('helpPage.timerPage.setsHelp'),
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    color: ColorApp.backgroundColor,
                                    fontSize: 18,
                                    shadows: const [
                                      Shadow(
                                          color: Colors.black26,
                                          offset: Offset(1, 1)
                                      )
                                    ],
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: context.width * .89,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.translate.get('rest'),
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
                                context.translate.get('helpPage.timerPage.restHelp'),
                                textAlign: TextAlign.justify,
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
                        SizedBox(
                          width: context.width * .89,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.translate.get('additionalExercise'),
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
                                context.translate.get('helpPage.timerPage.isometricsHelp'),
                                textAlign: TextAlign.justify,
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
                        SizedBox(
                          width: context.width * .89,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.translate.get('autoRest'),
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
                                context.translate.get('helpPage.timerPage.autoRestHelp'),
                                textAlign: TextAlign.justify,
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
                        SizedBox(
                          width: context.width * .89,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.translate.get('helpPage.timerPage.stepHelpTitle'),
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
                                context.translate.get('helpPage.timerPage.stepHelp'),
                                textAlign: TextAlign.justify,
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
                ),
              )
            ],
          );
        }
    );
  }
}
