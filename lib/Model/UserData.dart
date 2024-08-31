class UserData {
  int id;
  String name;
  String mobile;
  String email;
  String countryCode;
  int countryCodeId;

  UserData({
    required this.id,
    required this.name,
    required this.mobile,
    required this.email,
    required this.countryCode,
    required this.countryCodeId,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["id"],
        name: json["name"],
        mobile: json["mobile"],
        email: json["email"],
        countryCode: json["country_code"],
        countryCodeId: json["country_code_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "mobile": mobile,
        "email": email,
        "country_code": countryCode,
        "country_code_id": countryCodeId,
      };
}
