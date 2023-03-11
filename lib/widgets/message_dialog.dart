import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowitt/controller/game_controller.dart';
import 'package:knowitt/core/constant/theme.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MessageDialog extends ConsumerWidget {
  final String title, message, nextText;
  final Function() quitClick;
  final Function() nextClick;

  const MessageDialog(
      {required this.title,
      required this.nextText,
      required this.message,
      required this.quitClick,
      required this.nextClick,
      super.key});

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
            title,
            style: TextStyle(fontSize: 23.sp, fontFamily: "Gunk"),
          ).paddingBottom(1.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.sp, fontFamily: "Pixel"),
          ).paddingSymmetric(vertical: 1.h),
          TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50))),
              onPressed: nextClick,
              child: Text(
                nextText,
                style: TextStyle(
                    fontSize: 22.sp, fontFamily: "Debug", color: Colors.white),
              )),
          TextButton(
              onPressed: quitClick,
              child: Text(
                "I Quit",
                style: TextStyle(fontSize: 20.sp, fontFamily: "Gunk"),
              )),
        ],
      ),
    );
  }
}
