class MaintenanceData {
  int maintenanceWeb;
  String maintenanceReasonWeb;

  MaintenanceData({
    required this.maintenanceWeb,
    required this.maintenanceReasonWeb,
  });

  factory MaintenanceData.fromJson(Map<String, dynamic> json) =>
      MaintenanceData(
        maintenanceWeb: json["maintenance_web"] ?? 0,
        maintenanceReasonWeb: json["maintenance_reason_web"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "maintenance_web": maintenanceWeb,
        "maintenance_reason_web": maintenanceReasonWeb,
      };
}
