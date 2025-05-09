class UserModel {
  String uId;
  String userName;
  String password;
  String emailId;
  String phoneNo;
  String position;

  UserModel({
    required this.uId,
    required this.userName,
    required this.password,
    required this.emailId,
    required this.phoneNo,
    required this.position,
  });

  // ✅ From Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uId: map['uId'] ?? '',
      userName: map['userName'] ?? '',
      password: map['password'] ?? '',
      emailId: map['emailId'] ?? '',
      phoneNo: map['phoneNo'] ?? '',
      position: map['position'] ?? '',
    );
  }

  // ✅ To Map
  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'userName': userName,
      'password': password,
      'emailId': emailId,
      'phoneNo': phoneNo,
      'position': position,
    };
  }

  // ✅ To String
  @override
  String toString() {
    return 'UserModel(uId: $uId, userName: $userName, password: $password, emailId: $emailId, phoneNo: $phoneNo, position: $position,)';
  }
}
