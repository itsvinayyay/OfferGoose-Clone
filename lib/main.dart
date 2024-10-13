import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:offer_goose_clone/core/routes/on_generate_routes.dart';
import 'package:offer_goose_clone/cubits/formal_interview_response_cubit/formal_interview_response_cubit.dart';
import 'package:offer_goose_clone/cubits/timer_cubit/timer_cubit.dart';
import 'package:offer_goose_clone/feed_screens/home_screen.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TimerCubit()),
        BlocProvider(create: (context) => FormalInterviewResponseCubit())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          onGenerateRoute: GeneratedRoutes.generateRoutes,
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            useMaterial3: true,
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}
