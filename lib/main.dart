import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:knowitt/admin/pages/add_category.dart';
import 'package:knowitt/admin/pages/add_question.dart';
import 'package:knowitt/admin/pages/auth.dart';
import 'package:knowitt/admin/pages/dashboard.dart';
import 'package:knowitt/controller/auh_controller.dart';
import 'package:knowitt/core/config/hive_box.dart';
import 'package:knowitt/core/constant/theme.dart';
import 'package:knowitt/firebase_options.dart';
import 'package:knowitt/pages/auth.dart';
import 'package:knowitt/pages/home.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'core/constant/const.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  LocalDB.init();
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
                '/': (context) => Starter(),
                '/auth': (context) => AdminAuthPage(),
                '/dashboard': (context) => DashboardPage(),
                '/add-question': (context) => AddQuestionPage(),
                '/add-category': (context) => AddCategoryPage(),
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

class Starter extends ConsumerStatefulWidget {
  const Starter({super.key});

  @override
  ConsumerState<Starter> createState() => _StarterState();
}

class _StarterState extends ConsumerState<Starter> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.read(authControllerProvider);
    return FirebaseAuth.instance.currentUser == null
        ? AuthPage()
        : StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snap) {
              if (snap.hasData) {
                if (snap.data!.emailVerified) {
                  return HomePage();
                } else {
                  return AuthPage();
                }
              }
              return loading();
            });
  }

  Widget loading() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "KnowItt!",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.normal,
                fontFamily: 'Kwk',
              ),
            ),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ).paddingSymmetric(vertical: 2.h),
            Text(
              "Loading...",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.normal,
                fontFamily: 'Pixel',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
