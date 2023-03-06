import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowitt/controller/game_controller.dart';
import 'package:knowitt/core/constant/theme.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class QuizOption extends ConsumerWidget {
  const QuizOption(
      {required Key key,
      required this.text,
      required this.index,
      required this.press,
      required this.doublePress})
      : super(key: key);

  final String text;
  final int index;
  final VoidCallback press;
  final VoidCallback doublePress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameController = ref.watch(gameControllerProvider);
    return InkWell(
      onTap: press,
      onDoubleTap: doublePress,
      child: Container(
        margin: EdgeInsets.only(top: 1.h),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: gameController.ansIndex != null
              ? gameController.ansIndex == index
                  ? accentColor
                  : darkBlue
              : darkBlue,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(25),
        ),
        child: LayoutBuilder(builder: (context, size) {
          return SizedBox(
            width: size.maxWidth,
            child: Text(
              "${index + 1}. $text",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'gunk', color: Colors.white, fontSize: 20.sp),
            ),
          );
        }),
      ),
    );
  }
}
