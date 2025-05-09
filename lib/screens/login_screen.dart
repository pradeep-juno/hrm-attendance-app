import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:hrm_attendance_proj/utils/constants.dart';

import '../controller/login_controller.dart';
import '../utils/functions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final LoginController loginController = Get.put(LoginController());
  bool _obscurePassword = true;


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            child: Stack(
              children: [
                // Background Circles
                const Positioned(
                  bottom: -10,
                  left: -73,
                  child: CircleBlur(),
                ),
                const Positioned(
                  bottom: -60,
                  left: 55,
                  child: CircleBlur2(),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 36),

                      // Back Icon
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Image.asset(
                          'assets/icons/back.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                      const SizedBox(height: 35),

                      // Welcome Back
                      widgetBuildText(AppConstants.welcomeBack, 28, FontWeight.w800, const Color(0xFF00156A)),
                      const SizedBox(height: 12),
                      // Sign In To Started
                      widgetBuildText(AppConstants.signInToStart, 14, FontWeight.w400, Colors.black87),
                      const SizedBox(height: 32),
                      // Logo
                      Center(
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 172,
                          height: 172,
                        ),
                      ),
                       const SizedBox(height: 20),

                      // Username
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF00156A)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: loginController.usernameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: AppConstants.userName,
                            hintStyle: GoogleFonts.montserrat(),
                          ),
                        ),
                      ),

                      // Password
                   // Add this in your State class

                Container(
                margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF00156A)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: loginController.passwordController,
              obscureText: _obscurePassword,
              inputFormatters: [
                LengthLimitingTextInputFormatter(8),
              ],
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: AppConstants.password,
                hintStyle: GoogleFonts.montserrat(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,size: 22,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
          ),


          // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Forgot Password ?",
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ),
SizedBox(height: 20,),
                      // Login Button
                     SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => loginController.loginSubmit(context , ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00156A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 4,
                          shadowColor: const Color(0x1A000000),
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
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Background circle widgets (optional extract for readability)
class CircleBlur extends StatelessWidget {
  const CircleBlur({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 241,
      height: 241,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromRGBO(108, 51, 205, 0.05),
              const Color.fromRGBO(32, 122, 206, 0.05),
            ],
          ),
        ),
      ),
    );
  }
}

class CircleBlur2 extends StatelessWidget {
  const CircleBlur2({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 241,
      height: 241,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromRGBO(236, 29, 143, 0.05),
              const Color.fromRGBO(29, 99, 164, 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
