class User {
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? birthday;
  const User({this.birthday, this.email, this.fullName, this.phoneNumber});
  factory User.fromJson(Map<String, dynamic> json) => User(
    fullName: json["fullName"],
    email: json["email"],
    phoneNumber: json["phoneNumber"],
    birthday: json["birthday"],
  );
  Map<String, dynamic> toJson() => {
    "fullName": fullName,
    "email": email,
    "phoneNumber": phoneNumber,
    "birthday": birthday,
  };
}
