import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrm_attendance_proj/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/login_controller.dart';
import '../router/app_router.dart';
import '../utils/constants.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final LoginController loginController = Get.put(LoginController());
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4FC),
      body: Stack(
        children: [
          // Background Circles
          const Positioned(
            bottom: -10,
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
            bottom: -60,
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

          // Main Scrollable Content
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 48,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            AppConstants.registerCaps,
                            style: GoogleFonts.montserrat(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF00156A),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        buildTextField(
                          controller: loginController.registerUserNameController,
                          hintText: AppConstants.userName,
                        ),
                        const SizedBox(height: 20),
                        buildTextField(
                          controller: loginController.registerPasswordController,
                          hintText: AppConstants.password,
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              size: 22,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(8)
                          ],
                        ),
                        const SizedBox(height: 20),
                        buildTextField(
                          controller: loginController.phoneNoController,
                          hintText: AppConstants.phoneNo,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10)
                          ],
                        ),
                        const SizedBox(height: 20),
                        buildTextField(
                          controller: loginController.emailIdController,
                          hintText: AppConstants.emailId,
                        ),
                        const SizedBox(height: 20),
                        buildTextField(
                          controller: loginController.positionController,
                          hintText: AppConstants.position,
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () async {

                              loginController.registerUser(context
                              );

                              // SharedPreferences prefs =
                              // await SharedPreferences.getInstance();
                              // await prefs.setBool(
                              //     'isAttendanceSuccessDone', true);

                              // Get.offAllNamed(AppRouter.MAIN_NAVIGATION);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00156A),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              AppConstants.register,
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: "Already have an account? ",
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Login',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    color: Color(0xFF00156A),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // Navigate to register screen
                                      Get.to(LoginScreen());
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: GoogleFonts.montserrat(),
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black12),
        ),
      ),
    );
  }
}
