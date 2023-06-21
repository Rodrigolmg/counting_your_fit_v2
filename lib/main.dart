import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:counting_your_fit_v2/app_injector.dart';
import 'package:counting_your_fit_v2/app_localizations.dart';
import 'package:counting_your_fit_v2/color_app.dart';
import 'package:counting_your_fit_v2/counting_your_fit_router.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initNotification();
  initInjector();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) => runApp(const CountingYourFit()));
  runApp(
    const CountingYourFit()
  );
}

void initInjector(){
  AppInjector appInjector = AppInjector();
  appInjector.setup();
}

void initNotification(){
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'ind',
        channelName: 'Individual Exercise',
        channelDescription: 'Channel for individual exercise notification',
        defaultColor: ColorApp.backgroundColor,
        onlyAlertOnce: true,

      ),
      NotificationChannel(
        channelKey: 'list',
        channelName: 'Exercises',
        channelDescription: 'Channel for exercise list notification',
        defaultColor: ColorApp.backgroundColor,
        onlyAlertOnce: true,
      ),
    ]
  );
}

class CountingYourFit extends StatelessWidget {
  const CountingYourFit({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      localeResolutionCallback: (locale, supportedLocales) {

        for(var supportedLocale in supportedLocales){
          if(supportedLocale.languageCode == locale?.languageCode
              && supportedLocale.countryCode == locale?.countryCode){
            return supportedLocale;
          }
        }

        return supportedLocales.first;
      },
      theme: ThemeData(
        fontFamily: GoogleFonts.dmSans().fontFamily,
        scaffoldBackgroundColor: ColorApp.backgroundColor,
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: ColorApp.backgroundColor,
        ),
      ),
      initialRoute: CountingYourFitRoutes.splashScreen,
      onGenerateRoute: CountingYourFitRouter.getRoutes,
    );
  }
}
