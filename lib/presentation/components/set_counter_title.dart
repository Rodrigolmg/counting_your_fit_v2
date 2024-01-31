part of presentation;

class SetCounterTitle extends StatelessWidget {

  final int currentSet;
  final int setQuantity;

  const SetCounterTitle({
    Key? key,
    required this.currentSet,
    required this.setQuantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.translate.get('exerciseTimer.set'),
          style: const TextStyle(
            fontSize: 35,
          ),
        ),
        const SizedBox(width: 15),
        Text(
          '$currentSet',
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
          '$setQuantity',
          style: TextStyle(
            fontSize: 50,
            color: ColorApp.mainColor,
          ),
        ),
      ],
    );
  }
}
