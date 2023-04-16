import 'package:counting_your_fit_v2/color_app.dart';
import 'package:counting_your_fit_v2/presentation/util/app_localizations.dart';
import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  AppLocalizations get translate => AppLocalizations.of(this)!;
}