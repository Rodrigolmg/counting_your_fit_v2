import 'package:counting_your_fit_v2/access_status.dart';
import 'package:counting_your_fit_v2/color_app.dart';
import 'package:counting_your_fit_v2/context_extension.dart';
import 'package:counting_your_fit_v2/presentation/components/directional_button.dart';
import 'package:counting_your_fit_v2/presentation/setting/pages/exercise_list_page.dart';
import 'package:counting_your_fit_v2/presentation/setting/pages/individual_exercise_page.dart';
import 'package:counting_your_fit_v2/presentation/util/directional_shape.dart';
import 'package:flutter/material.dart';

class TimerSettingsScreen extends StatefulWidget {
  const TimerSettingsScreen({Key? key}) : super(key: key);

  @override
  State<TimerSettingsScreen> createState() => _TimerSettingsScreenState();
}

class _TimerSettingsScreenState extends State<TimerSettingsScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: (){},
          icon: const Icon(Icons.watch_off),
          color: ColorApp.mainColor,
        ),
      ),
      body: PageView(
        children: const [
          IndividualExercisePage(),
          ExerciseListPage()
        ],
      )
    );
  }


}
