import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sum_of_dice/controller/saved_settings.dart';

class SettingsCtrl extends ChangeNotifier {
  Timer timer = Timer.periodic(const Duration(milliseconds: 0), (timer) {});
  bool inSettings = false;
  int highScore = 0;

  bool sound = true;
  bool vibrations = true;
  int language = 0;
  bool onLang = false;

  settingState(value) {
    inSettings = value;
    notifyListeners();
  }

  AudioPlayer audioPlayer = AudioPlayer();
  PlayerState audioPlayerState = PlayerState.PLAYING;
  AudioCache? audioCache;
  String path = 'Game.mp3';
  String errPath = 'Lose.mp3';
  String dicePath = 'Dice.mp3';

  startMusic() async {
    audioCache = AudioCache(fixedPlayer: audioPlayer);
    audioPlayer.onPlayerStateChanged.listen((event) {
      audioPlayerState = event;
    });
    await audioCache!.load(path);
    await audioCache!.load(errPath);
    notifyListeners();
  }

  play() async {
    await audioCache!.loop(path);
    notifyListeners();
  }

  playErr() async {
    await audioCache!.play(errPath);
    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      play();
      timer.cancel();
    });
    if (SavedSettings.getVib() == true) HapticFeedback.vibrate();
    notifyListeners();
  }

  playDice() async {
    await audioCache!.play(dicePath);
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      play();
      timer.cancel();
    });
    notifyListeners();
  }

  initSavedState() {
    if (SavedSettings.getSound() == null &&
        SavedSettings.getVib() == null &&
        SavedSettings.getLang() == null &&
        SavedSettings.getScore() == null) {
      SavedSettings.setSound(true);
      SavedSettings.setVibartions(true);
      SavedSettings.setLanguage(0);
      SavedSettings.setScore(0);
    } else {
      fetchAll(SavedSettings.getSound(), SavedSettings.getVib(),
          SavedSettings.getLang(), SavedSettings.getScore());
    }
    if (sound) {
      startMusic();
      play();
    }
    notifyListeners();
  }

  changeHighScore(int score) {
    highScore = score;
    SavedSettings.setScore(score);
    notifyListeners();
  }

  fetchAll(snd, vib, lang, score) {
    changeSound(snd);
    changeVibrations(vib);
    againChangeLang(lang);
    highScore = score;
    notifyListeners();
  }

  changeSound(value) async {
    sound = value;
    SavedSettings.setSound(value);
    startMusic();
    if (value == true) {
      await audioCache!.loop(path);
    } else {
      await audioPlayer.stop();
    }
    notifyListeners();
  }

  changeVibrations(value) {
    vibrations = value;
    SavedSettings.setVibartions(value);
    if (value) HapticFeedback.vibrate();
    notifyListeners();
  }

  changeLanguage() {
    if (language < 2) {
      language++;
    } else {
      language = 0;
    }
    changeOnLang();
    SavedSettings.setLanguage(language);
    notifyListeners();
  }

  againChangeLang(value) {
    language = value;
    notifyListeners();
  }

  changeOnLang() {
    onLang = true;
    timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      onLang = false;
      timer.cancel();
      notifyListeners();
    });
    notifyListeners();
  }
}
