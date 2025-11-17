import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());
class User {
  late UserClass user;
  late String token;

  User({required this.user, required this.token});

  factory User.fromJson(Map<String, dynamic> json) => User(
    user: UserClass.fromJson(json["user"] ?? {}),
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    if (user != null) "user": user!.toJson(),
    if (token != null) "token": token,
  };
}

class UserClass {
  late int id;
  late String name;
  late String email;
  late dynamic emailVerifiedAt;
  late String createdAt;
  late String updatedAt;
  late int? isActive;
  late dynamic country;
  late dynamic ip;
  late dynamic long;
  late dynamic lat;

  late String password;
  late String confirmationPassword;

  UserClass();


  factory UserClass.fromJson(Map<String, dynamic> json) {
    UserClass user = UserClass();
    user.id = json["id"];
    user.name = json["name"];
    user.email = json["email"];
    user.emailVerifiedAt = json["email_verified_at"];
    user.createdAt = json["created_at"];
    user.updatedAt = json["updated_at"];
    user.isActive = json["isActive"];
    user.country = json["country"];
    user.ip = json["ip"];
    user.long = json["long"];
    user.lat = json["lat"];
    return user;
  }

  Map<String, dynamic> toJson() => {
    if (id != null) "id": id,
    if (name != null) "name": name,
    if (email != null) "email": email,
    if (emailVerifiedAt != null) "email_verified_at": emailVerifiedAt,
    if (createdAt != null) "created_at": createdAt,
    if (updatedAt != null) "updated_at": updatedAt,
    if (isActive != null) "isActive": isActive,
    if (country != null) "country": country,
    if (ip != null) "ip": ip,
    if (long != null) "long": long,
    if (lat != null) "lat": lat,
  };
}
