import 'package:counting_your_fit_v2/app_localizations.dart';
import 'package:counting_your_fit_v2/context_extension.dart';
import 'package:counting_your_fit_v2/presentation/setting/bloc/exercises/exercise_list_states.dart';
import 'package:counting_your_fit_v2/presentation/setting/bloc/individual/individual_exercise_states.dart';
import 'package:flutter/material.dart';

class NotificationLabelBuilder {
  final BuildContext context;
  final IndividualExerciseState? individualState;
  final ExerciseListDefinitionStates? exerciseListDefinitionState;

  NotificationLabelBuilder(this.context, {
    this.individualState,
    this.exerciseListDefinitionState,
  });

  bool _isPortuguese = true;

  Map<String, String> build({
    int? currentSet,
    int? setQuantity,
    int? exerciseIndex,
  }){
    _isPortuguese = context.translate.isPortuguese;
    if(exerciseListDefinitionState != null) {
      return _buildExercisesLabel(exerciseIndex!, currentSet!, setQuantity!);
    } else {
      return _buildIndividualLabel(currentSet!, setQuantity!);
    }
  }

  Map<String, String> _buildExercisesLabel(int exerciseIndex, int currentSet, int setQuantity){

    String notificationTitle = '';
    String notificationBody = '';
    String currentExerciseLabel = '${context.translate.get('oneExercise')} ${exerciseIndex + 1}';


    if(exerciseListDefinitionState!.isCurrentResting){
      notificationTitle = '${context.translate.get('notification.restingTitle')}. $currentExerciseLabel';
      notificationBody = '${context.translate.get('notification.restingBody')} $currentSet';
    } else if(exerciseListDefinitionState!.isCurrentExecuting){
      notificationTitle = '${context.translate.get('notification.executingTitle')}. $currentExerciseLabel';
      notificationBody = '${context.translate.get('notification.executingBody')} $currentSet';
    } else if (exerciseListDefinitionState!.isCurrentExecuteFinished){
      notificationTitle = '${context.translate.get('notification.executingTitle')}. $currentExerciseLabel';
      notificationBody = '${context.translate.get('notification.executionFinishedBody')} $currentSet';
    } else if (exerciseListDefinitionState!.isCurrentRestFinished || exerciseListDefinitionState!.isCurrentNextSet){
      if(currentSet < setQuantity){
        String remainingLabel = context.translate.get('notification.remaining');
        String setLabel = context.translate.get('sets').toLowerCase();
        int remainingValue = setQuantity - currentSet;
        notificationTitle = '${context.translate.get('set')} $currentSet ${context.translate.get('notification.finished')}. $currentExerciseLabel';
        if(_isPortuguese){
          if(remainingValue == 1){
            remainingLabel = context.translate.get('notification.remainingSingular');
            setLabel = context.translate.get('set').toLowerCase();
          } else {
            remainingLabel = context.translate.get('notification.remaining');
            setLabel = context.translate.get('sets').toLowerCase();
          }
          notificationBody = '$remainingLabel ${setQuantity - currentSet} $setLabel. ${context.translate.get('notification.nextSet')} ${currentSet + 1}.';
        } else {
          setLabel = remainingValue == 1 ? context.translate.get('set').toLowerCase() :
            context.translate.get('sets').toLowerCase();
          notificationBody = '${setQuantity - currentSet} ${remainingLabel.replaceFirst('setLabel', setLabel)} ${context.translate.get('notification.nextSet')} ${currentSet + 1}.';
        }


      }
    } else if (exerciseListDefinitionState!.isExerciseListFinished){
      notificationTitle = '${context.translate.get('exercises')} ${context.translate.get('notification.finishedPlural')}';
      notificationBody = context.translate.get('notification.exerciseFinishedPlural');
    }


    return {
      'title': notificationTitle,
      'body': notificationBody
    };
  }

  Map<String, String> _buildIndividualLabel(int currentSet, int setQuantity){
    String notificationTitle = '';
    String notificationBody = '';

    if(individualState!.isResting){
      // Descansando da série X.; Resting of set X
      notificationTitle = context.translate.get('notification.restingTitle');
      notificationBody = '${context.translate.get('notification.restingBody')} $currentSet';
    } else if(individualState!.isExecuting){
      // Executando exercício/isometria da série X.; Executing exercise/isometrics of set X
      notificationTitle = context.translate.get('notification.executingTitle');
      notificationBody = '${context.translate.get('notification.executingBody')} $currentSet';
    } else if (individualState!.isExecuteFinished){
      // Fim da execução/isometria. Vamos descansar da série X.; Execution/isometrics finished. Let's rest of set X
      notificationTitle = context.translate.get('notification.executingTitle');
      notificationBody = '${context.translate.get('notification.executionFinishedTitle')} $currentSet';
    } else if (individualState!.isRestFinished || individualState!.isNextSet){
      // Falta(m) X série(s). Vamos para a série X.; X more sets to go. Let's go to set X
      if(currentSet < setQuantity){
        String remainingLabel = context.translate.get('notification.remaining');
        String setLabel = context.translate.get('sets').toLowerCase();
        int remainingValue = setQuantity - currentSet;
        notificationTitle = '${context.translate.get('set')} $currentSet ${context.translate.get('notification.finished')}.';
        if(_isPortuguese){
          if(remainingValue == 1){
            remainingLabel = context.translate.get('notification.remainingSingular');
            setLabel = context.translate.get('set').toLowerCase();
          } else {
            remainingLabel = context.translate.get('notification.remaining');
            setLabel = context.translate.get('sets').toLowerCase();
          }
          notificationBody = '$remainingLabel ${setQuantity - currentSet} $setLabel. ${context.translate.get('notification.nextSet')} ${currentSet + 1}.';
        } else {
          setLabel = remainingValue == 1 ? context.translate.get('set').toLowerCase() :
          context.translate.get('sets').toLowerCase();
          notificationBody = '${setQuantity - currentSet} ${remainingLabel.replaceFirst('setLabel', setLabel)} ${context.translate.get('notification.nextSet')} ${currentSet + 1}.';
        }

      }
    } else if (individualState!.isExerciseFinished){
      notificationTitle = '${context.translate.get('oneExercise')} ${context.translate.get('notification.finished')}';
      notificationBody = context.translate.get('notification.exerciseFinished');
    }

    return {
      'title': notificationTitle,
      'body': notificationBody
    };
  }
}