import 'package:counting_your_fit_v2/data/model/exercise_setting_model.dart';
import 'package:counting_your_fit_v2/presentation/util/punctuation/abstract_ponctuation.dart';
import 'package:flutter/material.dart';

class DynamicLabel {


  static String restTimeOutlineLabel(int minute, int second) {
    String sMinute = '$minute';
    String sSecond = '$second';


    if(minute < 10){
      sMinute = '0$minute';
    }

    if(second < 10){
      sSecond = '0$second';
    }

    String time = '$sMinute:$sSecond';
    return time;
  }


  static String setsInformation(int currentSet, ExerciseSettingModel? restSettingDy,
      {@required String? sets, @required String? ofSet}) {

    ExerciseSettingModel exerciseSetting = restSettingDy ?? ExerciseSettingModel(set: 1, minute: 0, second: 0);

    return (exerciseSetting.second != 0 || exerciseSetting.minute != 0) ?
    '$sets $currentSet $ofSet ${exerciseSetting.set}' : '';
  }

  static String labelWithPunctuation(String sentence, AbstractPunctuation punctuation,
      {String? localeString = 'en', AbstractPunctuation? esPunctuation}){

    if(localeString == 'es') {
      return '${esPunctuation!.getPunctuation()}$sentence${punctuation.getPunctuation()}';
    }

    return '$sentence${punctuation.getPunctuation()}';
  }

  static String notificationTitle(String title, {String? lastSet = ''}) => '$title $lastSet';

  static String notificationBody(String bodyValue, {
    String? timeValue = '', String? localeString = 'en', AbstractPunctuation? esPunctuation}) {

    String body = '$timeValue $bodyValue';

    if(localeString == 'es'){
      body = '${esPunctuation!.getPunctuation()}$bodyValue $timeValue';
    } else if (localeString == 'pt'){
      body = '$bodyValue $timeValue';
    }

    return body;
  }

}