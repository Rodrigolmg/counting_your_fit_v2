import 'package:counting_your_fit_v2/access_status.dart';
import 'package:counting_your_fit_v2/color_app.dart';
import 'package:counting_your_fit_v2/context_extension.dart';
import 'package:counting_your_fit_v2/counting_your_fit_router.dart';
import 'package:counting_your_fit_v2/presentation/intro/bloc/intro_screen_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/intro/pages/fit_registering_page.dart';
import 'package:counting_your_fit_v2/presentation/intro/pages/notification_permission_page.dart';
import 'package:counting_your_fit_v2/presentation/intro/pages/other_exercises_page.dart';
import 'package:counting_your_fit_v2/presentation/intro/pages/question_page.dart';
import 'package:counting_your_fit_v2/presentation/intro/pages/solution_page.dart';
import 'package:counting_your_fit_v2/presentation/intro/pages/workout_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/material.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {

  final PageController _pageController = PageController();
  int _pageIndex = 0;
  final introStateController = IntroScreenStateController();

  _changePage(int pageIndex){
    _pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 700),
      curve: Curves.ease
    );
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AccessStatus.reset();
    });
  }

  Widget? navSuffix;
  bool isNotificationAllowed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (page){
          setState(() {
            _pageIndex = page;
          });
        },
        children: const [
          QuestionPage(),
          SolutionPage(),
          FitRegisteringPage(),
          OtherExercisesPage(),
          NotificationPermissionPage(),
          WorkoutPage()
        ],
      ),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: (){
                  setState(() {
                    _pageIndex--;
                  });
                  _changePage(_pageIndex);
                },
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: _pageIndex > 0 ? ColorApp.mainColor : Colors.transparent,
                )
            ),
            AnimatedSmoothIndicator(
              activeIndex: _pageIndex,
              count: 6,
              effect: ExpandingDotsEffect(
                activeDotColor: ColorApp.mainColor,
                dotColor: Colors.grey
              ),
            ),
            if(_pageIndex == 5)
              TextButton(
                onPressed: (){
                  Navigator.pushReplacementNamed(
                      context, CountingYourFitRoutes.timerSetting
                  );
                },
                child: Text(
                  context.translate.get('intro.go'),
                  style: TextStyle(
                    color: ColorApp.mainColor,
                    fontWeight: FontWeight.bold,
                  ),
                )
              )
            else
              IconButton(
                  onPressed: (){
                    setState(() {
                      _pageIndex++;
                    });
                    _changePage(_pageIndex);
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: ColorApp.mainColor,
                  )
              )
          ],
        )
      ],
    );
  }
}
