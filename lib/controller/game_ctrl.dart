import 'dart:async';

import 'dart:math';

import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:sum_of_dice/controller/settings_ctrl.dart';

class GameCtrl extends ChangeNotifier {
  Timer timer = Timer.periodic(const Duration(milliseconds: 0), (timer) {});
  bool note = true;
  bool isScore = false;
  int totalPoints = 0;
  int quesNum = 1;
  List optionList = [];
  List colorList = [];
  List checkOldNum = [];
  List suffle = [
    [0, 1],
    [2, 3],
    [4, 5],
    [6, 7],
  ];

  int countDown = 3;

  startCountDown(BuildContext context,) {
    generateOptions();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      countDown--;
      notifyListeners();
      if (countDown < 0 && isScore == false) {
        countDown = 3;
        isScore = true;
        context.read<SettingsCtrl>().playErr();
        timer.cancel();
      }
    });
  }



  cancelTimer() {
    countDown = 3;
    timer.cancel();
    notifyListeners();
  }

  removeNote(value) {
    note = value;
    notifyListeners();
  }

  scorePgState(value) {
    isScore = value;
    if (value == false) {
      totalPoints = 0;
    }
    notifyListeners();
  }

  addTotalPoints() {
    totalPoints = totalPoints + 5;
    countDown = 3;
    notifyListeners();
  }

  generateOptions() {
    optionList = [];
    colorList = [];
    for (var i = 0; i < 8; i++) {
      Random random = Random();
      int number = random.nextInt(6 - 1) + 1;
      optionList.add(number);
      ranColor();
    }
    Random random = Random();
    int index = random.nextInt(4);
    int suffleValue1 = suffle[index][0];
    int suffleValue2 = suffle[index][1];
    quesNum = optionList[suffleValue1] + optionList[suffleValue2];
    checkOldNum.add(quesNum);
    checkDupOpt();
    notifyListeners();
  }

  checkPrevNum() {
    if (checkOldNum.contains(quesNum)) {
      generateOptions();
      checkOldNum.clear();
    }
  }

  checkDupOpt() {
    List dupNum = [];
    for (var i = 0; i < 4; i++) {
      int val1 = suffle[i][0];
      int val2 = suffle[i][1];
      dupNum.add(optionList[val1] + optionList[val2]);
      dupNum.sort();
    }
    List names = [];
    for (var u in dupNum) {
      if (names.contains(u)) {
        generateOptions();
      } else {
        names.add(u);
      }
    }
    notifyListeners();
  }

  ranColor() {
    Random random = Random();
    int index = random.nextInt(3 - 1) + 1;
    colorList.add(index);
    notifyListeners();
  }
}
