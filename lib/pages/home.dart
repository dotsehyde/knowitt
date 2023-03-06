import 'dart:io';
import 'dart:math';

import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowitt/controller/game_controller.dart';
import 'package:knowitt/controller/game_state.dart';
import 'package:knowitt/core/constant/const.dart';
import 'package:knowitt/core/constant/theme.dart' as t;
import 'package:knowitt/pages/quiz.dart';
import 'package:knowitt/widgets/bg_particles.dart';
import 'package:knowitt/widgets/loading_dialog.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    ref.listen<GameState>(gameControllerProvider, (_, state) {
      print(state.gameStatus);
      switch (state.gameStatus) {
        case GameStatus.initGame:
          showDialog(
              barrierColor: Colors.white24,
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return LoadingDialog(
                    text: initLoadingText[
                        Random().nextInt(initLoadingText.length - 1)]);
              });
          break;
        case GameStatus.gameReady:
          Navigator.of(context, rootNavigator: true).pop();
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => QuizPage(),
          //   ),
          // );
          break;
        default:
      }
    });
    final gameController = ref.read(gameControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "KnowItt!",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.normal,
            fontFamily: 'Kwk',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: LayoutBuilder(builder: (context, size) {
        return SizedBox(
          width: size.maxWidth,
          height: size.maxHeight,
          child: AnimatedBackground(
            vsync: this,
            behaviour: RandomParticleBehaviour(options: particles),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(height: 10.h),
                SizedBox(
                  width: size.maxWidth,
                  height: size.maxHeight * 0.1,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 26.sp,
                        backgroundColor: t.primaryColor,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Benjamin",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.sp,
                                      fontFamily: "pixel"))
                              .paddingSymmetric(horizontal: 2.w),
                          Divider(
                            color: Colors.white,
                            thickness: 1,
                            indent: 5.w,
                            endIndent: 5.w,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text("15",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17.sp,
                                          fontFamily: "pixel")),
                                  Text("Questions",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.sp,
                                          fontFamily: "pixel")),
                                ],
                              ),
                              VerticalDivider(
                                color: Colors.white,
                              ),
                              Column(
                                children: [
                                  Text("15",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17.sp,
                                          fontFamily: "pixel")),
                                  Text("Correct",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.sp,
                                          fontFamily: "pixel")),
                                ],
                              ),
                              VerticalDivider(
                                color: Colors.white,
                              ),
                              Column(
                                children: [
                                  Text("15",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17.sp,
                                          fontFamily: "pixel")),
                                  Text("Wrong",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.sp,
                                          fontFamily: "pixel")),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ).expand()
                    ],
                  ),
                ).paddingSymmetric(horizontal: 2.w),

                Spacer(),
                TextButton(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 1.5.h),
                        backgroundColor: t.primaryColor.withOpacity(0.8),
                        elevation: 10),
                    onPressed: () {
                      gameController.initGame();
                    },
                    child: Text("Play Campaign",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontFamily: "Pixel"))),
                SizedBox(height: 2.h),
                TextButton(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 1.5.h),
                        backgroundColor: t.primaryColor.withOpacity(0.8),
                        elevation: 10),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    child: Text("Leaderboard",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontFamily: "Pixel"))),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.w, vertical: 1.5.h),
                            backgroundColor: t.primaryColor.withOpacity(0.8),
                            elevation: 10),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        },
                        child: Text("Credits",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontFamily: "Pixel"))),
                    TextButton(
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.w, vertical: 1.5.h),
                            backgroundColor: Colors.red[600],
                            elevation: 10),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Exit"),
                                  icon: Icon(Icons.exit_to_app),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  elevation: 10,
                                  backgroundColor: t.darkBlue,
                                  content:
                                      Text("Are you sure you want to exit?"),
                                  shadowColor: Colors.white70,
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("No")),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          exit(0);
                                        },
                                        child: Text("Yes")),
                                  ],
                                );
                              });
                        },
                        child: Text("Exit",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontFamily: "Pixel"))),
                  ],
                ).paddingSymmetric(horizontal: 3.w).paddingBottom(1.h),

                // SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      }),
    );
  }
}
