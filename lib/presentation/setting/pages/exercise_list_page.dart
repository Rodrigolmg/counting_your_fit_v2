import 'package:counting_your_fit_v2/presentation/components/directional_button.dart';
import 'package:counting_your_fit_v2/presentation/setting/state/timer_settings_state_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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
      ],
    );
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }
}
