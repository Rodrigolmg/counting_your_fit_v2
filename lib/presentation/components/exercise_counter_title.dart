part of presentation;

class ExerciseCounterTitle extends StatelessWidget {

  final int currentExercise;
  final int totalExerciseQuantity;

  const ExerciseCounterTitle({
    Key? key,
    required this.currentExercise,
    required this.totalExerciseQuantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.translate.get('exerciseTimer.exercise'),
          style: const TextStyle(
            fontSize: 35,
          ),
        ),
        const SizedBox(width: 15),
        Text(
          '$currentExercise',
          style: TextStyle(
            fontSize: 50,
            color: ColorApp.mainColor,
          ),
        ),
        const SizedBox(width: 15),
        Text(
          context.translate.get('exerciseTimer.of'),
          style: const TextStyle(
              fontSize: 35
          ),
        ),
        const SizedBox(width: 15),
        Text(
          '$totalExerciseQuantity',
          style: TextStyle(
            fontSize: 50,
            color: ColorApp.mainColor,
          ),
        ),
      ],
    );
  }
}
