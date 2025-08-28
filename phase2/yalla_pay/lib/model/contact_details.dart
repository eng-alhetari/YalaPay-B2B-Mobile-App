class ContactDetails {
  final String firstName;
  final String lastName;
  final String email;
  final String mobile;

  ContactDetails({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.mobile = '',
  });

  factory ContactDetails.fromJson(Map<String, dynamic> json) {
    return ContactDetails(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
  return {
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'mobile': mobile, 
  };
}

}