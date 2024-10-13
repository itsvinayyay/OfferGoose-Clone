import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:offer_goose_clone/core/routes/named_routes.dart';
import 'package:offer_goose_clone/core/theme/colors.dart';
import 'package:offer_goose_clone/cubits/formal_interview_response_cubit/formal_interview_response_cubit.dart';
import 'package:offer_goose_clone/cubits/formal_interview_response_cubit/formal_interview_response_states.dart';
import 'package:offer_goose_clone/cubits/timer_cubit/timer_cubit.dart';
import 'package:offer_goose_clone/feed_screens/formal_interview_screen.dart';

class ResponseScreen extends StatefulWidget {
  final String question;

  const ResponseScreen({super.key, required this.question});

  @override
  State<ResponseScreen> createState() => _ResponseScreenState();
}

class _ResponseScreenState extends State<ResponseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreen,
      bottomNavigationBar: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () async {
          context.read<TimerCubit>().restartTimer();
          Navigator.pushReplacementNamed(context, Routes.formalInterviewScreen);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.darkGreen),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Answer Complete",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        fontFamily: "robo"),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Identify the next question",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: "robo"),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.2),
                radius: 20.sp,
                child: Icon(
                  Icons.check,
                  size: 23.sp,
                  color: AppColors.white,
                ),
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.lightGreen,
        leading: BlocBuilder<FormalInterviewResponseCubit,
            FormalInterviewResponseStates>(builder: (context, state) {
          if (state is LoadedResponseState) {
            return const SizedBox();
          }

          return Padding(
            padding: EdgeInsets.all(15.sp),
            child: CircleAvatar(
              backgroundColor: Colors.red,
              radius: 10.sp,
              child: Icon(
                Icons.stop,
                color: Colors.white,
                size: 10.sp,
              ),
            ),
          );
        }),
        title: BlocBuilder<FormalInterviewResponseCubit,
            FormalInterviewResponseStates>(builder: (context, state) {
          if (state is LoadedResponseState) {
            return Image.asset(
              "assets/images/full_logo.png",
              width: 120.w,
            );
          }

          return RecordingStatus(
              iconColor: AppColors.darkGreen, title: "Answering...");
        }),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: BlocBuilder<TimerCubit, int>(
              builder: (context, timeElapsed) {
                final hours = (timeElapsed ~/ 3600).toString().padLeft(2, '0');
                final minutes =
                    ((timeElapsed % 3600) ~/ 60).toString().padLeft(2, '0');
                final seconds = (timeElapsed % 60).toString().padLeft(2, '0');

                return Text(
                  '$hours:$minutes:$seconds',
                  style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: "robo"),
                  textAlign: TextAlign.center,
                );
              },
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.question}?",
                  style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: "robo"),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.ivory),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.message,
                        color: AppColors.darkGreen,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Column(
                          children: [
                            BlocBuilder<FormalInterviewResponseCubit,
                                FormalInterviewResponseStates>(
                              builder: (context, state) {
                                if (state is InitialResponseState) {
                                  return Center(
                                      child: Text(
                                    state.response,
                                    style: TextStyle(
                                        color: AppColors.darkGreen,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "robo"),
                                  ));
                                } else if (state is LoadingResponseState) {
                                  return Text(
                                    state.response,
                                    style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "robo"),
                                  );
                                } else if (state is LoadedResponseState) {
                                  return Text(
                                    state.response,
                                    style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "robo"),
                                  );
                                } else if (state is ErrorResponseState) {
                                  return Text(
                                    state.errorMessage,
                                    style: TextStyle(
                                        color: AppColors.yellow,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "robo"),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
