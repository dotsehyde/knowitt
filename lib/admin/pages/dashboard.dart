import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowitt/admin/controller/admin_controller.dart';
import 'package:knowitt/admin/pages/edit_question.dart';
import 'package:knowitt/core/constant/const.dart';
import 'package:knowitt/core/constant/theme.dart';
import 'package:knowitt/model/category.dart';
import 'package:knowitt/model/question.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
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
        Navigator.of(context).pushReplacementNamed("/");
      });
    } else if (FirebaseAuth.instance.currentUser!.emailVerified) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed("/");
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const DashboardWidget();
  }
}

class DashboardWidget extends ConsumerStatefulWidget {
  const DashboardWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DashboardWidgetState();
}

class _DashboardWidgetState extends ConsumerState<DashboardWidget> {
  List<String> list = [
    "All Categories",
    "All Questions",
    "Add Category",
    "Add Question"
  ];
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
            // if (size.maxWidth <= 600) {
            //   //Mobile View
            //   return Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       ...list.map((e) => TextButton(
            //           style: TextButton.styleFrom(
            //             minimumSize: Size(size.maxWidth / 2, 8.h),
            //             backgroundColor: primaryColor,
            //           ),
            //           onPressed: () {
            //             if (size.maxWidth <= 600) {
            //               Navigator.of(context).pushNamed(
            //                   "/${e.replaceAll(" ", "-").toLowerCase()}");
            //               return;
            //             }
            //             setState(() {
            //               selItem = e;
            //             });
            //           },
            //           child: Text(
            //             e,
            //             style: TextStyle(color: Colors.white, fontSize: 18.sp),
            //           )).paddingBottom(5.h)),
            //       TextButton.icon(
            //         label: const Text(
            //           "Logout",
            //           style: TextStyle(color: Colors.red),
            //         ),
            //         icon: const Icon(
            //           Icons.logout,
            //           color: Colors.red,
            //         ),
            //         onPressed: () {
            //           logout();
            //         },
            //       )
            //     ],
            //   );
            // }
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: size.maxWidth / 4,
                    height: size.maxHeight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
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
                        const Spacer(),
                        ListTile(
                          title: const Text(
                            "Logout",
                            style: TextStyle(color: Colors.red),
                          ),
                          leading: const Icon(
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
            title: const Text("Logout"),
            content: const Text("Are you sure you want to logout?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("No")),
              TextButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil("/auth", (_) => false);
                  },
                  child: const Text("Yes"))
            ],
          );
        });
  }

  final _formKey = GlobalKey<FormState>();
  final optionController = TextEditingController();
  Widget getBody(AdminController controller) {
    switch (selItem) {
      case "All Questions":
        return AllQuestions();
      case "All Categories":
        return Container(
          color: Colors.white,
          child: Column(
            children: [
              Text(
                "All Categories",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp),
              ).paddingSymmetric(vertical: 2.h),
              Expanded(
                child: PaginateFirestore(
                    isLive: true,
                    initialLoader: const Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(primaryColor)),
                    ),
                    onEmpty: Center(
                      child: Text(
                        "No Category Found",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp),
                      ),
                    ),
                    separator: const Divider(
                      color: Colors.black,
                    ),
                    itemBuilder: (context, data, i) {
                      final model =
                          CategoryModel.fromMap(data[i].data() as Map);
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: primaryColor,
                          child: Text(
                            (i + 1).toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          model.name.capitalizeFirstLetter(),
                          style: TextStyle(color: Colors.black),
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        content: const Text(
                                            "Are you sure you want to delete this category?"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("No")),
                                          TextButton(
                                              onPressed: () {
                                                controller
                                                    .deleteCategory(model.id);

                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Yes")),
                                        ],
                                      ));
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                      );
                    },
                    query: FirebaseFirestore.instance
                        .collection(categoryCollection)
                        .orderBy("name"),
                    itemBuilderType: PaginateBuilderType.listView),
              )
            ],
          ),
        );

      case "Add Category":
        return Container(
          color: Colors.white,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Add Category",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp),
                ),
                TextFormField(
                  validator: (v) {
                    if (v!.isEmpty) {
                      return "Please enter category name";
                    }
                    return null;
                  },
                  onChanged: (val) {
                    controller.categoryName = val;
                  },
                  style: TextStyle(fontSize: 18.sp, color: Colors.black),
                  cursorColor: primaryColor,
                  decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor)),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor)),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor)),
                      hintText: "Category Name",
                      hintStyle:
                          TextStyle(fontSize: 18.sp, color: Colors.grey)),
                ).paddingSymmetric(horizontal: 10.w, vertical: 2.h),
                ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            minimumSize: const Size(double.infinity, 50)),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            controller
                                .addCategory()
                                .then((value) => showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          title: const Text("Success"),
                                          content: const Text(
                                              "Category Added Successfully"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Ok"))
                                          ],
                                        )))
                                .catchError((e) {
                              showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                        title: const Text("Error"),
                                        content: Text(e.toString()),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Ok"))
                                        ],
                                      ));
                            });
                          }
                        },
                        child: const Text("Add Category"))
                    .paddingSymmetric(horizontal: 10.w),
              ],
            ),
          ),
        );

      case "Add Question":
        return LayoutBuilder(builder: (context, size) {
          return Container(
            color: Colors.white,
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Add Question",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp),
                        ).paddingBottom(1.h),
                        FutureBuilder<List<String>>(
                            future: controller.listCat.isNotEmpty
                                ? Future.value(controller.listCat)
                                : controller.getCategories(),
                            builder: (context, snap) {
                              if (snap.hasData) {
                                if (snap.requireData.isEmpty) {
                                  return Text(
                                    "No Category Found",
                                    style: TextStyle(
                                        fontSize: 16.sp, color: Colors.red),
                                  );
                                }
                                return DropdownButtonFormField<String>(
                                    style: TextStyle(
                                        fontSize: 18.sp, color: Colors.black),
                                    dropdownColor: Colors.white,
                                    decoration: InputDecoration(
                                        hintText: "Select Category",
                                        hintStyle: TextStyle(
                                            fontSize: 18.sp,
                                            color: Colors.grey),
                                        enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: primaryColor)),
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: primaryColor))),
                                    items: snap.requireData
                                        .map((e) => DropdownMenuItem<String>(
                                            value: e,
                                            child: Text(
                                              e,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            )))
                                        .toList(),
                                    onChanged: (v) {
                                      controller.selCat = v!;
                                    });
                              }
                              return const CircularProgressIndicator();
                            }),
                        TextFormField(
                            maxLines: 4,
                            style:
                                TextStyle(fontSize: 18.sp, color: Colors.black),
                            validator: (v) {
                              if (v!.isEmpty) {
                                return "Enter Question";
                              }
                              return null;
                            },
                            onChanged: (v) {
                              controller.question = v;
                            },
                            textInputAction: TextInputAction.newline,
                            decoration: InputDecoration(
                                hintText: "Question",
                                hintStyle: TextStyle(
                                    fontSize: 18.sp, color: Colors.grey),
                                border: const OutlineInputBorder(),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: primaryColor),
                                ))).paddingSymmetric(vertical: 2.h),
                        TextFormField(
                            style:
                                TextStyle(fontSize: 18.sp, color: Colors.black),
                            textInputAction: TextInputAction.next,
                            controller: optionController,
                            decoration: InputDecoration(
                                hintText: "Answer Option",
                                hintStyle: TextStyle(
                                    fontSize: 18.sp, color: Colors.grey),
                                border: const OutlineInputBorder(),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: primaryColor),
                                ))),
                        ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    controller.options
                                        .add(optionController.text);
                                    optionController.clear();
                                  });
                                },
                                child: const Text("Add Option"))
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
                                        padding: const EdgeInsets.all(5),
                                        margin: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Text(
                                          e,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ],
                        ).visible(controller.options.isNotEmpty),
                        DropdownButtonFormField<String>(
                                validator: (v) {
                                  if (v!.isEmpty) {
                                    return "Select the Correct Answer";
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                    fontSize: 18.sp, color: Colors.black),
                                dropdownColor: Colors.white,
                                decoration: InputDecoration(
                                    hintText: "Select Correct Answer",
                                    hintStyle: TextStyle(
                                        fontSize: 18.sp, color: Colors.grey),
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: primaryColor)),
                                    border: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: primaryColor))),
                                items: controller.options
                                    .map((e) => DropdownMenuItem<String>(
                                        value: e,
                                        child: Text(
                                          e,
                                          style: const TextStyle(
                                              color: Colors.black),
                                        )))
                                    .toList(),
                                onChanged: (v) {
                                  controller.correctAnswer = v!;
                                })
                            .paddingBottom(2.h)
                            .visible(controller.options.isNotEmpty),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                width: size.maxWidth * 0.3,
                                child: TextFormField(
                                    validator: (v) {
                                      if (v!.isEmpty) {
                                        return "Please enter points";
                                      }
                                      return null;
                                    },
                                    onChanged: (v) {
                                      if (v.isNotEmpty) {
                                        controller.correctPoints = int.parse(v);
                                      }
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]'))
                                    ],
                                    cursorColor: primaryColor,
                                    style: TextStyle(
                                        fontSize: 18.sp, color: Colors.black),
                                    decoration: InputDecoration(
                                        hintText: "Correct Points",
                                        hintStyle: TextStyle(
                                            fontSize: 18.sp,
                                            color: Colors.grey),
                                        border: const OutlineInputBorder(),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: primaryColor),
                                        )))),
                            SizedBox(
                                width: size.maxWidth * 0.3,
                                child: TextFormField(
                                    onChanged: (v) {
                                      if (v.isNotEmpty) {
                                        controller.wrongPoints = int.parse(v);
                                      }
                                    },
                                    validator: (v) {
                                      if (v!.isEmpty) {
                                        return "Please enter points";
                                      }
                                      return null;
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]'))
                                    ],
                                    cursorColor: primaryColor,
                                    style: TextStyle(
                                        fontSize: 18.sp, color: Colors.black),
                                    decoration: InputDecoration(
                                        hintText: "Wrong Points",
                                        hintStyle: TextStyle(
                                            fontSize: 18.sp,
                                            color: Colors.grey),
                                        border: const OutlineInputBorder(),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: primaryColor),
                                        )))),
                            SizedBox(
                                width: size.maxWidth * 0.3,
                                child: TextFormField(
                                    onChanged: (v) {
                                      if (v.isNotEmpty) {
                                        controller.duration = int.parse(v);
                                      }
                                    },
                                    validator: (v) {
                                      if (v!.isEmpty) {
                                        return "Please enter duration";
                                      }
                                      return null;
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]'))
                                    ],
                                    cursorColor: primaryColor,
                                    style: TextStyle(
                                        fontSize: 18.sp, color: Colors.black),
                                    decoration: InputDecoration(
                                        hintText: "Duration (in sec)",
                                        hintStyle: TextStyle(
                                            fontSize: 18.sp,
                                            color: Colors.grey),
                                        border: const OutlineInputBorder(),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: primaryColor),
                                        )))),
                          ],
                        )
                            .paddingBottom(2.h)
                            .visible(controller.options.isNotEmpty),
                        ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    minimumSize:
                                        const Size(double.infinity, 50)),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    controller.addQuestion().then((value) {
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                                title: const Text("Success"),
                                                content: const Text(
                                                    "Question Added Successfully"),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text("Ok"))
                                                ],
                                              ));
                                    }).catchError((e) {
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                                title: const Text("Error"),
                                                content: Text(e.toString()),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text("Ok"))
                                                ],
                                              ));
                                    });
                                  }
                                },
                                child: const Text("Add Question"))
                            .paddingSymmetric(horizontal: 10.w),
                      ]).paddingSymmetric(horizontal: 2.w),
                ),
              ),
            ),
          );
        });
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
      case "All Categories":
        return const Icon(Icons.category);
      case "All Questions":
        return const Icon(Icons.question_mark_rounded);
      default:
        return const Icon(Icons.add);
    }
  }
}

