import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowitt/admin/controller/admin_controller.dart';
import 'package:knowitt/core/constant/theme.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddCategoryPage extends ConsumerStatefulWidget {
  const AddCategoryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddCategoryPageState();
}

class _AddCategoryPageState extends ConsumerState<AddCategoryPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(adminControllerProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Category"),
          backgroundColor: primaryColor,
        ),
        body: Container(
          color: Colors.white,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
        ));
  }
}
