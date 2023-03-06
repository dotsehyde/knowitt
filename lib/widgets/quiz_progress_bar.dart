import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowitt/controller/game_controller.dart';
import 'package:knowitt/core/constant/theme.dart';
import 'package:knowitt/model/question.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class QuizProgressBar extends ConsumerStatefulWidget {
  final QuestionModel question;
  const QuizProgressBar(this.question, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _QuizProgressBarState();
}

class _QuizProgressBarState extends ConsumerState<QuizProgressBar>
    with SingleTickerProviderStateMixin {
  var time = 0.0;
  late Animation animation;
  @override
  void initState() {
    final controller = ref.read(gameControllerProvider.notifier);
    controller.animationController = AnimationController(
        vsync: this, duration: Duration(seconds: widget.question.duration))
      ..forward();
    controller.animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(controller.animationController);
    controller.trackAnimation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(gameControllerProvider.notifier);

    return Container(
        width: double.infinity,
        height: 5.h,
        decoration: BoxDecoration(
            // border: Border.all(color: darkBlue, width: 1),
            borderRadius: BorderRadius.circular(50)),
        child: AnimatedBuilder(
            animation: controller.animationController,
            builder: (context, _) {
              time = controller.animation.value * widget.question.duration;
              return Stack(
                children: [
                  LayoutBuilder(
                      builder: (context, constraints) => Container(
                            width: constraints.maxWidth *
                                controller.animation.value,
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                    colors: [accentColor, primaryColor]),
                                borderRadius: BorderRadius.circular(50)),
                          )),
                  Positioned.fill(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8 - 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(CupertinoIcons.time),
                            Text(
                              "Time",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.sp,
                                  fontFamily: 'debug'),
                            ),
                          ],
                        ),
                        Text(
                          '${time.toStringAsFixed(0)}/${widget.question.duration}s',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontFamily: 'gunk'),
                        )
                      ],
                    ).paddingSymmetric(horizontal: 2.w),
                  ))
                ],
              );
            }));
  }
}
