import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowitt/admin/controller/admin_controller.dart';
import 'package:knowitt/core/constant/theme.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AdminAuthPage extends ConsumerStatefulWidget {
  const AdminAuthPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdminAuthPageState();
}

class _AdminAuthPageState extends ConsumerState<AdminAuthPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamed("/dashboard");
      });
    }
    super.initState();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(adminControllerProvider);
    return Scaffold(
      body: LayoutBuilder(builder: (context, size) {
        return Center(
            child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Login",
                style: TextStyle(
                    fontSize: 20.sp,
                    fontFamily: "kwk",
                    fontWeight: FontWeight.bold),
              ).paddingBottom(5.h),
              TextFormField(
                onChanged: (value) => controller.username = value,
                validator: (value) {
                  if (!value.validateEmail()) {
                    return "Please enter a valid email";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: "Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ).paddingSymmetric(horizontal: 10.w),
              TextFormField(
                onChanged: (value) => controller.password = value,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ).paddingSymmetric(horizontal: 10.w, vertical: 5.h),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                      textStyle: TextStyle(
                          fontSize: 20.sp,
                          fontFamily: "gunk",
                          fontWeight: FontWeight.bold)),
                  onPressed: () {
                    setState(() {
                      isLoading = true;
                    });
                    controller.signIn().then((value) {
                      if (value) {
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.pushReplacementNamed(context, "/dashboard");
                      }
                    }).catchError((e) {
                      setState(() {
                        isLoading = false;
                      });
                      print(e);
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("Error"),
                                content: Text(e.message),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Ok"))
                                ],
                              ));
                    });
                  },
                  child: controller.status == AdminStatus.waiting
                      ? CircularProgressIndicator()
                      : Text("Login"))
            ],
          ),
        ));
      }),
    );
  }
}
