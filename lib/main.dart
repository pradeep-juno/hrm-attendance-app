import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrm_attendance_proj/router/app_router.dart';
import 'package:hrm_attendance_proj/storage_service/storage_service.dart';
import 'firebase/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  String? userId = await UsersStorageService.getUserId();
  bool isLoggedIn = (userId != null && userId.isNotEmpty);

  bool isClockInDone = await UsersStorageService.getClockInDone();
  bool isAttendanceSuccessDone = await UsersStorageService.getAttendanceSuccessDone();

  String initialRoute;

  if (!isLoggedIn) {
    initialRoute = AppRouter.ONBOARD_SCREEN;
  } else if (!isClockInDone) {
    initialRoute = AppRouter.CLOCK_IN_SCREEN;
  } else if (!isAttendanceSuccessDone) {
    initialRoute = AppRouter.ATTENDANCE_SUCCESS_SCREEN;
  } else {
    initialRoute = AppRouter.MAIN_NAVIGATION;
  }

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: initialRoute,
      getPages: AppRouter.routes,
    );
  }
}
