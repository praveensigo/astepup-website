// To parse this JSON data, do
//
//     final contributorModel = contributorModelFromJson(jsonString);

import 'dart:convert';

ContributorModel contributorModelFromJson(String str) =>
    ContributorModel.fromJson(json.decode(str));

String contributorModelToJson(ContributorModel data) =>
    json.encode(data.toJson());

class ContributorModel {
  String status;
  List<Datum> data;
  String message;

  ContributorModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory ContributorModel.fromJson(Map<String, dynamic> json) =>
      ContributorModel(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class Datum {
  int id;
  String name;
  String? description;

  Datum({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] ?? "",
        name: json["name"] ?? "",
        description: json["description"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
      };
}
