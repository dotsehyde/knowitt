import 'dart:math';

import 'package:animated_background/animated_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:knowitt/controller/auh_controller.dart';
import 'package:knowitt/controller/game_controller.dart';
import 'package:knowitt/controller/game_state.dart';
import 'package:knowitt/core/config/hive_box.dart';
import 'package:knowitt/core/constant/const.dart';
import 'package:knowitt/core/constant/theme.dart' as t;
import 'package:knowitt/model/user.dart';
import 'package:knowitt/pages/auth.dart';
import 'package:knowitt/pages/quiz.dart';
import 'package:knowitt/widgets/bg_particles.dart';
import 'package:knowitt/widgets/loading_dialog.dart';
import 'package:knowitt/widgets/web_leaderboard.dart';
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
  void initState() {
    ref.read(authControllerProvider).listenUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<GameState>(gameControllerProvider, (_, state) {
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
          Navigator.of(context).pop();
          showDialog(
              barrierColor: Colors.white24,
              context: context,
              builder: (context) {
                return const InitMessageBox();
              });

          break;
        default:
      }
    });
    final gameController = ref.read(gameControllerProvider.notifier);
    return ValueListenableBuilder(
        valueListenable: LocalDB.localUser.listenable(),
        builder: (context, box, _) {
          final user = box.get(0)!;

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
                    child: Builder(builder: (context) {
                      if (size.maxWidth <= 700 && isWebMobile) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(height: 10.h),
                            SizedBox(
                              width: size.maxWidth,
                              height: isWeb
                                  ? size.maxHeight * 0.17
                                  : size.maxHeight * 0.1,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 26.sp,
                                    backgroundColor: t.primaryColor,
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(user.username,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.sp,
                                                  fontFamily: "Pixel"))
                                          .paddingSymmetric(horizontal: 2.w),
                                      Divider(
                                        color: Colors.white,
                                        thickness: 1,
                                        indent: 5.w,
                                        endIndent: 5.w,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                  count(user.questionsAnswered),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          isWeb ? 17.sp : 15.sp,
                                                      fontFamily: "Pixel")),
                                              Text("Questions",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          isWeb ? 17.sp : 15.sp,
                                                      fontFamily: "Pixel")),
                                            ],
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(count(user.questionsCorrect),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          isWeb ? 17.sp : 15.sp,
                                                      fontFamily: "Pixel")),
                                              Text("Correct",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          isWeb ? 17.sp : 15.sp,
                                                      fontFamily: "Pixel")),
                                            ],
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(count(user.questionsWrong),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          isWeb ? 17.sp : 15.sp,
                                                      fontFamily: "Pixel")),
                                              Text("Wrong",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          isWeb ? 17.sp : 15.sp,
                                                      fontFamily: "Pixel")),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ).expand()
                                ],
                              ),
                            ).paddingSymmetric(horizontal: 2.w),
                            const Spacer(),
                            TextButton(
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5.w, vertical: 1.5.h),
                                    backgroundColor:
                                        t.primaryColor.withOpacity(0.8),
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
                                    backgroundColor:
                                        t.primaryColor.withOpacity(0.8),
                                    elevation: 10),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomePage()));
                                },
                                child: Text("Leaderboard",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontFamily: "Pixel"))),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.w, vertical: 1.5.h),
                                        backgroundColor:
                                            t.primaryColor.withOpacity(0.8),
                                        elevation: 10),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const HomePage()));
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
                                              title: const Text("Sign Out"),
                                              icon:
                                                  const Icon(Icons.exit_to_app),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16)),
                                              elevation: 10,
                                              backgroundColor: t.darkBlue,
                                              content: const Text(
                                                  "Are you sure you want to sign out?"),
                                              shadowColor: Colors.white70,
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("No")),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      FirebaseAuth.instance
                                                          .signOut()
                                                          .then((value) => Navigator
                                                              .pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              const AuthPage())));
                                                    },
                                                    child: const Text("Yes")),
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
                            )
                                .paddingSymmetric(horizontal: 3.w)
                                .paddingBottom(1.h),

                            // SizedBox(height: 20.h),
                          ],
                        );
                      } else if (size.maxWidth <= 700) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "KnowItt!",
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Kwk',
                                ),
                              ).paddingBottom(2.h),
                              Text(
                                "Knowitt requires a larger screen size to play",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Pixel',
                                ),
                              ).paddingSymmetric(horizontal: 5.w),
                            ],
                          ),
                        );
                      }
                      return const WebInterface();
                    })),
              );
            }),
          );
        });
  }
}

