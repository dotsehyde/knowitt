import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowitt/admin/controller/admin_controller.dart';
import 'package:knowitt/core/constant/theme.dart';
import 'package:nb_utils/nb_utils.dart';
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
  List<String> list = ["Add Category", "Add Question"];
  String selItem = "";
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(adminControllerProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Dashboard"),
      ),
      body: LayoutBuilder(builder: (context, size) {
        return SizedBox(
          width: size.maxWidth,
          height: size.maxHeight,
          child: Builder(builder: (context) {
            if (size.maxWidth <= 600) {
              //Mobile View
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...list.map((e) => TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: Size(size.maxWidth / 2, 8.h),
                        backgroundColor: primaryColor,
                      ),
                      onPressed: () {
                        if (size.maxWidth <= 600) {
                          return;
                        }
                        setState(() {
                          selItem = e;
                        });
                      },
                      child: Text(
                        e,
                        style: TextStyle(color: Colors.white, fontSize: 18.sp),
                      )).paddingBottom(5.h)),
                  TextButton.icon(
                    label: Text(
                      "Logout",
                      style: TextStyle(color: Colors.red),
                    ),
                    icon: Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      logout();
                    },
                  )
                ],
              );
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: size.maxWidth / 4,
                    height: size.maxHeight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(size.maxWidth.toString()),
                        ...list
                            .map((e) => ListTile(
                                  title: Text(e),
                                  leading: getIcon(e),
                                  onTap: () {
                                    setState(() {
                                      selItem = e;
                                    });
                                  },
                                ))
                            .toList(),
                        Spacer(),
                        ListTile(
                          title: Text(
                            "Logout",
                            style: TextStyle(color: Colors.red),
                          ),
                          leading: Icon(
                            Icons.logout,
                            color: Colors.red,
                          ),
                          onTap: () {
                            logout();
                          },
                        )
                      ],
                    )),
                Expanded(
                    child: Container(
                        height: size.maxHeight,
                        color: Colors.white,
                        child: getBody(controller)))
              ],
            );
          }),
        );
      }),
    );
  }

  void logout() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Logout"),
            content: Text("Are you sure you want to logout?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("No")),
              TextButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil("/auth", (_) => false);
                  },
                  child: Text("Yes"))
            ],
          );
        });
  }

  final optionController = TextEditingController();
  Widget getBody(AdminController controller) {
    switch (selItem) {
      case "Add Category":
        return Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text(
              //   "Add Category",
              //   textAlign: TextAlign.center,
              //   style: TextStyle(color: Colors.black),
              // ),
              TextFormField(
                style: TextStyle(fontSize: 18.sp),
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor)),
                    hintText: "Category Name",
                    hintStyle: TextStyle(fontSize: 18.sp, color: Colors.grey)),
              ).paddingSymmetric(horizontal: 10.w, vertical: 2.h),
              ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          minimumSize: Size(double.infinity, 50)),
                      onPressed: () {},
                      child: Text("Add Category"))
                  .paddingSymmetric(horizontal: 10.w),
            ],
          ),
        );
      case "Add Question":
        return Container(
          color: Colors.white,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder<List<String>>(
                        future: Future.value(controller.listCat),
                        builder: (context, snap) {
                          if (snap.hasData) {
                            return DropdownButtonFormField<String>(
                                style: TextStyle(
                                    fontSize: 18.sp, color: Colors.black),
                                dropdownColor: Colors.white,
                                decoration: InputDecoration(
                                    hintText: "Select Category",
                                    hintStyle: TextStyle(
                                        fontSize: 18.sp, color: Colors.grey),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: primaryColor)),
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: primaryColor))),
                                items: controller.listCat
                                    .map((e) => DropdownMenuItem<String>(
                                        value: e,
                                        child: Text(
                                          e,
                                          style: TextStyle(color: Colors.black),
                                        )))
                                    .toList(),
                                onChanged: (v) {
                                  controller.selCat = v!;
                                });
                          }
                          return CircularProgressIndicator();
                        }),
                    TextFormField(
                        maxLines: 4,
                        style: TextStyle(fontSize: 18.sp, color: Colors.black),
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                            hintText: "Question",
                            hintStyle:
                                TextStyle(fontSize: 18.sp, color: Colors.grey),
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ))).paddingSymmetric(vertical: 2.h),
                    TextFormField(
                        style: TextStyle(fontSize: 18.sp, color: Colors.black),
                        textInputAction: TextInputAction.next,
                        controller: optionController,
                        decoration: InputDecoration(
                            hintText: "Answer Option",
                            hintStyle:
                                TextStyle(fontSize: 18.sp, color: Colors.grey),
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ))),
                    ElevatedButton(
                            onPressed: () {
                              setState(() {
                                controller.options.add(optionController.text);
                                optionController.clear();
                              });
                            },
                            child: Text("Add Option"))
                        .paddingSymmetric(vertical: 2.h),
                    Wrap(
                      children: [
                        ...controller.options
                            .map((e) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      controller.options.remove(e);
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    margin: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Text(
                                      e,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ],
                    ).visible(controller.options.isNotEmpty),
                    DropdownButtonFormField<String>(
                            style: TextStyle(fontSize: 18.sp, color: Colors.black),
                            dropdownColor: Colors.white,
                            decoration:
                                InputDecoration(
                                    hintText: "Select Correct Answer",
                                    hintStyle: TextStyle(
                                        fontSize: 18.sp, color: Colors.grey),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: primaryColor)),
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: primaryColor))),
                            items: controller.options
                                .map((e) => DropdownMenuItem<String>(
                                    value: e,
                                    child: Text(
                                      e,
                                      style: TextStyle(color: Colors.black),
                                    )))
                                .toList(),
                            onChanged: (v) {
                              controller.selCat = v!;
                            })
                        .paddingBottom(2.h)
                        .visible(controller.options.isNotEmpty),
                    ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                minimumSize: Size(double.infinity, 50)),
                            onPressed: () {},
                            child: Text("Add Question"))
                        .paddingSymmetric(horizontal: 10.w),
                  ]).paddingSymmetric(horizontal: 2.w),
            ),
          ),
        );
      default:
        return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("KnowItt",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold)),
          Text("Dashboard",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.sp,
              )),
        ]);
    }
  }

  Widget getIcon(String title) {
    switch (title) {
      case "Add Category":
        return Icon(Icons.add);
      case "Add Question":
        return Icon(Icons.add);
      default:
        return Icon(Icons.add);
    }
  }
}
