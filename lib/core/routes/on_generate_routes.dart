import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offer_goose_clone/core/routes/named_routes.dart';
import 'package:offer_goose_clone/cubits/speech_recognition_cubit/speech_recognition_cubit.dart';
import 'package:offer_goose_clone/cubits/speech_text_cubit/speech_text_cubit.dart';
import 'package:offer_goose_clone/feed_screens/formal_interview_screen.dart';
import 'package:offer_goose_clone/feed_screens/home_screen.dart';

import 'package:offer_goose_clone/feed_screens/response_screen.dart';

class GeneratedRoutes {
  static Route generateRoutes(RouteSettings routeSettings) {
    log("Navigating to Route!!!=====>> ${routeSettings.name}");

    switch (routeSettings.name) {
      case Routes.homeScreen:
        return MaterialPageRoute(
            builder: (context) => const HomeScreen(), settings: routeSettings);
      case Routes.formalInterviewScreen:
        return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(providers: [
                  BlocProvider(create: (context) => SpeechRecognitionCubit()),
                  BlocProvider(create: (context) => SpeechTextCubit()),
                  
                ], child: const FormalInterviewScreen()),
            settings: routeSettings);
      

      case Routes.responseScreen:
        return MaterialPageRoute(
            builder: (context) => ResponseScreen(
                  question: routeSettings.arguments as String,
                ),
            settings: routeSettings);

      default:
        return errorScreen();
    }
  }

  static MaterialPageRoute<dynamic> errorScreen() {
    return MaterialPageRoute(
      builder: (context) => const Scaffold(
        body: SafeArea(
          child: Text("Error here!"),
        ),
      ),
    );
  }
}
