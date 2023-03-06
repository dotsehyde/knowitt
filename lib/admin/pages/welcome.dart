import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Knowitt!",
            style: TextStyle(fontFamily: "robus", fontSize: 30.sp),
          ),
          Text(
            "Launching Soon!!",
            style: TextStyle(fontFamily: "ugly", fontSize: 30.sp),
          ),
        ],
      )),
    );
  }
}
