import 'package:counting_your_fit_v2/app_localizations.dart';
import 'package:counting_your_fit_v2/color_app.dart';
import 'package:counting_your_fit_v2/counting_your_fit_router.dart';
import 'package:counting_your_fit_v2/presentation/setting/timer_settings_screen.dart';
import 'package:counting_your_fit_v2/presentation/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CountingYourFit());
}

class CountingYourFit extends StatelessWidget {
  const CountingYourFit({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        scaffoldBackgroundColor: ColorApp.backgroundColor,
      ),
      initialRoute: CountingYourFitRoutes.splashScreen,
      onGenerateRoute: CountingYourFitRouter.getRoutes,
    );
  }
}
