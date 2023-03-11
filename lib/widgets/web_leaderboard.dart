import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowitt/core/constant/const.dart';
import 'package:knowitt/model/user.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../core/constant/theme.dart';

class WebLeaderBoard extends ConsumerStatefulWidget {
  const WebLeaderBoard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WebLeaderBoardState();
}

class _WebLeaderBoardState extends ConsumerState<WebLeaderBoard> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text("Leaderboard",
              style: TextStyle(
                  color: Colors.white, fontSize: 18.sp, fontFamily: "Pixel"))
          .paddingTop(8.h),
      StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(userCollection)
              .orderBy("score", descending: true)
              .snapshots(),
          builder: (context, snap) {
            if (snap.hasData) {
              final playerPosition = snap.requireData.docs
                  .indexWhere((player) => player['uid'] == user.uid);
              // Calculate the ScrollController's initialScrollOffset to center the player's position
              final scrollController =
                  ScrollController(initialScrollOffset: playerPosition * 50.0);
              return AnimatedListView(
                  padding: EdgeInsets.only(top: 1.h),
                  listAnimationType: ListAnimationType.FadeIn,
                  controller: scrollController,
                  itemCount: snap.requireData.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final data =
                        UserModel.fromMap(snap.requireData.docs[index].data());
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: rankColor(index),
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontFamily: "Pixel"),
                        ),
                      ),
                      subtitle: Text("Score: ${moneyCount(data.score)}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontFamily: "Gunk")),
                      title: Text(
                        data.username,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.sp,
                            fontFamily: "Debug"),
                      ),
                    );
                  }).expand();
            }
            return Center(
              child: Column(
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ).paddingBottom(2.h).paddingTop(20.h),
                  Text("Loading...",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontFamily: "Pixel"))
                ],
              ),
            ).expand();
          })
    ]);
  }

  Color rankColor(int index) {
    switch (index) {
      case 0:
        return Colors.amber;
      case 1:
        return Colors.grey;
      case 2:
        return Colors.brown;
      default:
        return primaryColor;
    }
  }
}
