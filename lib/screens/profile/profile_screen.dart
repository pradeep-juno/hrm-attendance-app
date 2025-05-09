import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrm_attendance_proj/router/app_router.dart';

import '../../controller/login_controller.dart';
import '../../utils/functions.dart';



class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
    Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: InkWell(
          onTap: () {
            Get.back();
            print("back button pressed");
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              "assets/icons/back.png",
              height: 24,
              width: 24,
            ),
          ),
        ),
        centerTitle: false,
        title: Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.32,
            color: const Color(0xFF1A1A1A).withOpacity(0.9), // Adjust to match your design
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: () {
                Get.toNamed(AppRouter.EDIT_PROFILE_SCREEN);
              },
              child: Row(
                children: [
                  Icon(Icons.edit, color: Color(0xFF1A1A1A), size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Edit',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1A1A1A),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),

            // Profile Avatar
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage("assets/images/profile.png"), // Replace with your asset
            ),

            const SizedBox(height: 16),


        widgetBuildText(" ${loginController.userName.value}", 18, FontWeight.bold, Colors.black),

            // ID
            widgetBuildText(" ${loginController.userDesignation.value}", 16, FontWeight.w400, Colors.grey),

            const SizedBox(height: 24),
            Divider(thickness: 1, color: Colors.grey[300]),

            // Mail
            ListTile(
              leading: Icon(Icons.email, color: Colors.indigo),
              title: InkWell(
                onTap: () {
                  Get.to(AppRouter.ADMIN_HOME_SCREEN);
                },
                child: Text(
                  'Mail Id',
                  style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Montserrat'),
                ),
              ),
              subtitle: Text('ajaydevk@gmail.com'),
            ),

            // Contact
            ListTile(
              leading: Icon(Icons.phone, color: Colors.indigo),
              title: Text(
                'Contact',
                style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Montserrat'),
              ),
              subtitle: Text('9025689944'),
            ),

            Divider(thickness: 1, color: Colors.grey[300]),

            // Terms & Conditions
            ListTile(
              leading: Icon(Icons.description, color: Colors.black),
              title: Text('Terms & Condition', style: TextStyle(fontFamily: 'Montserrat')),
              onTap: () {
                Get.toNamed(AppRouter.TERMS_AND_CONDITIONS);
              }, // Optional action
            ),

            // Privacy Policy
            ListTile(
              leading: Icon(Icons.security, color: Colors.black),
              title: Text('Privacy policy', style: TextStyle(fontFamily: 'Montserrat')),
              onTap: () {Get.toNamed(AppRouter.PRIVACY_POLICY);}, // Optional action
            ),

            // Rate us
            ListTile(
              leading: Icon(Icons.star_rate_outlined, color: Colors.black),
              title: Text('Rate us on playstore', style: TextStyle(fontFamily: 'Montserrat')),
              onTap: () {}, // Optional action
            ),

            const SizedBox(height: 24),

            // Logout Button
            _buildLogoutButton(),

            const SizedBox(height: 12),

            // App Version
            Text(
              'Version 1.4.20',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontFamily: 'Montserrat',
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),



    ));
  }
  Widget _buildLogoutButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: 180,
        height: 50, // Set a fixed width to make the button narrower
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          onPressed: () {

            showLogoutDialog(context);

          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.logout,
                color: Colors.white, // White color for the icon
              ),
              SizedBox(width: 8),
              Text(
                "Log out",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
