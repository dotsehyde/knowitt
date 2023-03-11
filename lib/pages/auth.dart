import 'dart:async';
import 'dart:math';

import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowitt/controller/auh_controller.dart';
import 'package:knowitt/core/constant/const.dart';
import 'package:knowitt/core/constant/theme.dart';
import 'package:knowitt/pages/home.dart';
import 'package:knowitt/widgets/bg_particles.dart';
import 'package:knowitt/widgets/message_dialog.dart';
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
    final controller = ref.watch(authControllerProvider);
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
                            horizontal: 5.w, vertical: 2.h),
                        backgroundColor: primaryColor,
                        elevation: 10),
                    onPressed: () {
                      controller.googleSignIn().then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                      }).catchError((e) {
                        print(e);
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  elevation: 20,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 2.h, horizontal: 5.w),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Error",
                                        style: TextStyle(
                                            fontSize: 23.sp,
                                            fontFamily: "gunk"),
                                      ).paddingBottom(1.h),
                                      Text(
                                        e.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            fontFamily: "pixel"),
                                      ).paddingSymmetric(vertical: 1.h),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "Okay",
                                            style: TextStyle(
                                                fontSize: 20.sp,
                                                fontFamily: "gunk"),
                                          )),
                                    ],
                                  ),
                                ));
                      });
                    },
                    child: controller.status == AuthState.waiting
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          )
                        : Text("Continue with Google",
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
