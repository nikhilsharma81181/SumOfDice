import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:sum_of_dice/controller/game_ctrl.dart';
import 'package:sum_of_dice/controller/settings_ctrl.dart';
import 'package:sum_of_dice/pages/Gameplay/gameplay.dart';
import 'package:sum_of_dice/pages/Settings/settings.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final settingsCtrl = context.watch<SettingsCtrl>();
    return Scaffold(
      body: settingsCtrl.inSettings
          ? const Settings()
          : Stack(
              children: [
                Container(
                  width: width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/background.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                buildSettings(),
                headText(),
                bgdice(1, 0.87, 0.32),
                bgdice(2, 0.65, 0.64),
                bgdice(3, 0.4, 0.12),
                bgdice(4, -0.2, 0.32),
                start(),
              ],
            ),
    );
  }

  Widget buildSettings() {
    double width = MediaQuery.of(context).size.width;
    return Positioned(
      top: width * 0.15,
      right: width * 0.08,
      child: GestureDetector(
        onTap: () {
          context.read<SettingsCtrl>().settingState(true);
        },
        child: SvgPicture.asset(
          'assets/images/settings.svg',
        ),
      ),
    );
  }

  Widget start() {
    double width = MediaQuery.of(context).size.width;
    int lang = context.watch<SettingsCtrl>().language;
    return Positioned(
      top: width * 1.1,
      width: width,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  context.read<GameCtrl>().generateOptions();
                  context.read<GameCtrl>().removeNote(true);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Gameplay()));
                },
                child: SvgPicture.asset(
                  'assets/images/goverbtnbg.svg',
                  width: width * 0.75,
                ),
              ),
            ],
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                lang == 0
                    ? 'START'
                    : lang == 1
                        ? 'СТАРТ'
                        : '开始',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: width * 0.1,
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

  Widget headText() {
    double width = MediaQuery.of(context).size.width;
    return Positioned(
      top: width * 0.57,
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/sodtext.svg',
            width: width * 0.6,
          ),
        ],
      ),
    );
  }

  Widget bgdice(int index, double pb, pr) {
    double width = MediaQuery.of(context).size.width;
    return Positioned(
      bottom: width * pb,
      right: width * pr,
      child: SvgPicture.asset(
        'assets/images/dicebg$index.svg',
        // width: width * size,
        // height: width * size,
      ),
    );
  }
}
