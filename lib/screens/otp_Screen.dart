import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/otp_controller.dart';

class OtpScreen extends StatelessWidget {
  final OtpController controller = Get.put(OtpController());

  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Phone OTP Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          return Column(
            children: [
              if (!controller.isOtpSent.value) ...[
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: "Enter phone number"),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.sendOtp(phoneController.text),
                  child: Text("Send OTP"),
                ),
              ] else ...[
                TextField(
                  controller: otpController,
                  decoration: InputDecoration(labelText: "Enter OTP"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => controller.verifyOtp(otpController.text),
                  child: Text("Verify OTP"),
                ),
              ],
            ],
          );
        }),
      ),
    );
  }
}
