import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowitt/admin/pages/auth.dart';
import 'package:knowitt/admin/pages/dashboard.dart';
import 'package:knowitt/admin/pages/welcome.dart';
import 'package:knowitt/core/constant/theme.dart';
import 'package:knowitt/firebase_options.dart';
import 'package:knowitt/pages/auth.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'core/constant/const.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, _, __) {
      return isWeb
          ? MaterialApp(
              title: appName,
              debugShowCheckedModeBanner: false,
              theme: customTheme,
              initialRoute: '/',
              routes: {
                '/': (context) => WelcomePage(),
                '/auth': (context) => AdminAuthPage(),
                '/dashboard': (context) => DashboardPage(),
              },
            )
          : MaterialApp(
              title: appName,
              debugShowCheckedModeBanner: false,
              theme: customTheme,
              home: Starter(),
            );
    });
  }
}

class Starter extends ConsumerWidget {
  const Starter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AuthPage();
  }
}
