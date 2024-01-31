part of presentation;

class SolutionPage extends StatelessWidget {
  const SolutionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: ColorApp.backgroundColor
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: SizedBox(
                width: 300,
                height: 300,
                child: RiveAnimation.asset(
                  'assets/anims/lightbulb.riv',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: context.width * .8,
              child: Text(
                context.translate.get('intro.secondPageLabel'),
                style: TextStyle(
                  color: ColorApp.mainColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}