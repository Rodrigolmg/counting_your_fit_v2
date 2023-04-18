import 'package:counting_your_fit_v2/presentation/components/directional_button.dart';
import 'package:flutter/material.dart';

class ExerciseListPage extends StatefulWidget {
  const ExerciseListPage({Key? key}) : super(key: key);

  @override
  State<ExerciseListPage> createState() => _ExerciseListPageState();
}

class _ExerciseListPageState extends State<ExerciseListPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 10,
          top: 80,
          child: DirectionalButton(
            isToRight: false,
            icon: Icons.run_circle_outlined,
            onTap: (){

            }
          ),
        ),
      ],
    );
  }
}
