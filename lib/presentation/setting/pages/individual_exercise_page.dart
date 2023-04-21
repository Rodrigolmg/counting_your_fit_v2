import 'package:counting_your_fit_v2/color_app.dart';
import 'package:counting_your_fit_v2/context_extension.dart';
import 'package:counting_your_fit_v2/counting_your_fit_router.dart';
import 'package:counting_your_fit_v2/presentation/components/hero/hero_button.dart';
import 'package:counting_your_fit_v2/presentation/components/directional_button.dart';
import 'package:counting_your_fit_v2/presentation/components/hero/hero_exercise_two_values.dart';
import 'package:counting_your_fit_v2/presentation/components/hero/hero_tag.dart';
import 'package:counting_your_fit_v2/presentation/components/shake_error.dart';
import 'package:counting_your_fit_v2/presentation/setting/state/exercise_state.dart';
import 'package:counting_your_fit_v2/presentation/setting/state/timer_settings_state_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class IndividualExercisePage extends StatefulWidget {
  const IndividualExercisePage({Key? key}) : super(key: key);

  @override
  State<IndividualExercisePage> createState() => _IndividualExercisePageState();
}

class _IndividualExercisePageState extends State<IndividualExercisePage>
    with SingleTickerProviderStateMixin {

  AnimationController? _animationController;
  Animation? _buttonPositionAnimation;
  final _timeScreenController = GetIt.I.get<TimerSettingsStateController>();
  ExerciseController exerciseController = GetIt.I.get<ExerciseController>();
  bool _hasAdditionalExercise = false;
  final _shakeTimerKey = GlobalKey<ShakeErrorState>();
  final _shakeAdditionalKey = GlobalKey<ShakeErrorState>();

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

  void trainCallback(){
    bool hasNoRestTime = exerciseController.minutes == '00' &&
        exerciseController.seconds == '00';

    if(hasNoRestTime) {
      _shakeTimerKey.currentState?.shake();
      return;
    }

    if(!_hasAdditionalExercise){
      Navigator.pushReplacementNamed(
        context,
        CountingYourFitRoutes.timer
      );
    } else {
      bool hasAdditionalTime = exerciseController.additionalMinutes != '00' ||
          exerciseController.additionalSeconds != '00';

      if(!hasAdditionalTime){
        _shakeAdditionalKey.currentState?.shake();
        return;
      }

      Navigator.pushReplacementNamed(
          context,
          CountingYourFitRoutes.timer
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Positioned(
            top: 80,
            right: _buttonPositionAnimation!.value,
            child: DirectionalButton(
                icon: Icons.list,
                onTap: (){
                  _timeScreenController.changePageOnClick(1);
                }
            )
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${context.translate.get('sets')}:',
                    style: TextStyle(
                        color: ColorApp.mainColor,
                        fontSize: 20
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  HeroButton(
                    heroTag: heroSetsPopUp,
                    buttonLabel: exerciseController.sets.toString(),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.only(right: width * .085),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${context.translate.get('rest')}:',
                      style: TextStyle(
                          color: ColorApp.mainColor,
                          fontSize: 20
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ShakeError(
                      key: _shakeTimerKey,
                      duration: const Duration(milliseconds: 550),
                      shakeCount: 3,
                      shakeOffset: 10,
                      child: HeroButton(
                        buttonLabel: '${exerciseController.minutes}:${exerciseController.seconds}',
                        heroTag: heroTimerPopUp,
                        hasError: _shakeTimerKey.currentState != null &&
                            _shakeTimerKey
                                .currentState!.animationController.status
                                    == AnimationStatus.forward,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _hasAdditionalExercise,
                    onChanged: exerciseController.seconds != '00' ||
                        exerciseController.minutes != '00' ?
                    (checkValue){
                      setState(() {
                        _hasAdditionalExercise = checkValue ?? false;
                      });
                      exerciseController.resetAddionals();
                    } : null,
                    checkColor: ColorApp.backgroundColor,
                    activeColor: ColorApp.mainColor,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    context.translate.get('additionalExercise'),
                    style: TextStyle(
                        color: _hasAdditionalExercise ?
                        ColorApp.mainColor : Colors.black26,
                        fontSize: 20
                    ),
                  )
                ],
              ),
              AnimatedOpacity(
                opacity: _hasAdditionalExercise ? 1 : 0,
                duration: const Duration(milliseconds: 100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${context.translate.get('timeLabel')}:',
                      style: TextStyle(
                          color: ColorApp.mainColor ,
                          fontSize: 20
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ShakeError(
                      key: _shakeAdditionalKey,
                      duration: const Duration(milliseconds: 550),
                      shakeCount: 3,
                      shakeOffset: 10,
                      child: HeroButton(
                        heroTag: heroAdditionalPopUp,
                        hasError: _shakeAdditionalKey.currentState != null &&
                            _shakeAdditionalKey.currentState!
                                .animationController.status
                                  == AnimationStatus.forward,
                        buttonLabel: '${exerciseController.additionalMinutes}:${exerciseController.additionalSeconds}',
                      ),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        AnimatedPositioned(
          top: height * (!_hasAdditionalExercise ? .52 : .59),
          left: width * .105,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutQuad,
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
                onPressed: trainCallback,
                child: Text(
                  context.translate.get('train'),
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
