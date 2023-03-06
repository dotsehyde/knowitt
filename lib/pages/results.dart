import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowitt/controller/game_controller.dart';
import 'package:knowitt/core/constant/theme.dart';
import 'package:knowitt/widgets/bg_particles.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ResultsPage extends ConsumerStatefulWidget {
  final bool quit;
  const ResultsPage({required this.quit, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResultsPageState();
}

class _ResultsPageState extends ConsumerState<ResultsPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(gameControllerProvider.notifier);
    final state = ref.watch(gameControllerProvider);
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Your Results",
                    style: TextStyle(fontFamily: 'pixel', fontSize: 20.sp),
                  ),
                  Text(
                    "Score:",
                    style: TextStyle(fontFamily: 'pixel', fontSize: 22.sp),
                  ),
                  Text(
                    "+50",
                    style: TextStyle(fontFamily: 'pixel', fontSize: 30.sp),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Correct Answers: 6",
                        style: TextStyle(fontFamily: 'gunk', fontSize: 20.sp),
                      ),
                      Text("Wrong Answer: 4",
                          style:
                              TextStyle(fontFamily: 'gunk', fontSize: 20.sp)),
                    ],
                  ),
                  Text(
                    "Accuracy: ${((6 / 10) * 100).toStringAsFixed(1)}%",
                    style: TextStyle(fontFamily: 'pixel', fontSize: 18.sp),
                  ),
                  Badge(
                    isLabelVisible: !widget.quit,
                    label: Text("x${state.round + 1}",
                        style: TextStyle(fontSize: 15.sp, fontFamily: "Pixel")),
                    alignment: AlignmentDirectional.topCenter,
                    backgroundColor: Colors.white,
                    child: TextButton(
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.w, vertical: 1.5.h),
                                backgroundColor: primaryColor.withOpacity(0.8),
                                elevation: 10),
                            onPressed: () {
                              //next round
                              controller.nextRound();
                            },
                            child: Text("Next Round",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                    fontFamily: "Pixel")))
                        .visible(!widget.quit),
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 1.5.h),
                          backgroundColor: primaryColor.withOpacity(0.8),
                          elevation: 10),
                      onPressed: () {
                        //next round
                        controller.nextRound();
                      },
                      child: Text("Return Home",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontFamily: "Pixel")))
                ],
              )),
        );
      }),
    );
  }
}
