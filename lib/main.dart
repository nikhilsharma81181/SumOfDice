import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sum_of_dice/controller/game_ctrl.dart';
import 'package:sum_of_dice/controller/settings_ctrl.dart';
import 'package:sum_of_dice/pages/Home/homepage.dart';

import 'controller/saved_settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SavedSettings.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsCtrl()),
        ChangeNotifierProvider(create: (_) => GameCtrl()),
      ],
      child: const MaterialApp(
        title: 'FoodLa',
        debugShowCheckedModeBanner: false,
        home: Loading(),
      ),
    );
  }
}

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) return;

    final isBackground = state == AppLifecycleState.paused;

    if (isBackground) {
      context.read<SettingsCtrl>().changeSound(false);
    } else {
      context.read<SettingsCtrl>().changeSound(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(milliseconds: 200), () {
      context.read<SettingsCtrl>().initSavedState();
    });
    return const Homepage();
  }
}
