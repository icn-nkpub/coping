class User {
  const User({required this.id, required this.email});

  factory User.fromJson(final Map<String, dynamic> json) => User(
      id: json['id'] as String,
      email: json['email'] as String,
    );

  final String id;
  final String email;

  Map<String, dynamic> toJson() => {
      'id': id,
      'email': email,
    };
}


Future<User?> supalogin(final String email, final String password) async => User(id: email, email:email);
Future<User?> suparegister(final String email, final String password) async => supalogin(email, password);
