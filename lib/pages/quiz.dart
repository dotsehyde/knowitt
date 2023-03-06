import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowitt/controller/game_controller.dart';
import 'package:knowitt/controller/game_state.dart';
import 'package:knowitt/core/constant/theme.dart' as t;
import 'package:knowitt/model/question.dart';
import 'package:knowitt/widgets/bg_particles.dart';
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
  Widget build(BuildContext context) {
    ref.listen<GameState>(gameControllerProvider, (_, state) {
      switch (state.gameStatus) {
        case GameStatus.waiting:
          // showDialog(context: context, builder: builder)
          break;
        default:
      }
    });

    final gameController = ref.watch(gameControllerProvider.notifier);
    final gameState = ref.watch(gameControllerProvider);
    final currQ = gameState.questions[gameState.questionNumber];
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
                            fontFamily: 'gunk'),
                      ),
                      Text("Round: 1",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.sp,
                              fontFamily: 'gunk')),
                      Text(
                        "Score: 0",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontFamily: 'gunk'),
                      ),
                    ],
                  ),
                ).paddingBottom(1.5.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.5.w),
                  child: QuizProgressBar(
                    question: currQ,
                  ),
                ).paddingBottom(1.5.h),
                Container(
                  width: size.maxWidth,
                  height: 50.h,
                  margin: EdgeInsets.only(bottom: 1.h, left: 3.w, right: 3.w),
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
                                fontFamily: 'gunk'),
                          ).paddingSymmetric(horizontal: 1.5.h, vertical: 1.h),
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
                            fontFamily: 'debug'),
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
                                    // setState(() {
                                    gameController.changeAnsIndex(
                                        currQ.options.indexOf(e));
                                    // });
                                    print("Check answer");
                                  },
                                  press: () {
                                    if (gameState.ansIndex !=
                                        currQ.options.indexOf(e)) {
                                      // setState(() {
                                      gameController.changeAnsIndex(
                                          currQ.options.indexOf(e));
                                      // });
                                      return;
                                    }
                                    if (gameState.ansIndex != null &&
                                        gameState.ansIndex ==
                                            currQ.options.indexOf(e)) {
                                      print("Check answer");

                                      //check answers
                                    }
                                  },
                                  key: ValueKey(currQ.question + e),
                                ).paddingSymmetric(
                                    vertical: 0.5.h, horizontal: 2.w))
                            .toList(),
                      ).expand(),
                      Text(
                        "I Give up",
                        style: TextStyle(
                            color: t.primaryColor,
                            fontSize: 20.sp,
                            fontFamily: 'gunk'),
                      ).paddingBottom(1.h).onTap(() {
                        // gameController.questions.clear();
                        Navigator.pop(context);
                      }),
                    ],
                  ),
                ).expand(),
                // SizedBox(
                //   width: size.maxWidth,
                //   height: 50.h,
                //   child: PageView.builder(
                //       // Block swipe
                //       physics: NeverScrollableScrollPhysics(),
                //       controller: gameController.questionController,
                //       onPageChanged: gameController.updateQuestionNumber,
                //       itemCount: gameController.questions.length,
                //       itemBuilder: (context, index) => QuestionBox(
                //           question: gameController.questions[index],
                //           size: size)),
                // ),
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
                color: t.primaryColor, fontSize: 20.sp, fontFamily: 'gunk'),
          ).paddingSymmetric(horizontal: 1.5.h, vertical: 1.h),
          Spacer(),
          Text(
            "I Give up",
            style: TextStyle(
                color: t.primaryColor, fontSize: 22.sp, fontFamily: 'gunk'),
          ).paddingBottom(1.h),
        ],
      ),
    );
  }
}