class WebInterface extends ConsumerStatefulWidget {
  const WebInterface({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WebInterfaceState();
}

class _WebInterfaceState extends ConsumerState<WebInterface> {
  @override
  Widget build(BuildContext context) {
    final gameController = ref.watch(gameControllerProvider.notifier);
    return ValueListenableBuilder(
        valueListenable: LocalDB.localUser.listenable(),
        builder: (context, box, _) {
          final user = box.get(0)!;
          return LayoutBuilder(builder: (context, size) {
            return Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.maxWidth * 0.02,
                  ),
                  width: size.maxWidth * 0.7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(height: 10.h),
                      SizedBox(
                        width: size.maxWidth,
                        height: isWeb
                            ? size.maxHeight * 0.18
                            : size.maxHeight * 0.1,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 26.sp,
                              backgroundColor: t.primaryColor,
                              backgroundImage: user.avatar == null
                                  ? null
                                  : NetworkImage(user.avatar!),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(user.username,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.sp,
                                            fontFamily: "Pixel"))
                                    .paddingSymmetric(horizontal: 2.w),
                                Divider(
                                  color: Colors.white,
                                  thickness: 0.5,
                                  indent: 5.w,
                                  endIndent: 5.w,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(count(user.questionsAnswered),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: isWeb ? 17.sp : 15.sp,
                                                fontFamily: "Pixel")),
                                        Text("Questions",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: isWeb ? 16.sp : 15.sp,
                                                fontFamily: "Pixel")),
                                      ],
                                    ),
                                    VerticalDivider(
                                      color: Colors.white,
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(count(user.questionsCorrect),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: isWeb ? 17.sp : 15.sp,
                                                fontFamily: "Pixel")),
                                        Text("Correct",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: isWeb ? 16.sp : 15.sp,
                                                fontFamily: "Pixel")),
                                      ],
                                    ),
                                    VerticalDivider(
                                      color: Colors.white,
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(count(user.questionsWrong),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: isWeb ? 17.sp : 15.sp,
                                                fontFamily: "Pixel")),
                                        Text("Wrong",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: isWeb ? 16.sp : 15.sp,
                                                fontFamily: "Pixel")),
                                      ],
                                    ),
                                  ],
                                ).expand(),
                              ],
                            ).expand()
                          ],
                        ),
                      ).paddingSymmetric(horizontal: 2.w),
                      const Spacer(),
                      TextButton(
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.w, vertical: 1.5.h),
                              backgroundColor: t.primaryColor.withOpacity(0.8),
                              elevation: 10),
                          onPressed: () {
                            // gameController.initGame();
                          },
                          child: Text("Play Campaign",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontFamily: "Pixel"))),

                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5.w, vertical: 1.5.h),
                                  backgroundColor:
                                      t.primaryColor.withOpacity(0.8),
                                  elevation: 10),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomePage()));
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
                                        title: const Text("Sign Out"),
                                        icon: const Icon(Icons.exit_to_app),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        elevation: 10,
                                        backgroundColor: t.darkBlue,
                                        content: const Text(
                                            "Are you sure you want to sign out?"),
                                        shadowColor: Colors.white70,
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("No")),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                FirebaseAuth.instance
                                                    .signOut()
                                                    .then((value) => Navigator
                                                        .pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const AuthPage())));
                                              },
                                              child: const Text("Yes")),
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
                SizedBox(
                    width: size.maxWidth * 0.3, child: const WebLeaderBoard()),
              ],
            );
          });
        });
  }
}

class InitMessageBox extends ConsumerWidget {
  const InitMessageBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 20,
      contentPadding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Are you Ready?",
            style: TextStyle(fontSize: 25.sp, fontFamily: "gunk"),
          ).paddingBottom(1.h),
          Text(
            "You have 30 seconds to answer each question",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.sp, fontFamily: "pixel"),
          ).paddingSymmetric(vertical: 1.h),
          TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: t.primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50))),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QuizPage(),
                  ),
                );
              },
              child: Text(
                "Start Quiz",
                style: TextStyle(
                    fontSize: 22.sp, fontFamily: "debug", color: Colors.white),
              )),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Hold on!",
                style: TextStyle(fontSize: 20.sp, fontFamily: "gunk"),
              )),
        ],
      ),
    );
  }
}
