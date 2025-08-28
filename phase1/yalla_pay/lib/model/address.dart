class Address {
  final String street;
  final String city;
  final String country;

  Address({
    this.street = '',
    this.city = '',
    this.country= '',
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
    );
  }
}