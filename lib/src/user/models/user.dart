import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  const User({
    this.id = '',
    this.name = '',
    this.email = '',
    this.phone = '',
    this.url = '',
    this.lat = 0,
    this.lon = 0,
    this.time = 0,
  });
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  final String id;
  final String name;
  final String email;
  final String phone;
  final String url;
  final double lat;
  final double lon;
  final int time;

  static const empty = User();
  bool get isValid {
    if (name.isNotEmpty &&
        email.isNotEmpty &&
        phone.isNotEmpty &&
        url.isNotEmpty) {
      return true;
    }
    return false;
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? url,
    double? lat,
    double? lon,
    int? time,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      url: url ?? this.url,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      time: time ?? this.time,
    );
  }
}
