class CMSData {
  String title;
  String content;

  CMSData({
    required this.title,
    required this.content,
  });

  factory CMSData.fromJson(Map<String, dynamic> json) => CMSData(
        title: json["title"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "content": content,
      };
}