class AllQuestions extends ConsumerStatefulWidget {
  const AllQuestions({super.key});

  @override
  ConsumerState<AllQuestions> createState() => _AllQuestionsState();
}

class _AllQuestionsState extends ConsumerState<AllQuestions> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(adminControllerProvider);
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Text(
            "All Questions",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp),
          ).paddingSymmetric(vertical: 2.h),
          Expanded(
            child: PaginateFirestore(
                isLive: true,
                initialLoader: const Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(primaryColor)),
                ),
                onEmpty: Center(
                  child: Text(
                    "No Questions Found",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp),
                  ),
                ),
                separator: const Divider(
                  color: Colors.black,
                ),
                itemBuilder: (context, data, i) {
                  final model = QuestionModel.fromMap(data[i].data() as Map);
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: primaryColor,
                      child: Text(
                        (i + 1).toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    onTap: () {
                      controller.question = model.question;
                      controller.selCat = model.category;
                      controller.options = model.options;
                      controller.correctAnswer = model.answer;
                      controller.duration = model.duration;
                      controller.wrongPoints = model.wrongPoints;
                      controller.correctPoints = model.points;
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return EditQuestionPage(
                          question: model,
                        );
                      }));
                    },
                    title: Text(
                      model.question,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(
                      model.category.capitalizeFirstLetter(),
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing: IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    content: const Text(
                                        "Are you sure you want to delete this question?"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("No")),
                                      TextButton(
                                          onPressed: () {
                                            controller.deleteQuestion(model.id);
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Yes")),
                                    ],
                                  ));
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        )),
                  );
                },
                query: FirebaseFirestore.instance
                    .collection(questionCollection)
                    .orderBy("createdAt"),
                itemBuilderType: PaginateBuilderType.listView),
          )
        ],
      ),
    );
  }
}
