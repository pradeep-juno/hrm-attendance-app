
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../admin/app_colors.dart';
import '../router/app_router.dart';

Widget widgetBuildText(String text, double fontSize, FontWeight fontWeight, Color color) {
  return Text(
    text,
    style: GoogleFonts.montserrat(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: 1, // Fixes unwanted spacing between lines
    ),
  );
}


//-------------container button function-----------

buildContainerButtonFun(BuildContext context, String title,
    {Color? color,
      Color? borderColor, // Added borderColor for external color
      Function()? onPressed,
      bool isSmallSize = false,
      bool showIcon = true,
      bool isBordered = false,
      double? customHeight,
      double? customWidth}) {
  return InkWell(
      onTap: onPressed,
      child: Container(
          height: customHeight ?? (isSmallSize ? 40 : 44),
          width: customWidth ?? (isSmallSize ? 165 : 298),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: isBordered
                ? Colors.transparent
                : (color ?? Colors.pink), // Default color is pink
            border: isBordered
                ? Border.all(
                color: borderColor ?? Colors.black,
                width: 2) // Border color
                : null, // No border if isBordered is false
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showIcon) ...[
                  // Conditionally render the icon
                  Icon(Icons.add,
                      color: isBordered
                          ? (borderColor ?? Colors.black)
                          : Colors.white, // Icon color based on border
                      size: 16),
                  SizedBox(width: 8), // Space between icon and text
                ],
                buildTextFun(
                  context,

                  title: title,

                  fontsize: 12,
                  fontweight: FontWeight.w800,
                  color: isBordered
                      ? (borderColor ?? Colors.black)
                      : Colors.white, // Text color based on border
                ),
              ],
            ),
          )));
}



Future<void> showLogoutDialog(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Logout Confirmation'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close dialog

              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully'),
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.redAccent,
                  behavior: SnackBarBehavior.floating,
                ),
              );

              Get.offAllNamed(AppRouter.LOGIN_SCREEN);
            },
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
}


//----------------------------------

buildTextFun(BuildContext context,
    {required String title,
      required double fontsize,
      required FontWeight fontweight,
      required Color color,
      int maxLines = 1,
      String? fontFamily}) {
  return Text(
    title,
    style: TextStyle(
        fontSize: fontsize,
        fontWeight: fontweight,
        color: color,
        fontFamily: 'poppins'),
    maxLines: maxLines, // Limits the number of lines to display
    overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
  );
}



buildSizedBoxHeightFun(BuildContext context, {required double height}) {
  return SizedBox(
    height: height,
  );
}

//-----------------------------buildSizedBoxWidthFun-----------------
buildSizedBoxWidthFun(BuildContext context, {required double width}) {
  return SizedBox(
    width: width,
  );
}


void buildScaffoldMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(
          fontSize: 12,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.yellowAccent,
      behavior: SnackBarBehavior.floating));
}








//----------------------------------buildTextFormFieldFunThree-----------------
Widget buildTextFormFieldFunThree(
    BuildContext context, {
      required String hint,
      TextEditingController? controller,
      bool isSmallSize = true,
      required double fontSize,
      TextInputType? keyboardType,
      List<TextInputFormatter>? inputFormatters,
      bool isPassword = false,
      bool prefixIcon = false,
    }) {
  bool obscureText = isPassword; // Initialize obscureText here

  return StatefulBuilder(
    builder: (context, setState) {
      return Container(
        height: isSmallSize ? 40 : 70,
        width: isSmallSize ? 243 : 505,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: ProjectColors.greyColorA6A6A6),
        ),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          obscureText: isPassword ? obscureText : false,
          // Toggle obscureText
          decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
            hintStyle: TextStyle(
                fontSize: fontSize,
                color: ProjectColors.blackColor191919.withOpacity(0.6)),
            contentPadding:
            EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  obscureText = !obscureText; // Toggle the state
                });
              },
            )
                : null,
            prefixIcon: prefixIcon
                ? Icon(
              Icons.currency_rupee,
              size: fontSize + 4, // Adjust size as needed
              color: ProjectColors.blackColor191919.withOpacity(0.6),
            )
                : null,
          ),
        ),
      );
    },
  );
}

Widget buildDatePickerField(
    BuildContext context, {
      required String hint,
      TextEditingController? controller, // Optional controller
      bool isSmallSize = true,
      required double fontSize,
    }) {
  DateTime? selectedDate; // Internal state for date management

  return StatefulBuilder(
    builder: (context, setState) {
      return GestureDetector(
        onTap: () async {
          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );

          if (pickedDate != null) {
            setState(() {
              selectedDate = pickedDate; // Update the internal state
              // Update the controller if provided
              controller?.text = "${pickedDate.toLocal()}".split(' ')[0];
            });
          }
        },
        child: Container(
          height: isSmallSize ? 40 : 70,
          width: isSmallSize ? 243 : 505,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: ProjectColors.greyColorA6A6A6),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          alignment: Alignment.centerLeft,
          child: Text(
            controller != null && controller.text.isNotEmpty
                ? controller.text // Show text from the controller
                : (selectedDate != null
                ? "${selectedDate!.toLocal()}"
                .split(' ')[0] // Show selected date
                : hint), // Show hint if nothing selected
            style: TextStyle(
              fontSize: fontSize,
              color: (controller != null && controller.text.isNotEmpty) ||
                  selectedDate != null
                  ? Colors.black
                  : Colors.grey,
            ),
          ),
        ),
      );
    },
  );
}

buildTextFormFieldFun(
    BuildContext context, {
      String? hint,
      TextEditingController? controller,
      Color? color,
      IconData? icon,
      required bool isPassword,
      TextInputType? keyboardType,
      List<TextInputFormatter>? inputFormatters,
      int maxLines = 1,
      bool? border,
      double? height,
    }) {
  bool obscureText = isPassword;

  return StatefulBuilder(
    builder: (context, setState) {
      return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: border == true
                ? BorderRadius.circular(2.0)
                : BorderRadius.circular(10.0)),
        //height: maxLines == 1 ? 50 : height,
        child: Padding(
          padding: const EdgeInsets.only(right: 10, top: 4),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              prefixIcon: Icon(
                icon,
                color: color,
              ),
              suffixIcon: isPassword
                  ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
              )
                  : null,
            ),
            maxLines: maxLines,
          ),
        ),
      );
    },
  );
}