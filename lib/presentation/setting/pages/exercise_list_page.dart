import 'package:counting_your_fit_v2/color_app.dart';
import 'package:counting_your_fit_v2/context_extension.dart';
import 'package:counting_your_fit_v2/presentation/components/directional_button.dart';
import 'package:counting_your_fit_v2/presentation/components/hero/hero_button.dart';
import 'package:counting_your_fit_v2/presentation/components/hero/hero_tag.dart';
import 'package:counting_your_fit_v2/presentation/components/shake_error.dart';
import 'package:counting_your_fit_v2/presentation/setting/state/exercise_state.dart';
import 'package:counting_your_fit_v2/presentation/setting/state/timer_settings_state_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:numberpicker/numberpicker.dart';

class ExerciseListPage extends StatefulWidget {
  const ExerciseListPage({Key? key}) : super(key: key);

  @override
  State<ExerciseListPage> createState() => _ExerciseListPageState();
}

class _ExerciseListPageState extends State<ExerciseListPage> with
  SingleTickerProviderStateMixin {

  AnimationController? _animationController;
  Animation? _buttonPositionAnimation;
  final _timeScreenController = GetIt.I.get<TimerSettingsStateController>();
  final exerciseController = GetIt.I.get<ExerciseController>();
  bool _wantRegister = false;
  final _shakeQuantityKey = GlobalKey<ShakeErrorState>();
  int _quantityValue = 1;


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
        .animate(CurvedAnimation(parent: _animationController!,
        curve: Curves.easeOut)
    );

    _animationController!.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Positioned(
          left: _buttonPositionAnimation!.value,
          top: 80,
          child: DirectionalButton(
              isToRight: false,
              icon: Icons.run_circle_outlined,
              onTap: (){
                _timeScreenController.changePageOnClick(0);
              }
          ),
        ),
        Positioned(
          top: height * .31,
          left: width * .15,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${context.translate.get('exerciseList.quantity')}:',
                      style: TextStyle(
                          color: ColorApp.mainColor,
                          fontSize: 20
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: width * .3,
                      child: HeroButton(
                          buttonLabel: exerciseController.stepQuantity.toString(),
                          heroTag: heroStepQuantityPopUp
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _wantRegister,
                    onChanged: (value){
                      setState(() {
                        _wantRegister = value ?? false;
                      });
                    },
                    checkColor: ColorApp.backgroundColor,
                    activeColor: ColorApp.mainColor,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    context.translate.get('exerciseList.historyRegister'),
                    style: TextStyle(
                        color: _wantRegister ?
                        ColorApp.mainColor : Colors.black26,
                        fontSize: 20
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        Positioned(
          top: height * .48,
          left: width * .105,
          child: SizedBox(
            width: width * .8,
            height: height * .07,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: ColorApp.mainColor,
                  elevation: 2,
                ),
                onPressed: (){

                },
                child: Text(
                  context.translate.get('exerciseList.configureExercises'),
                  style: TextStyle(
                      color: ColorApp.backgroundColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                )
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
