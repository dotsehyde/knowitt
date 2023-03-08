import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowitt/core/constant/theme.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser == null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamed("/auth");
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DashboardWidget();
  }
}

class DashboardWidget extends ConsumerStatefulWidget {
  const DashboardWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DashboardWidgetState();
}

class _DashboardWidgetState extends ConsumerState<DashboardWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: LayoutBuilder(builder: (context, size) {
        return SizedBox(
          width: size.maxWidth,
          height: size.maxHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: size.maxWidth / 3,
                  height: size.maxHeight,
                  child: Container(
                    color: Colors.red,
                  )),
              Expanded(
                  child: Container(
                color: Colors.blue,
              ))
            ],
          ),
        );
      }),
    );
  }
}
