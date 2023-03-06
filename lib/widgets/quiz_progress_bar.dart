import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowitt/controller/game_controller.dart';
import 'package:knowitt/core/constant/theme.dart';
import 'package:knowitt/model/question.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class QuizProgressBar extends ConsumerStatefulWidget {
  final QuestionModel? question;
  const QuizProgressBar({this.question, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _QuizProgressBarState();
}

class _QuizProgressBarState extends ConsumerState<QuizProgressBar> {
  var time = 0.0;
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(gameControllerProvider);
    return Container(
        width: double.infinity,
        height: 5.h,
        decoration: BoxDecoration(
            // border: Border.all(color: darkBlue, width: 1),
            borderRadius: BorderRadius.circular(50)),
        child: TweenAnimationBuilder<double>(
            duration: Duration(seconds: 20),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              time = value * 10;
              return Stack(
                children: [
                  // LayoutBuider provide the available space for the container
                  // constraints.maxWidth need for animation
                  LayoutBuilder(
                      builder: (context, constraints) => Container(
                            width: constraints.maxWidth * value,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [accentColor, primaryColor]),
                                borderRadius: BorderRadius.circular(50)),
                          )),
                  Positioned.fill(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8 - 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Time",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontFamily: 'debug'),
                        ),
                        Icon(CupertinoIcons.time)
                      ],
                    ).paddingSymmetric(horizontal: 2.w),
                  ))
                ],
              );
            }));
  }
}
