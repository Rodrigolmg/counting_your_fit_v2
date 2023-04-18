import 'package:counting_your_fit_v2/color_app.dart';
import 'package:counting_your_fit_v2/presentation/components/custom_outline_button.dart';
import 'package:counting_your_fit_v2/presentation/components/directional_button.dart';
import 'package:flutter/material.dart';

class IndividualExercisePage extends StatefulWidget {
  const IndividualExercisePage({Key? key}) : super(key: key);

  @override
  State<IndividualExercisePage> createState() => _IndividualExercisePageState();
}

class _IndividualExercisePageState extends State<IndividualExercisePage>
    with SingleTickerProviderStateMixin {

  AnimationController? _animationController;
  Animation? _buttonPositionAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    )..addListener(() {
      setState(() {});
    });

    _buttonPositionAnimation = Tween<double>(begin: 10, end: 7)
        .animate(CurvedAnimation(parent: _animationController!, curve: Curves.bounceIn));

    _animationController!.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {

    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Positioned(
            top: 80,
            right: _buttonPositionAnimation!.value,
            child: DirectionalButton(
                icon: Icons.list,
                onTap: (){
                  // TODO PUT IN PROVIDER FILE
                }
            )
        ),
        // TweenAnimationBuilder<double>(
        //   tween: Tween<double>(begin: 10, end: horizontalButtonPositionValue),
        //   builder: (context,value,child){
        //     return Positioned(
        //       top: 80,
        //       right: value,
        //       child: DirectionalButton(
        //           icon: Icons.list,
        //           onTap: (){
        //             // TODO PUT IN PROVIDER FILE
        //           }
        //       )
        //     );
        //   },
        //   duration: const Duration(milliseconds: 150),
        //   curve: Curves.easeInQuad,
        //   onEnd: _animeteButton,
        // ),
        Center(
          child: SizedBox(
            width: _width * .57,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      'Séries:',
                      style: TextStyle(
                          color: ColorApp.mainColor,
                          fontSize: 20
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const CustomOutlineButton()
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }
}
