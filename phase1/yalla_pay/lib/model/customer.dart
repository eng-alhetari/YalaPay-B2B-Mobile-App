import 'package:yalla_pay/model/address.dart';
import 'package:yalla_pay/model/contact_details.dart';

class Customer {
  String id;
  String companyName;
  Address? address;
  ContactDetails? contactDetails;

  Customer({
    this.id = '',
    this.companyName = '',
    this.address,
    this.contactDetails
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
  return Customer(
    id: json['id'] ?? '',
    companyName: json['companyName'] ?? '',
    address: json['address'] != null ? Address.fromJson(json['address']) : null,
    contactDetails: json['contactDetails'] != null ? ContactDetails.fromJson(json['contactDetails']) : null,
  );
}

}