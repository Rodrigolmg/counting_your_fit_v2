import 'package:flutter/material.dart';

class TimerSettingsScreen extends StatefulWidget {
  const TimerSettingsScreen({Key? key}) : super(key: key);

  @override
  State<TimerSettingsScreen> createState() => _TimerSettingsScreenState();
}

class _TimerSettingsScreenState extends State<TimerSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('data'),
      ),
    );
  }
}
