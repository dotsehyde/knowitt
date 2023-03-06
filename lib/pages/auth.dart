import 'dart:async';
import 'dart:math';

import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowitt/core/constant/const.dart';
import 'package:knowitt/core/constant/theme.dart';
import 'package:knowitt/pages/home.dart';
import 'package:knowitt/widgets/bg_particles.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage>
    with SingleTickerProviderStateMixin {
  List fonts = [
    {
      "name": "Gunk",
      "size": 38.sp,
    },
    {
      "name": "Debug",
      "size": 42.sp,
    },
    {
      "name": "Ugly",
      "size": 45.sp,
    },
    {
      "name": "Pixel",
      "size": 30.sp,
    },
    {
      "name": "Robus",
      "size": 42.sp,
    }
  ];
  late Timer timer;
  late Map<String, dynamic> font;
  @override
  void initState() {
    font = fonts[0];
    timer = Timer.periodic(1.seconds, (timer) {
      if (timer.tick % 5 == 0) {
        var i = Random().nextInt(fonts.length);
        setState(() {
          font = fonts.indexOf(font) == i
              ? fonts[i < fonts.length - 1 ? (i + 1) : (i - 1)]
              : fonts[i];
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, size) {
        return SizedBox(
          width: size.maxWidth,
          height: size.maxHeight,
          child: AnimatedBackground(
            vsync: this,
            behaviour: RandomParticleBehaviour(options: particles),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: 300.milliseconds,
                  child: Text(
                    "KnowItt!",
                    style: TextStyle(
                      fontSize: font["size"],
                      fontWeight: FontWeight.normal,
                      fontFamily: font["name"],
                    ),
                  ),
                ),
                Text(
                  "Lets play Quiz!",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: "Ugly",
                      fontSize: 28.sp),
                ).paddingSymmetric(vertical: 2.h),
                TextButton(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 1.5.h),
                        backgroundColor: primaryColor,
                        elevation: 10),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    child: Text("Continue with Google",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontFamily: "Pixel")))
              ],
            ),
          ),
        );
      }),
    );
  }
}
