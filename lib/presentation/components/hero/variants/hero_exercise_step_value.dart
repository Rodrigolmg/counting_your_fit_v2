part of presentation;

class HeroExerciseStepValue extends StatefulWidget {

  final String? heroTag;

  const HeroExerciseStepValue({
    super.key,
    required this.heroTag,
  });

  @override
  State<HeroExerciseStepValue> createState() => _HeroExerciseStepValueState();
}

class _HeroExerciseStepValueState extends State<HeroExerciseStepValue> {

  final stepStateController = GetIt.I.get<StepStateController>();
  int steps = 2;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Hero(
          tag: widget.heroTag!,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: ColorApp.mainColor,
            elevation: 2,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(100, 60, 100, 40),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        BlocBuilder<StepStateController, StepsState>(
                          bloc: stepStateController,
                          buildWhen: (oldState, currentState) =>
                            currentState.isStepDefined,
                          builder: (context, state) {

                            if(state.isStepDefined){
                              steps = (state as StepDefined).steps;
                            }

                            return NumberPicker(
                                minValue: 2,
                                maxValue: 10,
                                value: steps,
                                infiniteLoop: true,
                                itemHeight: 35,
                                selectedTextStyle: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 25,
                                ),
                                textStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 20
                                ),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      color: Colors.lightBlue,
                                      width: .3,
                                    ),
                                    right: BorderSide(
                                      color: Colors.lightBlue,
                                      width: .3,
                                    ),
                                  )
                                ),
                                onChanged: (value){
                                  stepStateController.setSteps(value);
                                  // setState(() {});
                                }
                            );
                          },
                        )
                      ],
                    )
                  ),
                ),
                Positioned(
                  right: 5,
                  child: IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                      color: ColorApp.backgroundColor,
                    )
                  )
                )
              ],
            ),
          )
        ),
      ),
    );
  }
}
