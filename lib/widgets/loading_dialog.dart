import 'package:flutter/material.dart';

import 'package:knowitt/core/constant/theme.dart' as t;
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoadingDialog extends StatelessWidget {
  final String text;
  const LoadingDialog({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 20,
      contentPadding: EdgeInsets.symmetric(vertical: 5.h),
      content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(t.primaryColor),
            ).paddingBottom(2.h),
            Text(text,
                style: TextStyle(
                    color: Colors.white, fontSize: 20.sp, fontFamily: 'debug')),
          ]),
    );
  }
}
