import 'package:shared_preferences/shared_preferences.dart';

class UsersStorageService {
  // Save all user info locally
  static Future<void> saveUserDetails({
    required String uId,
    required String userName,
    required String emailId,
    required String phoneNo,
    required String position,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', uId);
    await prefs.setString('userName', userName);
    await prefs.setString('emailId', emailId);
    await prefs.setString('phoneNo', phoneNo);
    await prefs.setString('position', position);
  }

  // Getters
  static Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('id');
  }

  static Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName');
  }

  static Future<String?> getEmailId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('emailId');
  }

  static Future<String?> getPhoneNo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('phoneNo');
  }

  static Future<String?> getPosition() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('position');
  }

  // Clock-in related flags
  static Future<void> setClockInDone(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isClockInDone', value);
  }

  static Future<bool> getClockInDone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isClockInDone') ?? false;
  }

  static Future<void> setAttendanceSuccessDone(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAttendanceSuccessDone', value);
  }

  static Future<bool> getAttendanceSuccessDone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isAttendanceSuccessDone') ?? false;
  }

  // ================================
  // 🔔 Admin Message - Save and Get
  // ================================
  static Future<void> saveAdminMessage({
    required String adminMessageId,
    required String header,
    required String body,
    required String timestamp,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('adminMessageId', adminMessageId);
    await prefs.setString('adminMessageHeader', header);
    await prefs.setString('adminMessageBody', body);
    await prefs.setString('adminMessageTimestamp', timestamp);
  }

  static Future<String?> getAdminMessageId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('adminMessageId');
  }

  static Future<String?> getAdminMessageHeader() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('adminMessageHeader');
  }

  static Future<String?> getAdminMessageBody() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('adminMessageBody');
  }

  static Future<String?> getAdminMessageTimestamp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('adminMessageTimestamp');
  }

  // Clear everything (on logout)
  static Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
