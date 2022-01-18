import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:sum_of_dice/controller/game_ctrl.dart';
import 'package:sum_of_dice/controller/settings_ctrl.dart';
import 'package:sum_of_dice/pages/Gameplay/score.dart';

class Gameplay extends StatefulWidget {
  const Gameplay({Key? key}) : super(key: key);

  @override
  _GameplayState createState() => _GameplayState();
}

class _GameplayState extends State<Gameplay> {
  @override
  Widget build(BuildContext context) {
    bool isScore = context.watch<GameCtrl>().isScore;
    bool note = context.watch<GameCtrl>().note;
    int lang = context.watch<SettingsCtrl>().language;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: isScore
          ? const Score()
          : Stack(
              children: [
                Container(
                  width: width,
                  height: height,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage(
                      'assets/images/background.png',
                    ),
                    fit: BoxFit.cover,
                  )),
                  child: SafeArea(
                    child: Column(
                      children: [
                        header(),
                        SizedBox(height: width * 0.15),
                        randomNum(),
                        SizedBox(height: width * 0.29),
                        optionBoard(),
                      ],
                    ),
                  ),
                ),
                if (note)
                  GestureDetector(
                    onTap: () {
                      context.read<GameCtrl>().removeNote(false);
                      context.read<GameCtrl>().startCountDown(context);
                      context.read<SettingsCtrl>().playDice();
                    },
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                          Colors.grey.withOpacity(0.7), BlendMode.srcOut),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        padding: EdgeInsets.only(
                          right: width * 0.02,
                          top: width * 0.04,
                        ),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: SafeArea(
                            child: Container(
                              margin:
                                  const EdgeInsets.only(right: 4, bottom: 4),
                              height: width * 0.25,
                              width: width * 0.25,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (note)
                  Positioned(
                    top: width * 0.55,
                    width: width,
                    child: Column(
                      children: [
                        SizedBox(
                          width: width * 0.6,
                          child: Text(
                            lang == 0
                                ? 'YOU HAVE THREE SECONDS'
                                : lang == 1
                                    ? 'У ВАС ЕСТЬ 3 СЕКУНДЫ'
                                    : '你有三秒钟',
                            style: TextStyle(
                              fontSize: width * 0.065,
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: width * 0.047),
                        Text(
                          '3',
                          style: TextStyle(
                            fontSize: width * 0.57,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }

  Widget optionBoard() {
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        SvgPicture.asset(
          'assets/images/bgtable.svg',
          width: width * 0.9,
        ),
        Positioned.fill(
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: width * 0.05),
              width: 5,
              color: const Color(0xFFA9241F),
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              height: 5,
              margin: EdgeInsets.symmetric(horizontal: width * 0.05),
              color: const Color(0xFFA9241F),
            ),
          ),
        ),
        options(),
      ],
    );
  }

  Widget options() {
    double width = MediaQuery.of(context).size.width;
    return Positioned.fill(
      child: Padding(
        padding: EdgeInsets.all(width * 0.032),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                dicePair(0),
                dicePair(2),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                dicePair(4),
                dicePair(6),
              ],
            ),
          ],
        ),
      ),
    );
  }

  dicePair(val) {
    double width = MediaQuery.of(context).size.width;
    List optionList = context.watch<GameCtrl>().optionList;
    List colorList = context.watch<GameCtrl>().colorList;
    int quesNum = context.watch<GameCtrl>().quesNum;
    int val1 = optionList[val];
    int val2 = optionList[(val + 1)];
    String col1 = colorList[val] == 1 ? 'd' : 'l';
    String col2 = colorList[(val + 1)] == 1 ? 'd' : 'l';
    return GestureDetector(
      onTap: () {
        if ((val1 + val2) == quesNum) {
          context.read<GameCtrl>().addTotalPoints();
          context.read<GameCtrl>().generateOptions();
          context.read<SettingsCtrl>().playDice();
        } else {
          context.read<SettingsCtrl>().playErr();
          context.read<GameCtrl>().scorePgState(true);
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/images/dice/dice$val1$col1.svg',
            height: width * 0.132,
          ),
          SizedBox(width: width * 0.032),
          SvgPicture.asset(
            'assets/images/dice/dice$val2$col2.svg',
            height: width * 0.132,
          ),
        ],
      ),
    );
  }

  Widget randomNum() {
    double width = MediaQuery.of(context).size.width;
    bool note = context.watch<GameCtrl>().note;
    int quesNum = context.watch<GameCtrl>().quesNum;
    return note
        ? SizedBox(
            height: width * 0.37,
          )
        : SvgPicture.asset(
            'assets/images/num/$quesNum.svg',
            height: width * 0.37,
          );
  }

  header() {
    double width = MediaQuery.of(context).size.width;
    int totalPoints = context.watch<GameCtrl>().totalPoints;
    int countDown = context.watch<GameCtrl>().countDown;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: width * 0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              context.read<GameCtrl>().cancelTimer();
              Navigator.of(context).pop();
            },
            child: SvgPicture.asset(
              'assets/images/backarrow.svg',
              height: width * 0.13,
            ),
          ),
          subHeader('pointsbg', '$totalPoints'),
          subHeader('timerbg', '$countDown'),
        ],
      ),
    );
  }

  Widget subHeader(image, text) {
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        SvgPicture.asset(
          'assets/images/$image.svg',
          height: width * 0.13,
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: width * 0.065,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        )
      ],
    );
  }
}
