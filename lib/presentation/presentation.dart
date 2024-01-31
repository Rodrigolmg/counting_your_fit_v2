library presentation;

import 'dart:async';
import 'dart:ui';
import 'package:after_layout/after_layout.dart';
import 'package:counting_your_fit_v2/domain/domain.dart';
import 'package:flutter/services.dart';

import 'util/util.dart';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:counting_your_fit_v2/access_status.dart';
import 'package:counting_your_fit_v2/app_localizations.dart';
import 'package:counting_your_fit_v2/color_app.dart';
import 'package:counting_your_fit_v2/context_extension.dart';
import 'package:counting_your_fit_v2/counting_your_fit_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:get_it/get_it.dart';
import 'package:im_stepper/stepper.dart';
import 'package:morphable_shape/morphable_shape.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rive/rive.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

part 'splash_screen.dart';

// bloc
part 'bloc/icon/button_icon_state.dart';
part 'bloc/icon/button_icon_state_controller.dart';
part 'bloc/label/additional_timer_label_state.dart';
part 'bloc/label/additional_timer_label_state_controller.dart';
part 'bloc/label/timer_label_state.dart';
part 'bloc/label/timer_label_state_controller.dart';
part 'bloc/minute/additional_minute_state.dart';
part 'bloc/minute/additional_minute_state_controller.dart';
part 'bloc/minute/minute_state.dart';
part 'bloc/minute/minute_state_controller.dart';
part 'bloc/seconds/additional_seconds_state.dart';
part 'bloc/seconds/additional_seconds_state_controller.dart';
part 'bloc/seconds/seconds_state.dart';
part 'bloc/seconds/seconds_state_controller.dart';
part 'bloc/sets/sets_state.dart';
part 'bloc/sets/sets_state_controller.dart';
part 'bloc/steps/steps_state.dart';
part 'bloc/steps/steps_state_controller.dart';

// components
part 'components/hero/variants/hero_exercise_additional_timer_values.dart';
part 'components/hero/variants/hero_exercise_sets_value.dart';
part 'components/hero/variants/hero_exercise_step_value.dart';
part 'components/hero/variants/hero_exercise_timer_values.dart';
part 'components/hero/variants/hero_variant.dart';
part 'components/hero/custom_rect_tween.dart';
part 'components/hero/hero_button.dart';
part 'components/hero/hero_router.dart';
part 'components/hero/hero_tag.dart';
part 'components/directional_button.dart';
part 'components/exercise_counter_title.dart';
part 'components/individual_exercise_helper_sheet.dart';
part 'components/set_counter_title.dart';
part 'components/shake_error.dart';

// intro
part 'intro/bloc/intro_screen_state_controller.dart';
part 'intro/bloc/intro_screen_states.dart';
part 'intro/pages/fit_registering_page.dart';
part 'intro/pages/notification_permission_page.dart';
part 'intro/pages/other_exercises_page.dart';
part 'intro/pages/overlay_permission_page.dart';
part 'intro/pages/question_page.dart';
part 'intro/pages/solution_page.dart';
part 'intro/pages/workout_page.dart';
part 'intro/intro_screen.dart';

// setting
part 'setting/bloc/definition/settings_definition_state_controller.dart';
part 'setting/bloc/definition/settings_definition_states.dart';
part 'setting/bloc/exercises/exercise_list_controller.dart';
part 'setting/bloc/exercises/exercise_list_states.dart';
part 'setting/bloc/individual/individual_exercise_controller.dart';
part 'setting/bloc/individual/individual_exercise_states.dart';
part 'setting/pages/exercise_list_page.dart';
part 'setting/pages/individual_exercise_page.dart';
part 'setting/exercise_step_setting_screen.dart';
part 'setting/timer_settings_screen.dart';

// sheet
part 'sheet/exercises_helper_sheet.dart';
part 'sheet/step_helper_sheet.dart';
part 'sheet/timer_helper_sheet.dart';

// timer
part 'timer/exercises/bloc/exercises_beep_volume_state_controller.dart';
part 'timer/exercises/bloc/exercises_beep_volume_states.dart';
part 'timer/exercises/exercise_list_timer.dart';
part 'timer/individual/bloc/beep/individual_beep_volume_state_controller.dart';
part 'timer/individual/bloc/beep/individual_beep_volume_states.dart';
part 'timer/individual/individual_exercise_timer.dart';

// util
