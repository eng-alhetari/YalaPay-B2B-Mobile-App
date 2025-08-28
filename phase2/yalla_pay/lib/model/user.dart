
class User {
  String id;
  String firstName;
  String lastName;
  String password;
  String email;


  User({
  this.id = '',
  this.firstName = '',
  this.lastName = '',
  this.password = '',
  this.email = '',
  });

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      password: map['password'] ?? '',
      email: map['email'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'password': password,
      'email': email,
    };
  }
}