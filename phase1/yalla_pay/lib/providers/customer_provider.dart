import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yalla_pay/model/address.dart';
import 'package:yalla_pay/model/contact_details.dart';
import 'package:yalla_pay/model/customer.dart';

class CustomerNotifier extends Notifier<List<Customer>> {
  int assignableID = 0;
  @override
  List<Customer> build() {
    initializeCustomers();
    return [];
  }

  // Load and initialize customers from the JSON file
  void initializeCustomers() async {
    String data = await rootBundle.loadString('assets/data/customers.json');
    var customerList = jsonDecode(data);
    List<Customer> customers = [];
    customerList.forEach((element) => customers.add(Customer.fromJson(element)));
    for (var element in customers) {
      if (int.parse(element.id) > assignableID){
        assignableID = int.parse(element.id);
      }
    }
    state = customers;
  }

  void addCustomer({
    required String companyName, 
    required String firstName,
    required String lastName,
    required String email,
    required String mobile,
    required String street,
    required String city,
    required String country}) {
    
    Customer customer = Customer(
      id: (assignableID + 1).toString(),
      companyName: companyName,
      contactDetails: ContactDetails(
        firstName: firstName,
        lastName: lastName,
        email: email,
        mobile: mobile
      ),
      address: Address(
        street: street,
        city: city,
        country: country
      )
    );

    assignableID ++;
    state = [...state, customer];
  }

  void updateCustomer({
    required String id,
    required String companyName, 
    required String firstName,
    required String lastName,
    required String email,
    required String mobile,
    required String street,
    required String city,
    required String country}){
      
    Customer newCustomer = Customer(
      id: id,
      companyName: companyName,
      contactDetails: ContactDetails(
        firstName: firstName,
        lastName: lastName,
        email: email,
        mobile: mobile
      ),
      address: Address(
        street: street,
        city: city,
        country: country
      )
    );
    for (var x in state){
      if (x.id == newCustomer.id){
        state[state.indexOf(x)] = newCustomer;
      }
    }
    var temp = state;
    state = [];
    state = temp;
  }

  void deleteCustomer(String id){
    state = state.where((c) => c.id != id).toList();
  }

  Customer getCustomerById(String id){
    return state.firstWhere((c) => c.id == id);
  }

  List<Customer> searchByCompanyName(String companyName) {
    return state
        .where((customer) =>
            customer.companyName.toLowerCase().contains(companyName.toLowerCase()))
        .toList();
  }

  List<Customer> filterByCountry(String country) {
    return state
        .where((customer) => customer.address?.country.toLowerCase() == country.toLowerCase())
        .toList();
  }
}

final customerNotifierProvider =
    NotifierProvider<CustomerNotifier, List<Customer>>(() => CustomerNotifier());
