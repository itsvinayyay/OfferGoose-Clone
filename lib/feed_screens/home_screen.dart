import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:offer_goose_clone/core/routes/named_routes.dart';
import 'package:offer_goose_clone/core/theme/colors.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreen,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: AppColors.ivory),
        margin: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildBottomBarElements(
                title: "Mock Interview",
                iconData: Icons.speaker_notes,
                onPressed: () {}),
            SizedBox(
                height: 30.h,
                child: const VerticalDivider(
                  thickness: 1,
                )),
            buildBottomBarElements(
                title: "Formal Interview",
                iconData: Icons.work,
                onPressed: () {
                  Navigator.pushNamed(context, Routes.formalInterviewScreen);
                }),
            SizedBox(
                height: 30.h,
                child: const VerticalDivider(
                  thickness: 1,
                )),
            buildBottomBarElements(
              title: "Profile",
              iconData: Icons.person,
              onPressed: () {},
            ),
          ],
        ),
      ),
      appBar: AppBar(
          backgroundColor: AppColors.lightGreen,
          title: Image.asset(
            "assets/images/full_logo.png",
            width: 120.w,
          )),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              "assets/images/logo_oG.png",
              width: 150.w,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Try the 'Formal Interview' Option!",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          )
        ],
      )),
    );
  }

  CupertinoButton buildBottomBarElements({
    required String title,
    required IconData iconData,
    required VoidCallback onPressed,
  }) {
    return CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconData,
              size: 25.sp,
              color: Colors.black,
            ),
            Text(
              title,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700),
            )
          ],
        ));
  }
}
