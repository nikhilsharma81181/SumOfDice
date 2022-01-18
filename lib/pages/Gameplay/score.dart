import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:sum_of_dice/controller/game_ctrl.dart';
import 'package:sum_of_dice/controller/settings_ctrl.dart';

class Score extends StatefulWidget {
  const Score({Key? key}) : super(key: key);

  @override
  _ScoreState createState() => _ScoreState();
}

class _ScoreState extends State<Score> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    int totalPoints = context.watch<GameCtrl>().totalPoints;
    int highScore = context.watch<SettingsCtrl>().highScore;
    int lang = context.watch<SettingsCtrl>().language;
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/images/background.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: width * 0.37),
          Container(
            width: width,
            height: width * 0.7,
            color: const Color(0xFF96130E),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/gameover.svg',
                  width: width * 0.67,
                ),
                SizedBox(height: width * 0.1),
                scoreHs(
                    lang == 0
                        ? 'SCORE'
                        : lang == 1
                            ? 'СЧЁТ'
                            : '分数',
                    totalPoints),
                SizedBox(height: width * 0.035),
                scoreHs(
                    lang == 0
                        ? 'BEST RESULT'
                        : lang == 1
                            ? 'ЛУЧШИЙ РЕЗУЛЬТАТ'
                            : '最好的结果',
                    highScore),
              ],
            ),
          ),
          SizedBox(height: width * 0.12),
          btn(() {
            context.read<GameCtrl>().scorePgState(false);
            context.read<GameCtrl>().cancelTimer();
            context.read<GameCtrl>().startCountDown(context);
          },
              lang == 0
                  ? 'RESTART'
                  : lang == 1
                      ? 'РЕСТАРТ'
                      : '重新开始'),
          SizedBox(height: width * 0.085),
          btn(
            () {
              if (totalPoints > highScore) {
                context.read<SettingsCtrl>().changeHighScore(totalPoints);
              }
              Navigator.of(context).pop();
              context.read<GameCtrl>().scorePgState(false);
              context.read<GameCtrl>().cancelTimer();
            },
            lang == 0
                ? 'MAIN MENU'
                : lang == 1
                    ? 'ГЛАВНОЕ МЕНЮ'
                    : '主菜单',
          ),
        ],
      ),
    );
  }

  Widget scoreHs(key, value) {
    double width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          key,
          style: TextStyle(
            fontSize: width * 0.068,
            color: Colors.white,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          ': $value',
          style: TextStyle(
            fontSize: width * 0.068,
            color: Colors.white,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget btn(Function() fn, String text) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: fn,
      child: Stack(
        children: [
          Positioned(
            child: Align(
              alignment: Alignment.center,
              child: SvgPicture.asset(
                'assets/images/goverbtnbg.svg',
                width: width * 0.67,
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: width * 0.065,
                  fontWeight: FontWeight.w800,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
