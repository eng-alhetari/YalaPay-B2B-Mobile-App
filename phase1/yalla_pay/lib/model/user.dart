class User {
  String firstName;
  String lastName;
  String password;
  String email;


  User({
  this.firstName = '',
  this.lastName = '',
  this.password = '',
  this.email = '',
  });

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      password: map['password'] ?? '',
      email: map['email'] ?? '',
    );
  }
}