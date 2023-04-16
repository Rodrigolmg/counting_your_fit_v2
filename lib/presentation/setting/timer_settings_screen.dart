import 'package:counting_your_fit_v2/access_status.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AccessStatus.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('data'),
      ),
    );
  }


}
