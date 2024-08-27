library util;

import 'dart:async';

import 'package:counting_your_fit_v2/app_localizations.dart';
import 'package:counting_your_fit_v2/context_extension.dart';
import 'package:counting_your_fit_v2/data/data.dart';
import 'package:counting_your_fit_v2/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'dart:math';

part 'notification/notification_label_builder.dart';
part 'punctuation/abstract_ponctuation.dart';
part 'abstract_controller.dart';
part 'additional_timer_label.dart';
part 'animation_controller_state.dart';
part 'controller_strategy.dart';
part 'custom_intro_page_view_scroll_physics.dart';
part 'dynamic_label.dart';
part 'sine_curve.dart';

part 'overlay/enum/overlay_alignment.dart';
part 'overlay/enum/overlay_flag.dart';
part 'overlay/enum/overlay_notification_visibility.dart';
part 'overlay/enum/overlay_position_gravity.dart';
part 'overlay/overlay_window_size.dart';
part 'overlay/overlay_controller.dart';