class User {
  final String fullName;
  final String email;
  final String pictureUrl;

  User({required this.fullName, required this.email, required this.pictureUrl});

  factory User.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final picture = json['picture'];
    return User(
      fullName: "${name['title']} ${name['first']} ${name['last']}",
      email: json['email'],
      pictureUrl: picture['large'],
    );
  }
}
