import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowitt/admin/controller/admin_controller.dart';
import 'package:knowitt/core/constant/theme.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddQuestionPage extends ConsumerStatefulWidget {
  const AddQuestionPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddQuestionPageState();
}

class _AddQuestionPageState extends ConsumerState<AddQuestionPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(adminControllerProvider);
    final optionController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Question"),
        backgroundColor: primaryColor,
      ),
      body: LayoutBuilder(builder: (context, size) {
        return Container(
          color: Colors.white,
          child: Center(
            child: Scrollbar(
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
                            future: controller.getCategories(),
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
          ),
        );
      }),
    );
  }
}
