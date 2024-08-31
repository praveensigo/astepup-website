class VideoData {
  int videoId;
  String videoUrl;
  String videoName;
  String presenter;
  String videoDescription;
  Resources resources;

  VideoData({
    required this.videoId,
    required this.videoUrl,
    required this.videoName,
    required this.presenter,
    required this.videoDescription,
    required this.resources,
  });

  factory VideoData.fromJson(Map<String, dynamic> json) => VideoData(
        videoId: json["video_id"],
        videoUrl: json["video_url"] ?? "",
        videoName: json["video_name"] ?? "",
        presenter: json["presenter"] ?? "",
        videoDescription: json["video_description"] ?? "",
        resources: Resources.fromJson(json["resources"]),
      );

  Map<String, dynamic> toJson() => {
        "video_id": videoId,
        "video_url": videoUrl,
        "video_name": videoName,
        "presenter": presenter,
        "video_description": videoDescription,
        "resources": resources.toJson(),
      };
}

class Resources {
  List<Pdf> pdf;
  List<Link> links;

  Resources({
    required this.pdf,
    required this.links,
  });

  factory Resources.fromJson(Map<String, dynamic> json) => Resources(
        pdf: List<Pdf>.from(json["pdf"].map((x) => Pdf.fromJson(x))),
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pdf": List<dynamic>.from(pdf.map((x) => x.toJson())),
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
      };
  bool isEmpty() {
    return pdf.isEmpty && links.isEmpty;
  }
}

class Link {
  int resourceId;
  String resourceName;
  String link;

  Link({
    required this.resourceId,
    required this.resourceName,
    required this.link,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        resourceId: json["resource_id"],
        resourceName: json["resource_name"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "resource_id": resourceId,
        "resource_name": resourceName,
        "link": link,
      };
}

class Pdf {
  int resourceId;
  String resourceName;
  String pdf;

  Pdf({
    required this.resourceId,
    required this.resourceName,
    required this.pdf,
  });

  factory Pdf.fromJson(Map<String, dynamic> json) => Pdf(
        resourceId: json["resource_id"],
        resourceName: json["resource_name"],
        pdf: json["pdf"],
      );

  Map<String, dynamic> toJson() => {
        "resource_id": resourceId,
        "resource_name": resourceName,
        "pdf": pdf,
      };
}
