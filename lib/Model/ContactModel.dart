class ContactData {
  String mobile;
  int countryCodeId;
  String email;
  String address;
  String latitude;
  String longitude;
  CountryCode countryCode;

  ContactData({
    required this.mobile,
    required this.countryCodeId,
    required this.email,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.countryCode,
  });

  factory ContactData.fromJson(Map<String, dynamic> json) => ContactData(
        mobile: json["mobile"],
        countryCodeId: json["country_code_id"],
        email: json["email"],
        address: json["address"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        countryCode: CountryCode.fromJson(json["country_code"]),
      );

  Map<String, dynamic> toJson() => {
        "mobile": mobile,
        "country_code_id": countryCodeId,
        "email": email,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "country_code": countryCode.toJson(),
      };
}

class CountryCode {
  int id;
  String countryCode;
  int mobileLength;
  String countryName;
  CountryCode({
    required this.id,
    required this.countryCode,
    required this.mobileLength,
    required this.countryName,
  });

  factory CountryCode.fromJson(Map<String, dynamic> json) => CountryCode(
        id: json["id"],
        countryCode: json["country_code"],
        mobileLength: json["mobile_length"],
        countryName: json["country_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "country_code": countryCode,
        "mobile_length": mobileLength,
        "country_name": countryName,
      };
}
