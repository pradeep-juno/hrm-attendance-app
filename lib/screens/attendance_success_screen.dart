import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../router/app_router.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';

class AttendanceSuccessScreen extends StatefulWidget {
  const AttendanceSuccessScreen({super.key});

  @override
  State<AttendanceSuccessScreen> createState() => _AttendanceSuccessScreenState();
}

class _AttendanceSuccessScreenState extends State<AttendanceSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(
            child: Text(
              AppConstants.attendenceSuccess,
              style: TextStyle(
                color: AppColors.blue,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),

        ),
        body: Stack(
          children: [
            // Background Ellipses
            const Positioned(
              bottom: -10, // moved lower
              left: -73,
              child: SizedBox(
                width: 241,
                height: 241,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(108, 51, 205, 0.05),
                        Color.fromRGBO(32, 122, 206, 0.05),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Positioned(
              bottom: -60, // moved lower
              left: 55,
              child: SizedBox(
                width: 241,
                height: 241,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(236, 29, 143, 0.05),
                        Color.fromRGBO(29, 99, 164, 0.05),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Main Content
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24,),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Image.asset(
                      'assets/images/success.png',
                      width: 148,
                      height: 148,
                      fit: BoxFit.contain,
                    ),
                    // less space than before

                    const SizedBox(height: 48),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        AppConstants.attendenceSubmittedSuccessfully,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          height: 1.3,
                          color: AppColors.blue,
                          letterSpacing: 0.2
                        ),
                      ),
                    ),
                    const SizedBox(height: 52),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('isAttendanceSuccessDone', true);

                          // Now go to Dashboard/Main Screen
                          Get.offAllNamed(AppRouter.MAIN_NAVIGATION);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00156A),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          AppConstants.goToDashboard,
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      )
                      ,
                    ),

                    SizedBox(height: 320,),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
