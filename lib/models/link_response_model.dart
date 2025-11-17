class LinkElement {
  late int id;
  late String title;
  late String link;
  late String? username;
  int isActive = 0;
  late int? userId;
  late String createdAt;
  late String updatedAt;

  LinkElement();

  LinkElement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    link = json['link'];
    username = json['username'];
    isActive = json['isActive'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "link": link,
    "username": username,
    "isActive": isActive,
    "user_id": userId,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
