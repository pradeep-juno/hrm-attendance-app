import 'package:get/get.dart';
import 'package:hrm_attendance_proj/navbar/bottom_nav_bar.dart';
import 'package:hrm_attendance_proj/screens/approval_Queue_Screen.dart';
import 'package:hrm_attendance_proj/screens/attendance_success_screen.dart';

import 'package:hrm_attendance_proj/screens/dashboard_screen.dart';
import 'package:hrm_attendance_proj/screens/login_screen.dart';
import 'package:hrm_attendance_proj/screens/missed_attendence_screen.dart';
import 'package:hrm_attendance_proj/screens/notification_screen.dart';
import 'package:hrm_attendance_proj/screens/on_board_screen.dart';

import '../admin/admin_home_screen.dart';
import '../admin/leave_approval.dart';
import '../screens/annual_leave.dart';

import '../screens/Checkincheckoutscreen.dart';
import '../screens/clockIn_Screen.dart';
import '../screens/clockOut_Screen.dart';
import '../screens/otp_Screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/leave_screen.dart';
import '../screens/profile/privacy_policy.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/terms_conditions.dart';

class AppRouter {

  static const ONBOARD_SCREEN = '/onboard-screen';
  static const LOGIN_SCREEN = '/login-screen';
  static const CLOCK_IN_SCREEN = '/clock-in-screen';
  static const ATTENDANCE_SUCCESS_SCREEN = '/attendance-success-screen';
  static const DASH_BOARD_SCREEN = '/dash-board-screen';
  static const NOTIFICATION_LIST_SCREEN = '/notification-list-screen';
  static const MAIN_NAVIGATION = '/main-navigation';
  static const CHECK_IN_OUT_SCREEN = '/check-in-screen';
  static const CHECK_OUT_SCREEN = '/check-out-screen';
  static const APPROVAL_QUEUE_SCREEN = '/app-request-screen';
  static const LEAVE_SCREEN = '/leave-screen';
  static const MISSED_ATTENDANCE_SCREEN = '/missed-attendance';
  static const CHECKIN_CHECKOUT_SCREEN  = '/checkin-checkout';
  static const ANNUAL_LEAVE  = '/annual-leave';
  static const EDIT_PROFILE_SCREEN  = '/edit-profile-screen';
  static const TERMS_AND_CONDITIONS  = '/terms-and-conditions';
  static const PRIVACY_POLICY  = '/privacy-policy';
  static const PROFILE_SCREEN  = '/profile-screen';
  static const ADMIN_HOME_SCREEN  = '/admin-home-screen';
  static const OTP_SCREEN  = '/otp-screen';
  static const LEAVE_APP  = '/leave-app';













  static var routes = [
GetPage(name: ONBOARD_SCREEN, page: () => OnBoardScreen(), transition: Transition.fade,),
  GetPage(name: LOGIN_SCREEN, page: () => LoginScreen(),transition: Transition.fade),
    GetPage(name: CLOCK_IN_SCREEN, page: () => ClockInScreen(),transition:Transition.fade ),
    GetPage(name: ATTENDANCE_SUCCESS_SCREEN, page: () => AttendanceSuccessScreen(),transition:Transition.fade ),
    GetPage(name: DASH_BOARD_SCREEN, page: () => DashboardScreen(),transition:Transition.fade ),
    GetPage(name: NOTIFICATION_LIST_SCREEN, page: () => NotificationListScreen(),transition:Transition.fade ),
    GetPage(name: MAIN_NAVIGATION, page: () => MainNavigation(),transition:Transition.fade ),
    GetPage(name: APPROVAL_QUEUE_SCREEN, page: ()=> ApprovalQueueScreen()),
    GetPage(name: LEAVE_SCREEN, page: ()=> LeaveScreen()),
    GetPage(name: MISSED_ATTENDANCE_SCREEN, page: ()=> MissedAttendanceScreen()),
    GetPage(name: CHECK_IN_OUT_SCREEN, page: ()=> Checkincheckoutscreen()),
    GetPage(name: ANNUAL_LEAVE, page: ()=> AnnualLeave()),
    GetPage(name: EDIT_PROFILE_SCREEN, page: ()=> EditProfileScreen()),
    GetPage(name: TERMS_AND_CONDITIONS ,page: ()=> TermsConditions()),
    GetPage(name: PRIVACY_POLICY ,page: ()=> PrivacyPolicy()),
    GetPage(name: PROFILE_SCREEN, page: ()=> ProfileScreen()),
    GetPage(name: ADMIN_HOME_SCREEN, page: ()=> AdminHomeScreen()),
    GetPage(name: CHECK_OUT_SCREEN, page: ()=> ClockOutScreen()),
    GetPage(name: OTP_SCREEN, page: ()=> OtpScreen()),
    GetPage(name: LEAVE_APP, page: ()=> LeaveApp()),














  ];
}