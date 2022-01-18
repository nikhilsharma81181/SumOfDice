import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:sum_of_dice/controller/settings_ctrl.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool sound = context.watch<SettingsCtrl>().sound;
    bool vibrations = context.watch<SettingsCtrl>().vibrations;
    int lang = context.watch<SettingsCtrl>().language;
    bool onLang = context.watch<SettingsCtrl>().onLang;
    return Stack(
      children: [
        Container(
          width: width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        backBtn(),
        Positioned.fill(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              soundVib(
                lang == 0
                    ? 'soundtext'
                    : lang == 1
                        ? 'soundRus'
                        : 'soundCh',
                sound,
                0,
              ),
              soundVib(
                lang == 0
                    ? 'vibrationtext'
                    : lang == 1
                        ? 'vibrationRus'
                        : 'vibrationCh',
                vibrations,
                1,
              ),
              SizedBox(
                child: Column(
                  children: [
                    SvgPicture.asset(
                      lang == 0
                          ? 'assets/images/language/languagetext.svg'
                          : lang == 1
                              ? 'assets/images/language/langRus.svg'
                              : 'assets/images/language/langCh.svg',
                      height: width * 0.055,
                    ),
                    SizedBox(height: width * 0.04),
                    GestureDetector(
                      onTap: () {
                        context.read<SettingsCtrl>().changeOnLang();
                        context.read<SettingsCtrl>().changeLanguage();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: !onLang ? width * 0.16 : width * 0.12,
                        child: Image.asset(
                          lang == 0
                              ? 'assets/icons/uk.png'
                              : lang == 1
                                  ? 'assets/icons/russia.png'
                                  : 'assets/icons/china.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget soundVib(String text, value, int index) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SvgPicture.asset(
          'assets/images/language/$text.svg',
          height: width * 0.055,
        ),
        SizedBox(height: width * 0.05),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            button('on', value ? 's' : 'u', value, text, index),
            SizedBox(width: width * 0.04),
            button('off', value ? 'u' : 's', value, text, index),
          ],
        ),
        SizedBox(height: width * 0.17),
      ],
    );
  }

  Widget button(String onoff, selected, value, text, index) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          context.read<SettingsCtrl>().changeSound(!value);
        } else {
          context.read<SettingsCtrl>().changeVibrations(!value);
        }
      },
      child: selected == 's'
          ? SizedBox(
              width: width * 0.32,
              child: SvgPicture.asset(
                'assets/images/$onoff$selected.svg',
                width: width * 0.32,
              ),
            )
          : SizedBox(
              width: width * 0.32,
              child: SvgPicture.asset(
                'assets/images/$onoff$selected.svg',
                height: width * 0.055,
              ),
            ),
    );
  }

  Widget backBtn() {
    double width = MediaQuery.of(context).size.width;
    return Positioned(
      top: width * 0.15,
      left: width * 0.08,
      child: GestureDetector(
        onTap: () {
          context.read<SettingsCtrl>().settingState(false);
        },
        child: SvgPicture.asset(
          'assets/images/backarrow.svg',
          // width: width * size,
          // height: width * size,
        ),
      ),
    );
  }
}
