import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrm_attendance_proj/router/app_router.dart';
import 'package:hrm_attendance_proj/utils/constants.dart';
import '../utils/app_colors.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({super.key});

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
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
                      'assets/images/splash.png',
                      width: 340,
                      height: 300,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 120), // less space than before
                     Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppConstants.letsGetStarted,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w800,
                          fontSize: 28, // slightly smaller to match visual
                          height: 1.2,
                          color: AppColors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppConstants.loremIpsumDolorSit,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          height: 1.3,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.toNamed(AppRouter.LOGIN_SCREEN);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00156A),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: Text(
                          AppConstants.login,
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      )
                      ,
                    ),
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
