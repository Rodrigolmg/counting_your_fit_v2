part of presentation;

class CustomSplashScreen extends StatefulWidget {
  const CustomSplashScreen({Key? key}) : super(key: key);

  @override
  State<CustomSplashScreen> createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen> with AfterLayoutMixin<CustomSplashScreen> {

  _onSplashEnd() async {

    bool isFirstAccess = await AccessStatus.setAccess();

    Future.delayed(
      const Duration(seconds: 4),
      (){
        Navigator.pushReplacementNamed(
            context, isFirstAccess ? CountingYourFitRoutes.introScreen
            : CountingYourFitRoutes.timerSetting
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: RiveAnimation.asset("assets/anims/clockanim.riv"),
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) => _onSplashEnd();
}
