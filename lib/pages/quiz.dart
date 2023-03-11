import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowitt/controller/game_controller.dart';
import 'package:knowitt/controller/game_state.dart';
import 'package:knowitt/core/constant/theme.dart' as t;
import 'package:knowitt/model/question.dart';
import 'package:knowitt/pages/home.dart';
import 'package:knowitt/pages/results.dart';
import 'package:knowitt/widgets/bg_particles.dart';
import 'package:knowitt/widgets/message_dialog.dart';
import 'package:knowitt/widgets/quiz_option.dart';
import 'package:knowitt/widgets/quiz_progress_bar.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class QuizPage extends ConsumerStatefulWidget {
  const QuizPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<QuizPage>
    with SingleTickerProviderStateMixin {
  var selAns = '';
  @override
  void initState() {
    ref.read(gameControllerProvider.notifier).quizInit();
    final state = ref.read(gameControllerProvider);
    // ref
    //     .read(gameControllerProvider.notifier)
    //     .startTimer(state.questions[state.questionNumber].duration.seconds);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final gameController = ref.watch(gameControllerProvider.notifier);
    final gameState = ref.watch(gameControllerProvider);
    ref.listen<GameState>(gameControllerProvider, (_, state) {
      switch (state.gameStatus) {
        case GameStatus.waiting:
          // showDialog(context: context, builder: builder)
          break;
        case GameStatus.timeup:
          showDialog(
              barrierColor: Colors.white24,
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return MessageDialog(
                    nextText: state.questions.length != state.questionNumber + 1
                        ? "Next Question"
                        : "Show Results",
                    nextClick:
                        state.questions.length == state.questionNumber + 1
                            ? () {
                                gameController.showResults();
                              }
                            : () {
                                gameController.pageController.nextPage(
                                    duration: 200.milliseconds,
                                    curve: Curves.easeInOut);
                                Navigator.pop(context);
                              },
                    quitClick: () {
                      //Call time up func
                      Navigator.pop(context);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        //Push to result page
                        return const ResultsPage(
                          quit: true,
                        );
                      }));
                    },
                    title: "Time Up",
                    message:
                        "${state.currentQuestion.wrongPoints} points has been deducted from your score.\n NOTE: An extra 5 points will be deducted if you quit.");
              });
          break;
        case GameStatus.ansCorrect:
          showDialog(
              barrierColor: Colors.white24,
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return MessageDialog(
                    nextText: state.questions.length != state.questionNumber + 1
                        ? "Next Question"
                        : "Show Results",
                    nextClick:
                        state.questions.length == state.questionNumber + 1
                            ? () {
                                gameController.showResults();
                              }
                            : () {
                                gameController.pageController.nextPage(
                                    duration: 200.milliseconds,
                                    curve: Curves.easeInOut);
                                Navigator.pop(context);
                              },
                    quitClick: () {
                      //Call time up func
                      Navigator.pop(context);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        //Push to result page
                        return const ResultsPage(
                          quit: true,
                        );
                      }));
                    },
                    title: "You're Right!",
                    message: "+${state.currentQuestion.points} points.");
              });
          break;

        case GameStatus.ansWrong:
          showDialog(
              barrierColor: Colors.white24,
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return MessageDialog(
                    nextText: state.questions.length != state.questionNumber + 1
                        ? "Next Question"
                        : "Show Results",
                    nextClick:
                        state.questions.length == state.questionNumber + 1
                            ? () {
                                gameController.showResults();
                              }
                            : () {
                                gameController.pageController.nextPage(
                                    duration: 200.milliseconds,
                                    curve: Curves.easeInOut);
                                Navigator.pop(context);
                              },
                    quitClick: () {
                      //Call time up func
                      Navigator.pop(context);
                      // gameController.quitGame();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        //Push to result page
                        return const ResultsPage(
                          quit: true,
                        );
                      }));
                    },
                    title: "Wrong Answer",
                    message: "-${state.currentQuestion.wrongPoints} points");
              });
          break;
        case GameStatus.gameDone:
          //Call game done func
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ResultsPage(
                quit: false,
              ),
            ),
          );
          break;
        default:
          break;
      }
    });
    final currQ = gameState.currentQuestion;
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Q: ${gameState.questionNumber + 1}/${gameState.questions.length}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontFamily: 'Gunk'),
                      ),
                      Text("Round: 1",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.sp,
                              fontFamily: 'Gunk')),
                      Text(
                        "Score: 0",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontFamily: 'Gunk'),
                      ),
                    ],
                  ),
                ).paddingBottom(1.5.h),
                Expanded(
                    child: PageView.builder(
                  // Block swipe
                  physics: const NeverScrollableScrollPhysics(),
                  controller: gameController.pageController,
                  onPageChanged: gameController.nextQuestion,
                  itemCount: gameState.questions.length,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.5.w),
                    child: Column(
                      children: [
                        QuizProgressBar(gameState.questions[index]),
                        Container(
                          width: size.maxWidth,
                          height: 50.h,
                          margin: EdgeInsets.symmetric(
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 0.5.h, vertical: 2.5.h),
                                alignment: Alignment.center,
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.zero,
                                  physics: const ClampingScrollPhysics(),
                                  child: Text(
                                    currQ.question,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: t.primaryColor,
                                        fontSize: 18.sp,
                                        fontFamily: 'Gunk'),
                                  ).paddingSymmetric(
                                      horizontal: 1.5.h, vertical: 1.h),
                                ),
                              ),
                              Divider(
                                color: t.darkBlue,
                                thickness: 1,
                                height: 0.5.h,
                                indent: 5.w,
                                endIndent: 5.w,
                              ),
                              Text(
                                "Options",
                                style: TextStyle(
                                    color: t.darkBlue,
                                    fontSize: 20.sp,
                                    fontFamily: 'Debug'),
                              ).paddingTop(0.5.h),
                              ListView(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                children: currQ.options
                                    .map((e) => QuizOption(
                                          index: currQ.options.indexOf(e),
                                          text: e,
                                          doublePress: () {
                                            //Check answer
                                            gameController.changeAnsIndex(
                                                currQ.options.indexOf(e));
                                            gameController.checkAnswer(e);
                                          },
                                          press: () {
                                            if (gameState.ansIndex !=
                                                currQ.options.indexOf(e)) {
                                              gameController.changeAnsIndex(
                                                  currQ.options.indexOf(e));
                                              return;
                                            } else if (gameState.ansIndex !=
                                                    null &&
                                                gameState.ansIndex ==
                                                    currQ.options.indexOf(e)) {
                                              gameController.checkAnswer(e);
                                            }
                                          },
                                          key: ValueKey(currQ.question + e),
                                        ).paddingSymmetric(
                                            vertical: 0.5.h, horizontal: 2.w))
                                    .toList(),
                              ).expand(),
                              Text(
                                "I Quit",
                                style: TextStyle(
                                    color: t.primaryColor,
                                    fontSize: 20.sp,
                                    fontFamily: 'Gunk'),
                              ).paddingBottom(1.h).onTap(() {
                                gameController.animationController
                                    .stop(canceled: false);
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        elevation: 20,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 2.h, horizontal: 5.w),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Quit Quiz",
                                              style: TextStyle(
                                                  fontSize: 23.sp,
                                                  fontFamily: "Gunk"),
                                            ).paddingBottom(1.h),
                                            Text(
                                              "Are you sure you want to quit/\n NOTE: An extra 5 points will be deducted if you quit.",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontFamily: "Pixel"),
                                            ).paddingSymmetric(vertical: 1.h),
                                            TextButton(
                                                style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        t.primaryColor,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 1.h,
                                                            horizontal: 5.w),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50))),
                                                onPressed: () {
                                                  // gameController.questions.clear();
                                                  gameController
                                                      .animationController
                                                      .stop();
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    //Push to result page
                                                    return const ResultsPage(
                                                      quit: true,
                                                    );
                                                  }));
                                                },
                                                child: Text(
                                                  "Yes",
                                                  style: TextStyle(
                                                      fontSize: 22.sp,
                                                      fontFamily: "Debug",
                                                      color: Colors.white),
                                                )),
                                            TextButton(
                                                onPressed: () {
                                                  gameController
                                                      .animationController
                                                      .forward(
                                                          from: gameController
                                                              .animation.value);
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "No",
                                                  style: TextStyle(
                                                      fontSize: 20.sp,
                                                      fontFamily: "Gunk"),
                                                )),
                                          ],
                                        ),
                                      );
                                    });
                              }),
                            ],
                          ),
                        ).expand(),
                      ],
                    ),
                  ).paddingBottom(1.5.h),
                )),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class QuestionBox extends ConsumerWidget {
  final QuestionModel question;
  final BoxConstraints size;
  const QuestionBox({super.key, required this.question, required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h, left: 3.w, right: 3.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(question.question),
          Text(
            "What is the first name of my first girlfriend?",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: t.primaryColor, fontSize: 20.sp, fontFamily: 'Gunk'),
          ).paddingSymmetric(horizontal: 1.5.h, vertical: 1.h),
          const Spacer(),
          Text(
            "I Give up",
            style: TextStyle(
                color: t.primaryColor, fontSize: 22.sp, fontFamily: 'Gunk'),
          ).paddingBottom(1.h),
        ],
      ),
    );
  }
}
