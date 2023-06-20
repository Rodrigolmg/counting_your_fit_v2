import 'dart:async';
import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {

  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context){
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  Map<String, dynamic> _localizedStrings = {};

  Map<String, dynamic> flattenTranslations(Map<String, dynamic> json, [String prefix = '']){
    final Map<String, dynamic> flatMap = {};
    json.forEach((key, value) {
      if(value is Map<String, dynamic>){
        flatMap.addAll(flattenTranslations(value, '$prefix$key.'));
      } else {
        flatMap['$prefix$key'] = value.toString();
      }
    });

    return flatMap;
  }

  Future<bool> load() async {
    String jsonString = await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = flattenTranslations(jsonMap);

    return true;
  }

  String get(String key) {
    return _localizedStrings[key]!;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations>{

  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'pt'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }

}

extension AppLocalizationLang on AppLocalizations{
  bool get isPortuguese => locale.languageCode == 'pt';
  bool get isEnglish => locale.languageCode == 'en';
}