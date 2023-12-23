import 'package:counting_your_fit_v2/access_status.dart';
import 'package:counting_your_fit_v2/color_app.dart';
import 'package:counting_your_fit_v2/context_extension.dart';
import 'package:counting_your_fit_v2/counting_your_fit_router.dart';
import 'package:counting_your_fit_v2/presentation/intro/bloc/intro_screen_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/intro/pages/fit_registering_page.dart';
import 'package:counting_your_fit_v2/presentation/intro/pages/notification_permission_page.dart';
import 'package:counting_your_fit_v2/presentation/intro/pages/other_exercises_page.dart';
import 'package:counting_your_fit_v2/presentation/intro/pages/overlay_permission_page.dart';
import 'package:counting_your_fit_v2/presentation/intro/pages/question_page.dart';
import 'package:counting_your_fit_v2/presentation/intro/pages/solution_page.dart';
import 'package:counting_your_fit_v2/presentation/intro/pages/workout_page.dart';
import 'package:counting_your_fit_v2/presentation/util/custom_intro_page_view_scroll_physics.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
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
  bool isOverlaySet = false;
  bool isNotificationAllowed = false;
  Widget? navSuffix;
  ScrollPhysics pageViewScrollPhysics = const AlwaysScrollableScrollPhysics();

  _changePage(int pageIndex){
    _pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 700),
      curve: Curves.ease
    );
  }

  showOverlayDialog() async {
    bool? overlayPermissionStatus = await FlutterOverlayWindow.isPermissionGranted();

    if(!overlayPermissionStatus){
      if(context.mounted){
        showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              backgroundColor: ColorApp.mainColor,
              elevation: 2,
              title: Text(
                context.translate.get('intro.overlayDialogTitle'),
                style: TextStyle(
                  color: ColorApp.backgroundColor,
                  shadows: const [
                    Shadow(
                      color: Colors.black54,
                      offset: Offset(1, 1)
                    )
                  ]
                ),
              ),
              content: Text(
                context.translate.get('intro.overlayDialogContent'),
                style: TextStyle(
                  color: ColorApp.backgroundColor,
                  shadows: const [
                    Shadow(
                        color: Colors.black54,
                        offset: Offset(1, 1)
                    )
                  ]
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      bool? isSet = await FlutterOverlayWindow.requestPermission();
                      setState(() {
                        isOverlaySet = true;
                        pageViewScrollPhysics = const AlwaysScrollableScrollPhysics();
                      });
                      if(context.mounted && isSet != null){
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      context.translate.get('yes'),
                      style: TextStyle(
                        color: ColorApp.agreeColor,
                        fontSize: 20,
                        shadows: const [
                          Shadow(
                              color: Colors.black54,
                              offset: Offset(1, 1)
                          )
                        ]
                      ),
                    )
                ),
                TextButton(
                    onPressed: (){
                      setState(() {
                        isOverlaySet = true;
                        pageViewScrollPhysics = const AlwaysScrollableScrollPhysics();
                      });
                      Navigator.pop(context);
                    },
                    child: Text(
                      context.translate.get('no'),
                      style: TextStyle(
                        color: ColorApp.errorColor2,
                        fontSize: 20,
                        shadows: const [
                          Shadow(
                            color: Colors.black54,
                            offset: Offset(1, 1)
                          )
                        ]
                      ),
                    )
                ),
              ],
            );
          }
        );
      }
    }

  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AccessStatus.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: pageViewScrollPhysics,
        onPageChanged: (page){
          setState(() {
            _pageIndex = page;
            if(!isOverlaySet){
              pageViewScrollPhysics = page == 5 ?
                const NeverScrollableScrollPhysics() :
                const AlwaysScrollableScrollPhysics();
            } else {
              pageViewScrollPhysics = const AlwaysScrollableScrollPhysics();
            }
          });
        },
        children: const [
          QuestionPage(),
          SolutionPage(),
          FitRegisteringPage(),
          OtherExercisesPage(),
          NotificationPermissionPage(),
          OverlayPermissionPage(),
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
              count: 7,
              effect: ExpandingDotsEffect(
                activeDotColor: ColorApp.mainColor,
                dotColor: Colors.grey
              ),
            ),
            if(_pageIndex == 5)
              if(!isOverlaySet)
                TextButton(
                  onPressed: (){
                    showOverlayDialog();
                  },
                  child: Text(
                    context.translate.get('intro.allow'),
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
            else if(_pageIndex == 6)
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
