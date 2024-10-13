import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:offer_goose_clone/core/routes/named_routes.dart';
import 'package:offer_goose_clone/core/theme/colors.dart';
import 'package:offer_goose_clone/cubits/formal_interview_response_cubit/formal_interview_response_cubit.dart';
import 'package:offer_goose_clone/cubits/speech_recognition_cubit/speech_recognition_cubit.dart';
import 'package:offer_goose_clone/cubits/speech_text_cubit/speech_text_cubit.dart';
import 'package:offer_goose_clone/cubits/timer_cubit/timer_cubit.dart';

import 'package:speech_to_text/speech_to_text.dart';

class FormalInterviewScreen extends StatefulWidget {
  const FormalInterviewScreen({super.key});

  @override
  State<FormalInterviewScreen> createState() => _FormalInterviewScreenState();
}

class _FormalInterviewScreenState extends State<FormalInterviewScreen> {
  late SpeechRecognitionCubit _speechRecognitionCubit;
  late SpeechTextCubit _speechTextCubit;
  late FormalInterviewResponseCubit _formalInterviewResponseCubit;
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;

  @override
  void initState() {
    super.initState();
    _speechRecognitionCubit = BlocProvider.of<SpeechRecognitionCubit>(context);
    _speechTextCubit = BlocProvider.of<SpeechTextCubit>(context);
    _formalInterviewResponseCubit =
        BlocProvider.of<FormalInterviewResponseCubit>(context);
    _formalInterviewResponseCubit.resetInitialResponse();
    context.read<TimerCubit>().startTimer();

    _initSpeech();
  }

  @override
  void dispose() {
    super.dispose();
    _speechRecognitionCubit.close();
    _speechTextCubit.close();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    _speechRecognitionCubit.triggerSpeechRecognitionAs(
        recognitionState: _speechEnabled);

    if (_speechRecognitionCubit.state) {
      // Ensure speech recognition is available before starting
      _startListening(); // Automatically start listening when the page is loaded
    }
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    if (!_speechRecognitionCubit.state) {
      _speechRecognitionCubit.triggerSpeechRecognitionAs(
          recognitionState: true);
      _speechTextCubit.triggerText(
          changeInText: "Recognizing the Interviewer's Question...");
    }
    await _speechToText.listen(onResult: (result) {
      log(result.recognizedWords);
      _speechTextCubit.triggerText(changeInText: result.recognizedWords);
      if (!_speechToText.isListening) {
        log("Listening turned off!");
        _speechRecognitionCubit.triggerSpeechRecognitionAs(
            recognitionState: false);
      }
    });
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        context.read<TimerCubit>().stopTimer();
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.lightGreen,
        floatingActionButton: CupertinoButton(
          onPressed: () async {
            if (_speechRecognitionCubit.state) {
              await _speechToText.stop();
              _speechRecognitionCubit.triggerSpeechRecognitionAs(
                  recognitionState: false);
              _speechTextCubit.triggerText(
                  changeInText: "Recognizing the Interviewer's Question...");
            } else {
              _startListening();
            }
          },
          child: BlocBuilder<SpeechRecognitionCubit, bool>(
              builder: (context, state) {
            if (state) {
              return Icon(
                Icons.delete_outline_rounded,
                size: 35.sp,
                color: Colors.red,
              );
            }
            return Icon(
              Icons.refresh,
              size: 35.sp,
              color: AppColors.darkGreen,
            );
          }),
        ),
        bottomNavigationBar: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () async {
            await _speechToText.stop();

            _speechRecognitionCubit.triggerSpeechRecognitionAs(
                recognitionState: false);
            _formalInterviewResponseCubit.fetchResponses(
                question: _speechTextCubit.state);
            Navigator.pushReplacementNamed(context, Routes.responseScreen,
                arguments: _speechTextCubit.state);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.yellow),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Recognition Complete",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          fontFamily: "robo"),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Start Answering",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w300,
                          fontFamily: "robo"),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.2),
                  radius: 20.sp,
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 17.sp,
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
          leading: BlocBuilder<SpeechRecognitionCubit, bool>(
              builder: (context, state) {
            if (state) {
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
            }
            return const SizedBox();
          }),
          title: BlocBuilder<SpeechRecognitionCubit, bool>(
              builder: (context, state) {
            if (state) {
              return RecordingStatus(
                iconColor: AppColors.yellow,
                title: "Recognizing...",
              );
            }
            return Image.asset(
              "assets/images/full_logo.png",
              width: 120.w,
            );
          }),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: BlocBuilder<TimerCubit, int>(
                builder: (context, timeElapsed) {
                  final hours =
                      (timeElapsed ~/ 3600).toString().padLeft(2, '0');
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
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: BlocBuilder<SpeechRecognitionCubit, bool>(
                    builder: (context, recognitionState) {
                  if (recognitionState) {
                    return BlocBuilder<SpeechTextCubit, String>(
                        builder: (context, textState) {
                      return Text(
                        textState.isEmpty
                            ? "Sorry didn't catch that.\nPlease try again!"
                            : textState,
                        style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                            fontFamily: "robo"),
                        textAlign: TextAlign.center,
                      );
                    });
                  }

                  return Text(
                    "Your Interviewer is waiting!\nStart now to get your answers!",
                    style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        fontFamily: "robo"),
                    textAlign: TextAlign.center,
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RecordingStatus extends StatelessWidget {
  final String title;
  final Color iconColor;
  const RecordingStatus(
      {super.key, required this.iconColor, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.grey.shade400),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SpinKitWave(
            color: iconColor,
            size: 15.sp,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
