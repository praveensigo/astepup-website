class About {
    String title;
    String content;

    About({
        required this.title,
        required this.content,
    });

    factory About.fromJson(Map<String, dynamic> json) => About(
        title: json["title"],
        content: json["content"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "content": content,
    };
}
