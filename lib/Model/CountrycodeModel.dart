class CountryCode {
  int id;
  String countryCode;

  CountryCode({
    required this.id,
    required this.countryCode,
  });

  factory CountryCode.fromJson(Map<String, dynamic> json) => CountryCode(
        id: json["id"],
        countryCode: json["country_code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "country_code": countryCode,
      };
}
