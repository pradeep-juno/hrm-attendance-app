import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  var userName = ''.obs;
  var position = ''.obs;
  var uId = ''.obs;
  var emailId = ''.obs;
  var phoneNo = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    fetchUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uId.value = prefs.getString('uId') ?? 'Not Available';
    userName.value = prefs.getString('userName') ?? 'No Name';
    position.value = prefs.getString('position') ?? 'No Position';
    emailId.value = prefs.getString('emailId') ?? 'No Email';
    phoneNo.value = prefs.getString('phoneNo') ?? 'No PhoneNo';

    print("User ID: ${uId.value}");
    print("Name: ${userName.value}, Position: ${position.value}");


  }


  Future<void> fetchUserData() async {
    String userId = await SharedPreferences.getInstance().then((prefs) => prefs.getString('uId') ?? "");
    var userData = await FirebaseFirestore.instance.collection('user').doc(userId).get();
    if (userData.exists) {
      userName.value = userData['userName'];
      position.value = userData['position'];
      emailId.value = userData['emailId'];
      phoneNo.value = userData['phoneNo'];
    }
  }



}
