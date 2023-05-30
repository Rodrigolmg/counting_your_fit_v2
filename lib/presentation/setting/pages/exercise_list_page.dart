import 'package:counting_your_fit_v2/color_app.dart';
import 'package:counting_your_fit_v2/context_extension.dart';
import 'package:counting_your_fit_v2/counting_your_fit_router.dart';
import 'package:counting_your_fit_v2/presentation/bloc/steps/step_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/steps/steps_state.dart';
import 'package:counting_your_fit_v2/presentation/components/directional_button.dart';
import 'package:counting_your_fit_v2/presentation/components/hero/hero_button.dart';
import 'package:counting_your_fit_v2/presentation/components/hero/hero_tag.dart';
import 'package:counting_your_fit_v2/presentation/components/hero/variants/hero_variant.dart';
import 'package:counting_your_fit_v2/presentation/setting/bloc/definition/settings_definition_state_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ExerciseListPage extends StatefulWidget {
  const ExerciseListPage({Key? key}) : super(key: key);

  @override
  State<ExerciseListPage> createState() => _ExerciseListPageState();
}

class _ExerciseListPageState extends State<ExerciseListPage> {

  final _timeScreenController = GetIt.I.get<SettingsDefinitionStateController>();
  final stepsController = GetIt.I.get<StepStateController>();
  int stepQuantity = 2;


  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Positioned(
          left: 7,
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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${context.translate.get('exerciseList.quantity')}:',
                    style: TextStyle(
                      color: ColorApp.mainColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: width * .3,
                    child: BlocBuilder<StepStateController, StepsState>(
                      bloc: stepsController,
                      buildWhen: (oldState, currentState) =>
                      currentState.isStepDefined,
                      builder: (context, state){

                        if(state.isStepDefined){
                          stepQuantity = (state as StepDefined).steps;
                        }

                        return HeroButton(
                          buttonLabel: stepQuantity.toString(),
                          heroTag: heroStepQuantityPopUp,
                          variant: HeroSteps(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: height * .41,
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
              onPressed: () {
                if(!stepsController.state.isStepDefined){
                  stepsController.setSteps(2);
                }
                Navigator.pushReplacementNamed(
                    context, CountingYourFitRoutes.exerciseStepSetting);
              },
              child: Text(
                context.translate.get('exerciseList.configureExercises'),
                style: TextStyle(
                  color: ColorApp.backgroundColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  shadows: const [
                    Shadow(
                        offset: Offset(1, 1),
                        color: Colors.black26
                    )
                  ]
                ),
              )
            ),
          ),
        )
      ],
    );
  }
}
